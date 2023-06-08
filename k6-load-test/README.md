# Teste de Carga com Grafana k6

## Intro

Grafana k6 é uma ferramenta para teste de carga open-source baseada em Javascript.

A documentação para instação em vários formatos pode ser encontrada [aqui](https://k6.io/docs/get-started/installation/).

O instalador para Windows você pode baixar [neste link](https://dl.k6.io/msi/k6-latest-amd64.msi).

## Como testar o OpenProject

Para testar com k6 você deve criar um arquivo .js, no nosso caso é o **main.js**.

Neste arquivo você vai encontrar as configurações de como o teste deve ocorrer.

No exemplo abaixo temos a especificação dos estágios (stages) especificando quantos usuários virtuals (vus) vamos desejar (*target*) que sejam criados em um determinado tempo (*duration*).

Podemos criar mais estágios se necessário, basta adicionar uma nova linha definindo os parâmetros.


```javascript
export const options = {
    stages: [
        { duration: '3m', target: 150 },
        { duration: '2m', target: 200 },
        { duration: '5m', target: 0 },
    ],
};
```

### Autenticação

Para realizar um teste de carga com usuário autenticado precisamos criar um **Access token** que permitirá a autenticação no sistema.

No arquivo **main.js** temos a definição do valor deste token, como no código abaixo.

Valor da **apiKey** foi obtido no OpenProject em ``Minha Conta -> Token de Acesso``.


```javascript
const apiKey = "MINHA API KEY";
const username = 'apikey'; 
const password = apiKey;
```

### Requisições

O código a seguir realiza autenticação e requisição com base nos dados fornecidos.

A ``baseURL`` deve ser substituida pelo endereço do LoadBalancer.

Neste exemplo a requisição ser feira para apenas um *endpoint*, o ``/api/v3/projects/1``, que busca informações sobre um projeto com identificador 1, que já vem como demonstração na instalação do OpenProject.

```javascript
const baseURL = 'http://meu_load_balancer.com/';
const authHeaders = {
    headers: {
        'Authorization': `Basic ${encodedCredentials}`,
        'Content-Type': 'application/json',
    },
};
export default function () {
    const projectResponse = http.get(`${baseURL}/api/v3/projects/1`, authHeaders);
    console.log(projectResponse.body);
}
```

## Execução do teste

Uma vez que o k6 esteja instalado e o arquivo ``main.js`` com as devidas configurações, basta executar o comando abaixo na mesma pasta do arquivo. 

``k6 run main.js --log-output=none``

O parâmetro ``--log-output=none`` omite os dados de retorno da requisição na console da chamada.

Durante o teste uma barra de progresso será apresentada no terminal e o resumo será apresentado ao final.