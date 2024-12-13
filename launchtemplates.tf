#launch template for webserver
resource "aws_launch_template" "webserver-LT-MS" {
    name = "webserver-LT-MS"
    image_id = "ami-0d64bb532e0502c46"
    instance_type = "t2.micro"
    key_name = "selfmade2"

    network_interfaces {
        security_groups = [aws_security_group.Security-Group-Allow-SSH-HTTP-MS.id]
        associate_public_ip_address = true
    }

    user_data = base64encode(data.template_file.userdata-Apache-MS.rendered)
}