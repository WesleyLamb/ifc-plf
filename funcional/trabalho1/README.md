# Formulário de pesquisas sobre a IHC do Dr. Racket

A proposta deste projeto é o desenvolvimento de uma ferramenta em Racket onde deverão ser armazenadas pesquisas sobre a aplicação das 8 Regras de Ouro de Ben Shneiderman no Dr. Racket, uma IDE utilizada para o desenvolvimento em Racket.
As 8 regras são:
1. Manter a consistência
2. Permitir atalhos aos utilizadores frequentes
3. Oferecer feedback informativo
4. Interações com princípio, meio e fim
5. Oferecer prevenção e recuperação de erros
6. Permitir desfazer alterações
7. Sensação de controle
8. Reduzir a carga na memória de curta-duração

## Ferramentas utilizadas

- VS Code;
- Racket;
- Docker;
- PostgreSQL;
- NGINX.

## Instalação

###  Requisitos

- Docker + Docker Compose

1. No diretório raiz, duplique o arquivo `.env.example` e renomeie-o para `.env`;
2. No diretório ./db/schemas, repita o mesmo processo para o arquivo `schema.sql.example`;
3. Crie os container através do arquivo `docker-compose.yml`:
```bash
$ docker compose up -d
```
4. [Acesse o formulário](http://localhost:9001).

## Documentação

### Rotas

- /
    - Página inicial da aplicação, lista as pesquisas já realizadas;
    - Apresenta links para criar uma nova pesquisa e para visualizar as estatísticas das pesquisas.
- /create
    - Formulário para cadastrar uma pesquisa.
- /store
    - Rota utilizada pelo formulário para armazenar as informações
- /stats
    - Rota onde as pesquisas cadastradas são estratificadas.
