resource "local_file" "agentes" {
  for_each = var.estados
  filename = "agentes/${each.key}.txt"
  content  = "Olá, GAIA! -> ${each.value.sigla} ${each.value.capital}"
}