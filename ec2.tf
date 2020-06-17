resource "aws_key_pair" "kibana_instance" {
  key_name   = "key_pair_kibana"
  public_key = file("./ssh_key_pair/kibana-cluster.pub")

}

resource "aws_instance" "elasticsearch_server" {
  ami           = var.ami
  instance_type = var.instance
  key_name      = aws_key_pair.kibana_instance.key_name
  user_data     = file("./install_script/elasticsearch.sh")

  iam_instance_profile = aws_iam_instance_profile.ssh_s3_bitbucket.name
  security_groups = [aws_security_group.alb_access.name,
    aws_security_group.ssh_eks_instance.name,
    aws_security_group.access_to_elastisearch.name
  ]
  tags = {
    Name = "Elasticsearch"
  }
}

resource "aws_instance" "elasticsearch_server_warm" {
  ami           = var.ami
  instance_type = var.instance
  key_name      = aws_key_pair.kibana_instance.key_name
  user_data     = file("./install_script/logstash.sh")

  iam_instance_profile = aws_iam_instance_profile.ssh_s3_bitbucket.name
  security_groups = [aws_security_group.alb_access.name,
    aws_security_group.ssh_eks_instance.name,
    aws_security_group.access_to_elastisearch.name
  ]
  tags = {
    Name = "Elasticsearch-Warm"
  }
}

resource "aws_instance" "kibana_server" {
  ami           = var.ami
  instance_type = var.instance
  key_name      = aws_key_pair.kibana_instance.key_name
  user_data     = file("./install_script/kibana.sh")

  iam_instance_profile = aws_iam_instance_profile.ssh_s3_bitbucket.name
  security_groups = [aws_security_group.alb_access.name,
    aws_security_group.ssh_eks_instance.name,
    aws_security_group.access_to_elastisearch.name
  ]
  tags = {
    Name = "Kibana"
  }
}


resource "aws_instance" "logstash_server" {
  ami           = var.ami
  instance_type = var.instance
  key_name      = aws_key_pair.kibana_instance.key_name
  user_data     = file("./install_script/logstash.sh")

  iam_instance_profile = aws_iam_instance_profile.ssh_s3_bitbucket.name
  security_groups = [aws_security_group.alb_access.name,
    aws_security_group.ssh_eks_instance.name,
    aws_security_group.access_to_logstash.name,
    aws_security_group.access_to_elastisearch.name
  ]
  tags = {
    Name = "Logstash"
  }
}



resource "aws_instance" "elasticsearch_apm" {
  ami           = var.ami
  instance_type = var.instance
  key_name      = aws_key_pair.kibana_instance.key_name
  user_data     = file("./install_script/logstash.sh")

  iam_instance_profile = aws_iam_instance_profile.ssh_s3_bitbucket.name
  security_groups = [aws_security_group.alb_access.name,
    aws_security_group.ssh_eks_instance.name,
    aws_security_group.access_to_elastisearch.name
  ]
  tags = {
    Name = "Elasticsearch-APM"
  }
}




