#lang racket
(define (perimetro raio)
    (* 2 pi raio)
)

(define (area raio)
    (* pi raio raio)
)

(perimetro 20)
(area 20)