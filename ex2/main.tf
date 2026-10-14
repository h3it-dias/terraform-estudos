resource "local_file" "arquivo_ex2" {
  filename = "arquivo-${var.ambiente}.txt"
  content  = "Olá, GAIA!"
}