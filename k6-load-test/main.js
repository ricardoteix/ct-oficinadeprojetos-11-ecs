import http from 'k6/http';
import encoding from 'k6/encoding';

// Configuração de subida e descida de 200 usuários em 10 minutos
export const options = {
    stages: [
        { duration: '3m', target: 150 },
        { duration: '2m', target: 200 },
        { duration: '5m', target: 0 },
    ],
};

// Valor obtido no OpenProject em Minha Conta -> Token de Acesso
const apiKey = "26442f0c52d5adecf2de413ca2bb8a456088313298fdf1b5e6e9dac74d7d8031";
// Valor fixo para Basic Authentication
const username = 'apikey'; 
const password = apiKey;

const encodedCredentials = encoding.b64encode(`${username}:${password}`);

// Endereço do LoadBabancer
const baseURL = 'http://openproject-lb-446283563.us-east-1.elb.amazonaws.com/';
const authHeaders = {
    headers: {
        'Authorization': `Basic ${encodedCredentials}`,
        'Content-Type': 'application/json',
    },
};
export default function () {
    // Acessa o payload do projeto 1, que já vem como 
    // demonstração na instalação do OpenProject
    const projectResponse = http.get(`${baseURL}/api/v3/projects/1`, authHeaders);
    console.log(projectResponse.body);
}