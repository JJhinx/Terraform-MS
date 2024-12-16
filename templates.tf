#templates
data "template_file" "userdata-MySQL-MS" {
  template = file("userdata/Mysql-Userdata.tpl")
}

data "template_file" "userdata-Apache-MS" {
  template = file("userdata/Apache-Userdata.tpl")
}
