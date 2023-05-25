
# Create an S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-name"  # Set your desired bucket name here
  acl    = "private"
}

# Create an IAM user
resource "aws_iam_user" "example_user" {
  name = "example-user"  # Set your desired username here
}

# Create an IAM policy to allow PutObject in the S3 bucket
resource "aws_iam_policy" "example_policy" {
  name   = "example-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowPutObject",
      "Effect": "Allow",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.example_bucket.id}/*"
    }
  ]
}
EOF
}

# Attach the policy to the IAM user
resource "aws_iam_user_policy_attachment" "example_policy_attachment" {
  user       = aws_iam_user.example_user.name
  policy_arn = aws_iam_policy.example_policy.arn
}

# Create an assumable IAM role
resource "aws_iam_role" "example_role" {
  name = "example-role"  # Set your desired role name here

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${aws_iam_user.example_user.name}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Create an IAM role policy to allow PutObject in the S3 bucket
resource "aws_iam_role_policy" "example_role_policy" {
  role      = aws_iam_role.example_role.name
  policy    = aws_iam_policy.example_policy.policy
  policy_arn = aws_iam_policy.example_policy.arn
}

# User assumes the role and puts an empty file in the S3 bucket
resource "aws_iam_user_policy_attachment" "assume_role_policy_attachment" {
  user       = aws_iam_user.example_user.name
  policy_arn = aws_iam_role.example_role.arn
}

resource "aws_s3_bucket_object" "example_object" {
  bucket = aws_s3_bucket.example_bucket.id
  key    = aws_iam_user.example_user.name
  source = "/dev/null"  # Empty file

  depends_on = [aws_iam_user_policy_attachment.assume_role_policy_attachment]
}

data "aws_caller_identity" "current" {}

