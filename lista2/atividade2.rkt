#lang racket
(define (distancia x1 y1 x2 y2)
    (sqrt (+ (expt (- x2 x1) 2) (expt (- y2 y1) 2)))
)

(distancia 1 1 4 5)