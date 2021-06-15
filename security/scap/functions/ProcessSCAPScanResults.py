# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import json
import boto3
import datetime
from datetime import date
import xml.etree.ElementTree as ET 

s3 = boto3.client('s3')
cloudWatch = boto3.client('cloudwatch')
dynamodb = boto3.resource('dynamodb')
securityHub = boto3.client('securityhub')
ssmClient = boto3.client('ssm')


def lambda_handler(event, context):
    
    # get the bucket name so that we can get the file from s3
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']
    aws_account_id = context.invoked_function_arn.split(":")[4]
    region = context.invoked_function_arn.split(":")[3]
    
    #get the instance id from the s3 path
    instanceId = file_key.split('/')[0]
    
    # get the object
    scap_report = s3.get_object(Bucket=bucket_name, Key=file_key)

    # parse the XML from s3
    root = ET.fromstring(scap_report['Body'].read())
    
    # Get parameter for using Security Hub
    useSecurityHub = ssmClient.get_parameter(Name='/SCAPTesting/EnableSecurityHub')['Parameter']['Value']
    
    # get the resutls node from the xml
    testResult = root.find(".//{http://checklists.nist.gov/xccdf/1.2}TestResult")
    testVersion = testResult.attrib.get("version") 
    
    # setup counts for cloudwatch metrics
    high=0
    medium=0
    low=0
    unknown=0
    
    
    # load the ignore list from DynamoDB
    ignoreList = getIgnoreList()
    
    # setup arrays to hold the findings so we can do batch inserts
    dynamoDbItems = []
    securityHubFindings = []
    
    # iterate through each result item
    for item in testResult: 
        testId = str(item.attrib.get("idref"))

        # We need to normalize the rule name here to check agains the
        # ignore list
        if '.' in testId:
            testId = testId[testId.rindex('.')+1:len(testId)]
        
        # if we are not ignoring the result, them count it and store in DynamoDB
        if testId not in ignoreList:
            if(item.findtext('{http://checklists.nist.gov/xccdf/1.2}result') == "fail"):
                buildDynamoDBList(dynamoDbItems, instanceId, item, bucket_name, file_key)
                if useSecurityHub == "true" and item.attrib.get("severity") in ["high","medium","low"]:
                    buildSecurityHubFindingsList(securityHubFindings,root, instanceId, item, region, aws_account_id, testVersion, bucket_name, file_key)
                if(item.attrib.get("severity") == "high"):
                    high+=1
                elif(item.attrib.get("severity") == "medium"):
                    medium+=1
                elif(item.attrib.get("severity") == "low"):
                    low+=1
                elif(item.attrib.get("severity") == "unknown"):
                    unknown+=1
            
    # Send metrics to cloudwatch for alerting        
    sendMetric(high, 'SCAP High Finding', instanceId)
    sendMetric(medium, 'SCAP Medium Finding', instanceId)
    sendMetric(low, 'SCAP Low Finding', instanceId)
    
    # Batch write all findings to DynamoDB
    table = dynamodb.Table('SCAP_Scan_Results')
    with table.batch_writer() as batch:
        for item in dynamoDbItems:
            batch.put_item(
                Item = item
            )
    
    # if Security Hub is enabled, send the results in batches of 100
    if useSecurityHub == "true":
        myfindings = securityHubFindings
        try:
            findingsLeft = True
            startIndex = 0
            stopIndex = len(myfindings)

            # Loop through the findings sending 100 at a time to Security Hub
            while findingsLeft:
                stopIndex = startIndex + 100
                if stopIndex > len(securityHubFindings):
                    stopIndex = len(securityHubFindings)
                    findingsLeft = False
                else:
                    stopIndex = 100
                myfindings = securityHubFindings[startIndex:stopIndex]
                # submit the finding to Security Hub
                result = securityHub.batch_import_findings(Findings = myfindings)
                startIndex = startIndex + 100

                # print results to CloudWatch
                print(result)
        except Exception as e:
            print("An error has occurred saving to Security Hub: " + str(e))
            

# Saves the results to DynamoDB   
def buildDynamoDBList(dynamoDbItems, instanceId, item, bucket_name, file_key):
    #table = dynamodb.Table('SCAP_Scan_Results')
    #table.put_item(
    dynamoDbItems.append({
            'InstanceId': instanceId,
            'SCAP_Rule_Name': item.attrib.get("idref"),
            'time': item.attrib.get("time"), 
            'severity':  item.attrib.get("severity"),
            'result': item.findtext('{http://checklists.nist.gov/xccdf/1.2}result'),
            'report_url': 's3://'+ bucket_name + "/" + file_key.replace('.xml', '.html')
            }
    )


# method for creating the metrics
def sendMetric(value, title, instanceId):
    cloudWatch.put_metric_data(
        Namespace='Compliance',
        MetricData=[
            {
                'MetricName': title,
                'Dimensions': [
                    {
                        'Name': 'InstanceId',
                        'Value': instanceId
                    },
                ],
                'Value': value
            }
        ]
    )

# fetches the ignore list from DynamoDB    
def getIgnoreList():
    table = dynamodb.Table('SCAP_Scan_Ignore_List')
    #if you list is really long this could fail as it will pagonate
    response = table.scan()
    list = response['Items']
    returnList = []
    for item in list:
        returnList.append(item['SCAP_Rule_Name'])
    return returnList
    
def buildSecurityHubFindingsList(securityHubFindings, root, instanceId, item, region, aws_account_id, testVersion, bucket_name, file_key):
    rule = root.find(".//{http://checklists.nist.gov/xccdf/1.2}Rule[@id='" + item.attrib.get("idref") + "']")
    profile = root.find('.//{http://checklists.nist.gov/xccdf/1.2}Profile[@id="xccdf_org.ssgproject.content_profile_stig-rhel7-disa"]')

    # fix the time format from OpenSCAP to Security Hub
    time = item.attrib.get("time")
    if time.find('+') != -1:
        time = time[:time.rindex('+')]
    time =  time + ".000Z"
    
    securityHubFindings.append(
            {
                'SchemaVersion': '2018-10-08',
                'Id': item.attrib.get("idref") + "_" + file_key,
                'ProductArn': 'arn:aws:securityhub:' + region + ':'+ aws_account_id +':product/' + aws_account_id + '/default',
                'GeneratorId': 'OpenSCAP ' + item.attrib.get("idref"),
                'AwsAccountId': aws_account_id,
                'Types': [
                    'Software and Configuration Checks',
                ],
                'FirstObservedAt': time,
                'LastObservedAt': time,
                'CreatedAt': time,
                'UpdatedAt': time,
                'Severity': {
                    'Label': item.attrib.get("severity").upper()
                },
                'Title': rule.findtext('{http://checklists.nist.gov/xccdf/1.2}title'),
                'Description': str(rule.findtext('{http://checklists.nist.gov/xccdf/1.2}description')) + " ",
                'Remediation': {
                    'Recommendation': {
                        'Text': 'For remediation please see: s3://'+ bucket_name + '/' + file_key.replace('.xml', '.html')
                    }
                },
                'ProductFields': {
                    "ProviderName": profile.findtext('{http://checklists.nist.gov/xccdf/1.2}title'),
                    "ProviderVersion": testVersion
                },
                'Resources': [
                    {
                        'Type': 'AwsEc2Instance',
                        'Id': instanceId,
                        'Region': region
                    },
                ],
                'Compliance': {
                    'Status': 'FAILED'
                },
                'WorkflowState': 'NEW',
                'Workflow': {
                    'Status': 'NEW'
                }
            })