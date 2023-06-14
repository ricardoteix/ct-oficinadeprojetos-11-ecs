import http from 'k6/http';
import encoding from 'k6/encoding';
import { LOADBALANCER_DNS, API_KEY } from "./env.js";

// Configuração de subida e descida de 200 usuários em 10 minutos
export const options = {
    stages: [
        // { duration: '3m', target: 150 },
        // { duration: '2m', target: 200 },
        // { duration: '5m', target: 0 }
        { duration: '60s', target: 150 },
        { duration: '60s', target: 200 },
        { duration: '60s', target: 0 }
    ],
};

// Valor fixo para Basic Authentication
const username = 'apikey'; 
// Valor obtido no OpenProject em Minha Conta -> Token de Acesso
const password = API_KEY;

const encodedCredentials = encoding.b64encode(`${username}:${password}`);

// Endereço do LoadBabancer
const baseURL = LOADBALANCER_DNS;
const authHeaders = {
    headers: {
        'Authorization': `Basic ${encodedCredentials}`,
        'Content-Type': 'application/json',
    },
};
export default function () {
    // Acessa o payload do projeto 1, que já vem como 
    // demonstração na instalação do OpenProject
    const res = http.get(`${baseURL}/api/v3/projects/1`, authHeaders);
    check(res, { 'status was 200': (r) => r.status == 200 });
    sleep(1);
}