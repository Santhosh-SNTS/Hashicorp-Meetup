resource "aws_key_pair" "hugkey" {
  key_name   = "hugkey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}
