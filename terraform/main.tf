provider "aws" {
  region = "us-east-1"
}

resource "random_id" "id" {
  byte_length = 8
}

# frontend
resource "aws_cloudformation_stack" "app" {
  name = "app-${random_id.id.hex}"

  template_body = file("../start.yml")
}

resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = aws_cloudformation_stack.app.outputs.FrontendHost
    origin_id   = "frontend"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  origin {
    domain_name = aws_cloudformation_stack.app.outputs.BackendHost
    origin_id   = "api"

    custom_origin_config {
      http_port              = aws_cloudformation_stack.app.outputs.BackendPort
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled = true
	is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "frontend"
		compress = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }
  ordered_cache_behavior {
    path_pattern     = "/api/tags"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "api"

    default_ttl = 60
    min_ttl     = 60
    max_ttl     = 60
		compress = true

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only"
  }
  ordered_cache_behavior {
    path_pattern     = "/api/articles"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "api"

    default_ttl = 60
    min_ttl     = 60
    max_ttl     = 60
		compress = true

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only"
  }
  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "api"

    default_ttl = 0
    min_ttl     = 0
    max_ttl     = 0
		compress = true

    forwarded_values {
      query_string = true
      headers      = ["*"]
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "https-only"
  }
  ordered_cache_behavior {
    path_pattern     = "/static/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "frontend"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    default_ttl = 31536000
    min_ttl     = 31536000
    max_ttl     = 31536000
		compress = true

    viewer_protocol_policy = "https-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "CloudFrontURL" {
  value = aws_cloudfront_distribution.distribution.domain_name
}

