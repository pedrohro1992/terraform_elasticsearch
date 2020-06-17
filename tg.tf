#TARGET GROUP DO ELASTICSEARCH

resource "aws_lb_target_group" "eks_cluster_elasticsearch" {
  name     = "cluster-eks-elasticsearch-tg"
  port     = 9200
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}


resource "aws_lb_target_group_attachment" "eks_cluster_attachement_elasticsearch" {
  target_group_arn = aws_lb_target_group.eks_cluster_elasticsearch.arn
  target_id        = aws_instance.elasticsearch_server.id
  port             = 9200

}

resource "aws_lb_target_group_attachment" "eks_cluster_attachement_elasticsearch_warm" {
  target_group_arn = aws_lb_target_group.eks_cluster_elasticsearch.arn
  target_id        = aws_instance.elasticsearch_server_warm.id
  port             = 9200

}

#TARGET GROUP DO KIBANA

resource "aws_lb_target_group" "kibana_cluster" {
  name     = "cluster-eks-kibana-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}


resource "aws_lb_target_group_attachment" "kibana_cluster_attachement" {
  target_group_arn = aws_lb_target_group.kibana_cluster.arn
  target_id        = aws_instance.kibana_server.id
  port             = 80

}



#TARGET GROUP PARA O LOGSTASH

resource "aws_lb_target_group" "logstash_cluster" {
  name     = "cluster-eks-logstash-tg"
  port     = 5044
  protocol = "TCP"

  vpc_id   = var.vpc_id
  stickiness {
    enabled = false
    type = "lb_cookie"
}
}


resource "aws_lb_target_group_attachment" "logstash_cluster_attachement" {
  target_group_arn = aws_lb_target_group.logstash_cluster.arn
  target_id        = aws_instance.logstash_server.id
  port             = 5044

}

