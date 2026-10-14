resource "local_file" "agentes" {
  count    = length(var.estados)
  filename = "agentes/${lower(var.estados[count.index].sigla)}.txt"
  content  = "Olá, GAIA! -> ${var.estados[count.index].sigla} ${var.estados[count.index].capital}"
}