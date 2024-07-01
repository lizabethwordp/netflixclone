# Configure the Rancher2 provider to admin
provider "rancher2" {
  api_url    = "https://rancher.my-domain.com"
  access_key = var.rancher2_access_key
  secret_key = var.rancher2_secret_key
}

resource "aws_instance" "dockerInstance" {
  cluster_id = "<CLUSTER_ID>"
  name = "netflixclone_chart"
  namespace = "cis-operator-system"
  repo_name = "https://github.com/lizabethwordp/netflixclone/"
  chart_name = "netflixclone_chart"
  tags = {
    Name = "dockerInstance"

  user_data = file("install.sh")
}
