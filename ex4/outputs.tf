output "arquivos" {
  description = "Caminhos dos arquivos gerados, um por estado"
  value       = [for arquivo in local_file.agentes : arquivo.filename]
}

output "capitais" {
  description = "Capitais dos estados atendidos"
  value       = [for chave, estado in var.estados : estado.capital]
}