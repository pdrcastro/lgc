# resource "aws_route53_record" "demo" {
#   zone_id = var.zone_id
#   name    = "demo"
#   type    = "CNAME"
#   ttl     = 300
#   records = [aws_eip.lb.public_ip]
# }