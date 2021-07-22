# ---------------------------------------------------------------------------------------------------------------------
# UPLOAD FILES FOR IMPUTATION SERVER BOOTSTRAP
# ---------------------------------------------------------------------------------------------------------------------

locals {
  data_path                                = "bucket-data"
  pages_path                               = "${local.data_path}/pages"
  images_path                              = "${local.pages_path}/images"
  bootstrap_path                           = "${local.data_path}/bootstrap.sh"
  apps_file_path                           = "${local.data_path}/apps.yaml"
  settings_file_path                       = "${local.data_path}/settings.yaml"
  cloudgene_conf_path                      = "${local.data_path}/cloudgene.conf"
  clougene_aws_path                        = "${local.data_path}/cloudgene-aws"
  home_page_path                           = "${local.pages_path}/home.stache"
  about_page_path                          = "${local.pages_path}/about.stache"
  contact_page_path                        = "${local.pages_path}/contact.stache"
  control_png_path                         = "${local.images_path}/control.png"
  docker_svg_path                          = "${local.images_path}/docker.svg"
  down_cloud_png_path                      = "${local.images_path}/down-cloud.png"
  hosting_png_path                         = "${local.images_path}/hosting.png"
  impute_png_path                          = "${local.images_path}/impute.png"
  michigan_imputation_server_logo_png_path = "${local.images_path}/michigan-imputation-server-logo.png"
  tis_logo_png_path                        = "${local.images_path}/tis-logo.png"
  nhlbi_biodata_catalyst_logo_png_path     = "${local.images_path}/nhlbi-biodata-catalyst-logo.png"
  nhlbi_topmed_logo_png_path               = "${local.images_path}/nhlbi-topmed-logo.png"
  secure_png_path                          = "${local.images_path}/secure.png"
  um_sph_jpg_path                          = "${local.images_path}/UM-SPH.jpg"
  up_cloud_png_path                        = "${local.images_path}/up-cloud.png"
}

resource "aws_s3_bucket_object" "bootstrap_script" {
  bucket = var.bucket_name
  key    = "bootstrap.sh"
  source = local.bootstrap_path

  etag = filemd5(local.bootstrap_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "apps_file" {
  bucket = var.bucket_name
  key    = "apps.yaml"
  source = local.apps_file_path

  etag = filemd5(local.apps_file_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "settings_file" {
  bucket = var.bucket_name
  key    = "configuration/config/settings.yaml"
  source = local.settings_file_path

  etag = filemd5(local.settings_file_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "cloudgene_conf" {
  bucket = var.bucket_name
  key    = "configuration/cloudgene.conf"
  source = local.cloudgene_conf_path

  etag = filemd5(local.cloudgene_conf_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "cloudgene_aws" {
  bucket = var.bucket_name
  key    = "configuration/cloudgene-aws"
  source = local.clougene_aws_path

  etag = filemd5(local.clougene_aws_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "home_page" {
  bucket = var.bucket_name
  key    = "configuration/pages/home.stache"
  source = local.home_page_path

  etag = filemd5(local.home_page_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "about_page" {
  bucket = var.bucket_name
  key    = "configuration/pages/about.stache"
  source = local.about_page_path

  etag = filemd5(local.about_page_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "contact_page" {
  bucket = var.bucket_name
  key    = "configuration/pages/contact.stache"
  source = local.contact_page_path

  etag = filemd5(local.contact_page_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "control_png" {
  bucket = var.bucket_name
  key    = "configuration/pages/images/control.png"
  source = local.control_png_path

  etag = filemd5(local.control_png_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "docker_svg" {
  bucket = var.bucket_name
  key    = "configuration/pages/images/docker.svg"
  source = local.docker_svg_path

  etag = filemd5(local.docker_svg_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "down_cloud_png" {
  bucket = var.bucket_name
  key    = "configuration/pages/images/down-cloud.png"
  source = local.down_cloud_png_path

  etag = filemd5(local.down_cloud_png_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "hosting_png" {
  bucket = var.bucket_name
  key    = "configuration/pages/images/hosting.png"
  source = local.hosting_png_path

  etag = filemd5(local.hosting_png_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "impute_png" {
  bucket = var.bucket_name
  key    = "configuration/pages/images/impute.png"
  source = local.impute_png_path

  etag = filemd5(local.impute_png_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "michigan_imputation_server_logo_png" {
  bucket = var.bucket_name
  key    = "configuration/pages/images/michigan-imputation-server-logo.png"
  source = local.michigan_imputation_server_logo_png_path

  etag = filemd5(local.michigan_imputation_server_logo_png_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "tis_logo_png_path" {
  bucket = var.bucket_name
  key    = "configuration/pages/images/tis-logo.png"
  source = local.tis_logo_png_path

  etag = filemd5(local.tis_logo_png_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "nhlbi_biodata_catalyst_logo_png" {
  bucket = var.bucket_name
  key    = "configuration/pages/images/nhlbi-biodata-catalyst-logo.png"
  source = local.nhlbi_biodata_catalyst_logo_png_path

  etag = filemd5(local.nhlbi_biodata_catalyst_logo_png_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "nhlbi_topmed_logo_png" {
  bucket = var.bucket_name
  key    = "configuration/pages/images/nhlbi-topmed-logo.png"
  source = local.nhlbi_topmed_logo_png_path

  etag = filemd5(local.nhlbi_topmed_logo_png_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "secure_png" {
  bucket = var.bucket_name
  key    = "configuration/pages/images/secure.png"
  source = local.secure_png_path

  etag = filemd5(local.secure_png_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "um_sph_jpg" {
  bucket = var.bucket_name
  key    = "configuration/pages/images/UM-SPH.jpg"
  source = local.um_sph_jpg_path

  etag = filemd5(local.um_sph_jpg_path)

  tags = var.tags
}

resource "aws_s3_bucket_object" "up_cloud_png" {
  bucket = var.bucket_name
  key    = "configuration/pages/images/up-cloud.png"
  source = local.up_cloud_png_path

  etag = filemd5(local.up_cloud_png_path)

  tags = var.tags
}