resource "aws_route53_record" "elasticsearch_lab" {
  zone_id = var.route_53_zone_id
  name    = "elasticsearchcluster.smartmei.in"
  type    = "A"

  alias {
    name                   = aws_lb.elasticsearch_alb.dns_name
    zone_id                = aws_lb.elasticsearch_alb.zone_id
    evaluate_target_health = false

  }

}



resource "aws_route53_record" "kibana_lab" {
  zone_id = var.route_53_zone_id
  name    = "kibanalab.smartmei.in"
  type    = "A"

  alias {
    name                   = aws_lb.kibana_alb.dns_name
    zone_id                = aws_lb.kibana_alb.zone_id
    evaluate_target_health = false

  }

}

resource "aws_route53_record" "logstashs_lab" {
  zone_id = var.route_53_zone_id
  name    = "logstashlab.smartmei.in"
  type    = "A"

  alias {
    name                   = aws_lb.logstash_alb.dns_name
    zone_id                = aws_lb.logstash_alb.zone_id
    evaluate_target_health = false

  }

}