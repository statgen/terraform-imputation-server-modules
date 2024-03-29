#!/bin/bash

if grep -q "Amazon Linux * 2" /etc/*release ; then
  yum install openscap-scanner scap-security-guide -y
  scriptFile="/usr/share/xml/scap/ssg/content/ssg-amzn2-ds.xml"
  profile=${scap_profile_name}
elif grep -q "Amazon Linux" /etc/*release ; then
  yum install openscap-scanner scap-security-guide -y
  scriptFile="/usr/share/xml/scap/ssg/content/ssg-amzn1-ds.xml"
  profile=${scap_profile_name}
elif grep -q "Ubuntu" /etc/*release ; then
  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install libopenscap8 ssg-base ssg-debderived ssg-debian ssg-nondebian ssg-applications -y
  scriptFile="/usr/share/xml/scap/ssg/content/ssg-ubuntu1604-ds.xml"
  profile=xccdf_org.ssgproject.content_profile_standard
else
  echo "Running neither Amazon Linux or Ubuntu!"
fi
if [ "$scriptFile" ] ; then
  sed -i 's/multicheck="true"/multicheck="false"/g' $scriptFile
  oscap xccdf eval --fetch-remote-resources --profile $profile --results-arf arf.xml --report report.html $scriptFile
fi
instanceId=$(curl http://169.254.169.254/latest/meta-data/instance-id)
timestamp=$(date +%s)
/usr/bin/aws s3 cp arf.xml s3://${scap_bucket_name}/results/"$instanceId"/"$timestamp"-scap-results.xml
/usr/bin/aws s3 cp report.html s3://${scap_bucket_name}/results/"$instanceId"/"$timestamp"-scap-results.html