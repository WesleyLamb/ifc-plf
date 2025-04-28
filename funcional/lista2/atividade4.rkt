#lang racket

(define (delta a b c)
    (- (* b b) (* 4 a c))
)

(define (x1 a b c)
    (/ (+ (- b) (sqrt (delta a b c))) (* 2 a))
)

(define (x2 a b c)
    (/ (- (- b) (sqrt (delta a b c))) (* 2 a))
)

(define (bhaskara a b c)
    (write (~a "delta: " (delta a b c) " x1: " (x1 a b c) " x2: " (x2 a b c)))
)

(bhaskara 1 4 -5)