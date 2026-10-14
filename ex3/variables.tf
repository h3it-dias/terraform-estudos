variable "estados" {
  description = "Estados atendidos, com a sigla e a capital de cada um. Gera um arquivo por estado."
  type        = list(object({ sigla = string, capital = string }))

  default = [
    {
      sigla   = "GO"
      capital = "Goiânia"
    },
    {
      sigla   = "SP"
      capital = "São Paulo"
    }
  ]
}