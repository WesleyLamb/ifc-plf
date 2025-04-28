#lang racket
(define (perimetro h b)
    (+ b b h h)
)

(define (area h b)
    (* b h)
)

(perimetro 5 10)
(area 5 10)
