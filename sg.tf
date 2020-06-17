

resource "aws_security_group" "alb_access" {
  name        = "Acesso ao Kibana"
  description = "Permite acesso a instancia do Nginx"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 5044
    to_port   = 5044
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 9200
    to_port   = 9300
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_security_group" "access_to_elastisearch" {
  name        = "Acesso ao Elasticsearch"
  description = "Permite acesso ao eks a partir da maquina aonde esta o filebeat"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5044
    to_port         = 5044
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_access.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_security_group" "access_to_logstash" {
  name        = "Acesso ao Logstash"
  description = "Permite acesso ao eks a partir da maquina aonde esta o logstash"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5601
    to_port         = 5601
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_access.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_security_group" "ssh_eks_instance" {
  name        = "Acesso ao Kibana via SSH"
  description = "Permite acesso ssh a instancia do Nginx"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["187.50.171.186/32",
                    "177.68.148.213/32"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

