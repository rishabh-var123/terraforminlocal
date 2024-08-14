resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-tf-bucket-${random_id.rand_id.hex}"

}
resource "aws_s3_object" "html_object" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  source = "./index.html"
  key    = "index.html"
  content_type = "text/html"

}
resource "aws_s3_object" "css_object" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  source = "./styles.css"
  key    = "styles.css"
  content_type = "text/css"

}

resource "random_id" "rand_id" {
  byte_length = 8
}


resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid       = "PublicReadGetObject",
          Effect    = "Allow",
          Principal = "*",
          Action    = "s3:GetObject",
          Resource  = "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}/*"
        }
      ]
    }
  )
}
resource "aws_s3_bucket_website_configuration" "aws_config" {
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = "index.html"
  } 
}

output "display" {
  value = "S3 Bucket name ${aws_s3_bucket.s3_bucket.bucket_domain_name}"
}

output "display_url" {
  value = "s3 url: ${aws_s3_bucket_website_configuration.aws_config.website_endpoint}"
  
}