#LOADBALANCE PARA O ELASTICSEARCH


resource "aws_lb" "elasticsearch_alb" {
  name               = "elasicsearch-cluster-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets_id
  security_groups    = [aws_security_group.alb_access.id]
}

#LISTER PARA FAZER O REDIREC PARA O ELASTICSEARCH

resource "aws_lb_listener" "elasticsearch_listerner" {
  load_balancer_arn = aws_lb.elasticsearch_alb.arn
  port              = "9200"
  protocol          = "HTTP"


  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "404"
    }

  }
}

resource "aws_lb_listener_rule" "teste_redirect" {
  listener_arn = aws_lb_listener.elasticsearch_listerner.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_cluster_elasticsearch.arn

  }
  condition {
    host_header {
      values = ["elasticsearchcluster.smartmei.in"]
    }
  }
}

#LOADBALANCE PARA O KIBANA

resource "aws_lb" "kibana_alb" {
  name               = "kibana-cluster-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets_id
  security_groups    = [aws_security_group.alb_access.id]
}


# PARA FAZER O REDIREC PARA O KIBANA

resource "aws_lb_listener" "kibana_listerner" {
  load_balancer_arn = aws_lb.kibana_alb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "404"
    }

  }
}

resource "aws_lb_listener_rule" "kibana_redirect" {
  listener_arn = aws_lb_listener.kibana_listerner.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kibana_cluster.arn

  }
  condition {
    host_header {
      values = ["kibanalab.smartmei.in"]
    }
  }
}


#LOADBALANCE PARA O LOGSTASH

resource "aws_lb" "logstash_alb" {
  name               = "logstash-cluster-alb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnets_id
  #security_groups    = [aws_security_group.alb_access.id]
}


# PARA FAZER O REDIREC PARA O LOGSTASH

resource "aws_lb_listener" "logstash_listerner" {
  load_balancer_arn = aws_lb.logstash_alb.arn
  port              = "5044"
  protocol          = "TCP"


  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.logstash_cluster.arn

  }
}
#
#resource "aws_lb_listener_rule" "logstash_redirect" {
#  listener_arn = aws_lb_listener.logstash_listerner.arn
#  priority     = 100 
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.logstash_cluster.arn
#
#  }
#  condition {
#    host_header {
#      values = ["logstashlab.smartmei.in"]
#    }
#  }
#}


