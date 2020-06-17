resource "aws_iam_role" "s3-ssh-role" {
  name               = "s3-sshkey-role"
  assume_role_policy = file("./iam_role/aws_iam_role.json")

}

resource "aws_iam_instance_profile" "ssh_s3_bitbucket" {
  name = "bitbucket-deploy-ssh"
  role = aws_iam_role.s3-ssh-role.name
}



data "aws_iam_policy_document" "example" {
  statement {
    sid = "GetSSHKeysFromBucket"
    actions = [
      "s3:*",
    ]
    resources = [
      "arn:aws:s3:::sshkeyeks",
      "arn:aws:s3:::sshkeyeks/*"
    ]
  }

  statement {
    sid = "AcessToListBuckets"
    actions = [
      "s3:ListAllMyBuckets",
    ]
    resources = [
      "arn:aws:s3:::*"
    ]
  }
}

resource "aws_iam_role_policy" "s3_ssh_access_policy" {
  name   = "copy-ssh-for-bitbucket"
  role   = aws_iam_role.s3-ssh-role.id
  policy = data.aws_iam_policy_document.example.json

}


