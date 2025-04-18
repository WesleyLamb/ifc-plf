#lang racket

(define (somar a b) (+ a b))
(define (subtrair a b) (- a b))
(define (multiplicar a b) (* a b))
(define (dividir a b) (/ a b))

(define (dobro a)
  (multiplicar 2 a)
)

(define (triplo a)
    (multiplicar a 3)
)

(define (metade a)
    (dividir a 2)
)

(define (quadrado a)
    (multiplicar a a)
)

(define (cubo a)
    (multiplicar a (quadrado a))
)
