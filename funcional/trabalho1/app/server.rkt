#lang racket

(require
  web-server/servlet
  web-server/servlet-env
  db
  )

(define db_username (getenv "DB_USERNAME"))
(define db_password (getenv "DB_PASSWORD"))
(define db_host "db")
(define db_database (getenv "DB_DATABASE"))
(define db_port (string->number "5432"))

(define pgc (postgresql-connect
             #:user db_username
             #:server db_host
             #:port db_port
             #:database db_database
             #:password db_password
             )
  )

;; Definição de assoc-ref para trabalhar com association lists
(define (assoc-ref alist key [default #f])
  (let ([pair (assoc key alist)])
    (if pair (cdr pair) default)))

(define (inserir-pesquisa nome email nota1 nota2 nota3 nota4 nota5 nota6 nota7 nota8)
  (query-exec pgc
              "INSERT INTO estatisticas (nome, email, nota1, nota2, nota3, nota4, nota5, nota6, nota7, nota8) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)"
              nome email nota1 nota2 nota3 nota4 nota5 nota6 nota7 nota8))

(define (buscar-pesquisas)
  (query-rows pgc "SELECT * FROM estatisticas ORDER BY created_at DESC"))
(define (estatizar-pesquisas)
  (query-rows pgc "SELECT avg(nota1) nota1, avg(nota2) nota2, avg(nota3) nota3, avg(nota4) nota4, avg(nota5) nota5, avg(nota6) nota6, avg(nota7) nota7, avg(nota8) nota8 FROM estatisticas"))

(define (gerar-linhas pesquisa-list)
  (for/list ([reg pesquisa-list])
    (define nome (vector-ref reg 1))
    (define email (vector-ref reg 2))
    (define nota1 (vector-ref reg 3))
    (define nota2 (vector-ref reg 4))
    (define nota3 (vector-ref reg 5))
    (define nota4 (vector-ref reg 6))
    (define nota5 (vector-ref reg 7))
    (define nota6 (vector-ref reg 8))
    (define nota7 (vector-ref reg 9))
    (define nota8 (vector-ref reg 10))
    (define created_at (vector-ref reg 11))
    `(tr
      (td ,nome)
      (td ,email)
      (td ,(number->string nota1))
      (td ,(number->string nota2))
      (td ,(number->string nota3))
      (td ,(number->string nota4))
      (td ,(number->string nota5))
      (td ,(number->string nota6))
      (td ,(number->string nota7))
      (td ,(number->string nota8))
      (td ,(~a (sql-timestamp-year created_at) "-" (sql-timestamp-month created_at) "-" (sql-timestamp-day created_at) " " (sql-timestamp-hour created_at) ":" (sql-timestamp-minute created_at) ":" (sql-timestamp-second created_at)))
      )
    ))

(define (gerar-linha-estatistica estatistica)
  (for/list ([reg estatistica])
    (define nota1 (vector-ref reg 0))
    (define nota2 (vector-ref reg 1))
    (define nota3 (vector-ref reg 2))
    (define nota4 (vector-ref reg 3))
    (define nota5 (vector-ref reg 4))
    (define nota6 (vector-ref reg 5))
    (define nota7 (vector-ref reg 6))
    (define nota8 (vector-ref reg 7))
    `(tr
      (td ,(number->string nota1))
      (td ,(number->string nota2))
      (td ,(number->string nota3))
      (td ,(number->string nota4))
      (td ,(number->string nota5))
      (td ,(number->string nota6))
      (td ,(number->string nota7))
      (td ,(number->string nota8))
      )
    ))


(define (servlet request)

  (define valores (request-bindings request))
  (define uri-path
    (string-append "/" (string-join (map path/param-path (url-path (request-uri request))) "/")))
  (cond
    [(string=? uri-path "/create")
     (response/xexpr
      `(html
        (head (title "Pesquisa sobre ferramenta: Dr. Racket"))
        (body
         (h1 "Pesquisa sobre ferramenta: Dr. Racket")
         (form ([action "/store"] [method "post"])
               (div "Nome: " (input ([type "text"] [name "nome"] [required "true"])))
               (div "E-mail: " (input ([type "text"] [name "email"] [required "true"])))
               (div "Consistência (0-10): " (input ([type "number"] [name "nota1"] [min "0"] [max "10"] [required "true"])))
               (div "Atalhos (0-10): " (input ([type "number"] [name "nota2"] [min "0"] [max "10"] [required "true"])))
               (div "Feedback informativo (0-10): " (input ([type "number"] [name "nota3"] [min "0"] [max "10"] [required "true"])))
               (div "Feedback final (0-10): " (input ([type "number"] [name "nota4"] [min "0"] [max "10"] [required "true"])))
               (div "Auxílio nos erros (0-10): " (input ([type "number"] [name "nota5"] [min "0"] [max "10"] [required "true"])))
               (div "Reversão de ações (0-10): " (input ([type "number"] [name "nota6"] [min "0"] [max "10"] [required "true"])))
               (div "Controle do usuário (0-10): " (input ([type "number"] [name "nota7"] [min "0"] [max "10"] [required "true"])))
               (div "Carga de memória de curta duração reduzido (0-10): " (input ([type "number"] [name "nota8"] [min "0"] [max "10"] [required "true"])))
               (div (input ([type "submit"] [value "Enviar"])))
               )
         (hr)
         (p (a ([href "/"]) "Voltar"))
         )))]

    [(string=? uri-path "/stats")
     (define pesquisas (estatizar-pesquisas))
     (response/xexpr
      `(html
        (head (title "Estatísticas da ferramenta"))
        (body
         (h1 "Estatísticas da ferramenta (média)")
         (table ([border "1"])
                (tr
                 (th "Consistência") (th "Atalhos") (th "Feedback informativo") (th "Feedback final") (th "Auxílio nos erros") (th "Reversão de ações") (th "Controle do usuário") (th "Carga de memória de curta duração reduzido"))
                ,@(gerar-linha-estatistica pesquisas))
         (hr)
         (p (a ([href "/"]) "Voltar"))
         )))]


    [(string=? uri-path "/store")

     (define nome (assoc-ref valores 'nome))
     (define email (assoc-ref valores 'email))
     (define nota1 (string->number(assoc-ref valores 'nota1)))
     (define nota2 (string->number (assoc-ref valores 'nota2)))
     (define nota3 (string->number (assoc-ref valores 'nota3)))
     (define nota4 (string->number (assoc-ref valores 'nota4)))
     (define nota5 (string->number (assoc-ref valores 'nota5)))
     (define nota6 (string->number (assoc-ref valores 'nota6)))
     (define nota7 (string->number (assoc-ref valores 'nota7)))
     (define nota8 (string->number (assoc-ref valores 'nota8)))

     (inserir-pesquisa nome email nota1 nota2 nota3 nota4 nota5 nota6 nota7 nota8)

     (response/xexpr
      `(html
        (head (title "Pesquisa registrada"))
        (body
         (h1 "Pesquisa registrada com Sucesso!")
         (p (a ([href "/create"]) "Nova pesquisa"))
         (p (a ([href "/"]) "Listar todas as pesquisas"))
         )))]

    [(string=? uri-path "/")
     (define pesquisas (buscar-pesquisas))
     (response/xexpr
      `(html
        (head (title "Lista de pesquisas"))
        (body
         (h1 "Pesquisas registradas")
         (table ([border "1"])
                (tr
                 (th "Nome") (th "E-mail") (th "Consistência") (th "Atalhos") (th "Feedback informativo") (th "Feedback final") (th "Auxílio nos erros") (th "Reversão de ações") (th "Controle do usuário") (th "Carga de memória de curta duração reduzido") (th "Data"))
                ,@(gerar-linhas pesquisas))
         (p (a ([href "/create"]) "Nova pesquisa"))
         (p (a ([href "/stats"]) "Estatísticas"))
         )))]

    [else
     (response/xexpr
      `(html
        (head (title "Página não encontrada"))
        (body
         (h1 "404 - Página não encontrada")
         (p "A página solicitada não foi encontrada.")
         (p (a ([href "/"]) "Voltar"))
         )))])
  )

(serve/servlet servlet
               #:servlet-regexp #rx".*"
               #:listen-ip #f
               #:servlet-path "/"
               #:port 9000
               #:launch-browser? #f)