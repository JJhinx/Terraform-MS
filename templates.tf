#templates
data "template_file" "userdata-MySQL-MS" {
  template = file("userdata/Mysql-Userdata.tpl")
  vars = {
    #privateIP=aws_instance.MySQL-server-MS.private_ip
  }
}

data "template_file" "userdata-Apache-MS" {
  template = file("userdata/Apache-Userdata.tpl")
}