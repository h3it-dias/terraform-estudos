variable "estados" {
  description = "Estados atendidos, com a sigla e a capital de cada um. Gera um arquivo por estado."
  type        = map(object({ sigla = string, capital = string }))

  default = {
    go = {
      sigla   = "GO"
      capital = "Goiânia"
    }
    sp = {
      sigla   = "SP"
      capital = "São Paulo"
    }
    mt = {
      sigla   = "MT"
      capital = "Cuiabá"
    }
  }
}