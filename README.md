# terraform-estudos

Exercícios da issue "Estudar Terraform" do GAIA. Tudo roda localmente, só com os providers `local` e `random`.

| Pasta | Conteúdo |
|---|---|
| `ex1/` | Primeiro ciclo `init → plan → apply → destroy` com `local_file` |
| `ex2/` | Variável `ambiente` tipada, com `validation` e `dev.tfvars`/`prod.tfvars` |
| `ex3/` | Um arquivo por estado usando `count` sobre uma lista |
| `ex3-for_each/` | O mesmo usando `for_each` sobre um mapa |
| `ex4/` | Outputs com expressão `for` |
| `ex5/` | Módulo `modules/servico/` chamado duas vezes (backend e frontend) |
| `ex6/` | Renomear recurso sem destruir, com bloco `moved` |

Para rodar, entre na pasta do exercício:

```sh
terraform init
terraform plan                       # ex2: -var-file=dev.tfvars
terraform apply
terraform destroy
```

## Respostas dos exercícios

### Ex. 1: O que tem no `terraform.tfstate`? Por que não vai para o Git?
É um JSON com o mapeamento entre cada recurso do código e o objeto real criado (IDs, atributos, conteúdo do arquivo, versão do provider). Não vai para o Git porque pode conter segredos em texto puro (senhas, chaves) e porque duas pessoas aplicando com cópias diferentes do state corrompem a infra; o lugar dele é um backend remoto com lock.

### Ex. 1: Drift
Depois de editar o arquivo na mão, o `plan` mostra `local_file.arquivo_gaia will be created` (`1 to add`). No refresh, o provider `local` vê que o conteúdo não bate mais com o state, considera que o recurso deixou de existir e planeja criá-lo de novo com o conteúdo declarado. O Terraform sempre puxa a realidade de volta para o código.

### Ex. 2: HCL é fortemente tipado? E sem `type`?
Tem tipos e valida na entrada (o `validation` e o `type` barram valores errados antes do `plan`), mas faz conversão automática quando dá (ex.: `"2"` vira `2` para um `number`). Sem `type`, a variável vira `any` e aceita qualquer valor, então erros só aparecem mais tarde, no uso.

### Ex. 3: `for_each` vs `count`
**Tirando um estado do mapa (`for_each`):** só o arquivo daquele estado é destruído; os outros ficam intactos, porque cada instância é identificada pela chave (`local_file.agentes["go"]`).

**Com `count`:** as instâncias são identificadas pelo índice (`[0]`, `[1]`, …). Remover um item do meio desloca os índices e o Terraform recria tudo que veio depois. Em produção isso significa derrubar e recriar recursos que não mudaram (ex.: um banco ou um serviço no ar), por isso `for_each` é o padrão para coleções.

### Ex. 4: Para que serve o `outputs.tf`?
Expõe valores depois do `apply` (URLs, IPs, IDs) para pessoas e pipelines, e é a "interface de saída" de um módulo: é assim que um módulo passa informação para outro (ex.: a URL do backend vai para a configuração do frontend).

## Perguntas do Passo 3

### 1. Declarativo vs imperativo: por que Terraform em vez do `deploy.sh`?
No `deploy.sh` descrevemos *os passos*; rodar duas vezes pode duplicar recursos ou falhar, e ninguém sabe o que existe de verdade. No Terraform descrevemos *o estado final*; ele calcula a diferença, mostra no `plan` antes de mexer e é idempotente. O código vira a documentação da infra e passa por revisão em PR.

### 2. O que é o state? Por que remoto? O que é state locking?
O state é o registro do que o Terraform criou e de como isso se liga ao código. Num bucket (ex.: GCS com versionamento) ele fica compartilhado pelo time, com histórico e fora do Git. O locking impede que duas pessoas rodem `apply` ao mesmo tempo sobre o mesmo state, o que corromperia o arquivo ou a infra.

### 3. Diferença entre `resource` e `data`?
`resource` cria e gerencia um objeto: o Terraform é dono do ciclo de vida dele (cria, altera, destrói). `data` só *lê* algo que já existe (ex.: um projeto, uma rede ou um segredo criados fora daquele código) para usar os atributos, sem nunca alterar.

### 4. Por que fixar a versão do provider?
Para que todo mundo e o CI rodem exatamente o mesmo código de provider. Uma versão nova pode mudar defaults ou remover atributos e fazer o `plan` propor mudanças que ninguém pediu. Com `~> 2.9.1` aceitamos só correções; o `.terraform.lock.hcl` (que vai para o Git) trava a versão exata.

### 5. Repositório separado de infra ou pasta `infra/` em cada repo?
Para o GAIA, eu iria de repositório separado: a infra é compartilhada (rede, banco, buckets, IAM) e não pertence a um serviço só; um repo único facilita reaproveitar módulos, ter um state e um pipeline com permissões próprias e restringir quem pode aplicar em `prod`. A desvantagem é mudanças que tocam app e infra exigirem dois PRs; dá para mitigar expondo outputs (URLs, imagens) que os repos de app consomem.
