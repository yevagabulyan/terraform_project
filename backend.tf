resource "aws_s3_bucket" "my_state_practice_last12345bdg" {
  bucket = "mystatepracticebdg"

  #lifecycle {
  # prevent_destroy = true
  #}
}

resource "aws_s3_bucket_versioning" "my_state_practice_last12345bdg" {
  bucket = aws_s3_bucket.my_state_practice_last12345bdg.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "app-state"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
