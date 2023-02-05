resource "aws_route53_zone" "hosted-zone" {
  name = var.domain-name
  tags = {
    environment = "dev"
  }
}

#create a record set in route53

resource "aws_route53_record" "site_domain"{
    zone_id = aws_route53_zone.hosted-zone.zone_id
    name = "terraform-test.${var.domain-name}"
    type = "A"

    alias {
      name = aws_lb.main-lb.dns_name
      zone_id = aws_lb.main-lb.zone_id
      evaluate_target_health = true

    }
}