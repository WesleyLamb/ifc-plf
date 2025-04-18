#lang racket
(define (hipotenusa a b)
    (sqrt (+ (expt a 2) (expt b 2)))
)

(hipotenusa 3 4)