# Intro

**Projeto criado para o desafio 11 da Oficina de Projetos da Cloud Treinamentos**

Este projeto permite criar a infraestrutura mínima na AWS para execução de carga de trabalho baseada em ECS e Fargate.

A proposta é criar todos os recursos necessários, como VPC, Subnet, Route Tables, Cluster, RDS etc, para rodar o projeto. 

O sistema a ser executado neste exemplo é o OpenProject, que é um sistema para gestão de projetos.

Toda a infraestrutura é criada via Terraform.

# Imagem utilizada

Para usar o ECS precisamos da imagem que vai ser usada para subir o container. 

Como vamos usar nosso ECS em uma rede privada, seria preciso que a rede tivesse acesso à internet para baixar a imagem **openproject/community:12**, que é a oficial do OpenProject disponível no DockerHub, via NAT Gateways. Para evitar o uso de NATs podemos usar VPC Endpoints. 

Se a decisão for por usar NATs é preciso definir a variável ``use-nat-gateway`` como ``true`` no arquivo **terraform.tfvars**. Assim os NATs serão criamos e os VPC Endpoints não serão.

Se optar por não usar NATs é preciso definir esta variável como ``false``, a imagem deverá ser baixada do ECR, e sua URI especificada na variáveç ``image-ecr-uri``.

No arquivo **ecs.tf** temos a definição do container e as variáveis de ambiente necessárias para prover acesso ao banco, dns da aplicação e algumas outras.

# Terraform

Terraform é tecnologia para uso de infraestrutura como código (IaaC), assim como Cloudformation da AWS. 

Porém com Terraform é possível definir infraestrutura para outras clouds como GCP e Azure.

## Instalação

Para utilizar é preciso baixar o arquivo do binário compilado para o sistema que você usa. Acesse https://www.terraform.io/downloads

## Iniciaizando o repositório

O primeiro passo é baixar o repositório, seja via git ou fazendo o download do zip.

Se baixar o zip, descompacte ele e acesse a pasta via terminal.

É preciso inicializar o Terraform na raiz deste projeto executando 

```
terraform init
```

## Definindo credenciais

O arquivo de definição do Terraform é o *main.tf*.

É nele que especificamos como nossa infraestrutura será, jutamente com os outros arquivos *.tf*.

É importante observar que no bloco do ``provider "aws"`` é onde definimos que vamos usar Terraform com AWS. 

```
provider "aws" {
  region = "us-east-1"
  profile = "oficina-de-projetos"
}
```

Como Terraform cria toda a infra automaticamente na AWS, é preciso dar permissão para isso por meio de credenciais.

Apenar se ser possível especificar as chaves no próprio provider, esta abordagem não é indicada. Principalmente por este código estar em um repositório git, pois que tiver acesso ao repositório saberá qual são as credenciais.

Uma opção melhor é usar um *profile* da AWS configurado localmente. 

Podemis criar, por exemplo, o profile chamado *projeto*. Para criar um profile execute o comando abaixo usando o AWS CLI e preencha os parâmetros solicitados.

```
aws configure --profile projeto
```

### Recomendação
Asista este vídeo: [Nunca use credenciais da AWS no seu código!](https://www.youtube.com/watch?v=8yGaKo4xkxc)


## Variáveis - Configurações adicionais 

Além da configuração do profile será preciso definir algumas variáveis.

Para evitar expor dados sensíveis no git, como senha do banco de dados, será preciso copiar o arquivo ``terraform.tfvars.exemplo`` para ``terraform.tfvars``.

No arquivo ``terraform.tfvars`` redefina os valores das variáveis. Algumas são opcionais, como os dados necessários para o RDS.

Todas as variáveis possíveis para este arquivo podem ser vistas no arquivo ``variables.tf``. Apenas algumas delas foram utilizadas no exemplo.

## Aplicando a infra definida

O Terraform provê alguns comandos básicos para planejar, aplicar e destruir a infraestrutura. 

Ao começar a aplicar a infraestrutura, o Terraform cria o arquivo ``terraform.tfstate``, que deve ser preservado e não deve ser alterado manualmente.

Por meio deste arquivo o Terraform sabe o estado atual da infraestrutura e é capaz de adicionar, alterar ou remover recursos.

Neste repositório não estamos versionando este arquivo por se tratar de um repositório compartilhado e para estudo. Em um repositório real possívelmente você vai querer manter este arquivo preservado no git.

Mais um ponto importante: **NÃO ALTERE A INFRAESTRUTURA MANUALMENTE PELA CONSOLE**. Se você fizer isso o Terraform poderá se perder pois se você tentar usá-lo novamente no mesmo projeto.

###  Verificando o que será criado, removido ou alterado
```
terraform plan
```

###  Aplicando a infraestrutura definida
```
terraform apply
```
ou, para confirmar automáticamente.
```
terraform apply --auto-approve
```

###  Destruindo toda sua infraestrutura

<span style="color:RED">\*CUIDADO!\* <br>
Após a execução dos comandos abaixo você perderá tudo que foi especificado no seu arquivo Terraform (banco de dados, EC2, EBS etc).</span>.

```
terraform destroy
```
ou, para confirmar automáticamente.
```
terraform destroy --auto-approve
```

## Pós criação da infraestrutura

Após executar o ``terraform apply``, é apresentado no terminal quantos recursos forma adicionados, alterados ou destruídos na sua infra.

No nosso código adicionamos mais algumas informações de saída (outputs) necessárias para acessarmos os recursos criados, como o banco de dados. Observe abaixo.

O acesso à aplicação será pelo endereço apresentado no ``projeto-dns``, que também pode ser utilizado para acessar a instância.

O endereço *host* para o banco de dados RDS é apresentado em ``projeto-rds-addr``. 

```
Apply complete! Resources: 23 added, 0 changed, 0 destroyed.

Outputs:

projeto-dns = "ec2-44-201-145-193.compute-1.amazonaws.com"
projeto-id = "i-0c3289412a3104db2"
projeto-ip = "44.201.145.193"
projeto-rds-addr = "projeto-rds.cmfcq1p7msvt.us-east-1.rds.amazonaws.com"
projeto-rds-endpoint = "projeto-rds.cmfcq1p7msvt.us-east-1.rds.amazonaws.com:5432"
```

---

# Considerações finais

Este é um projeto para experimentações e estudo do Terraform. 
Mesmo proporcionando a criação dos recursos mínimos para execução do projeto na AWS, é desaconselhado o uso deste projeto para implantação de cargas de trabalho em ambiente produtivo. 

# Referências

1. [Terraform](https://www.terraform.io/)
2. [How to setup a basic VPC with EC2 and RDS using Terraform](https://dev.to/rolfstreefkerk/how-to-setup-a-basic-vpc-with-ec2-and-rds-using-terraform-3jij)
3. [Variáveis Terraform para Packer](https://stackoverflow.com/questions/58054772/how-to-set-a-packer-variable-from-a-terraform-state)