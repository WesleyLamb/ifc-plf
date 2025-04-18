#lang racket

(define (s a b c)
    (/ (+ a b c) 2)
)
(define (heron a b c)
    (sqrt (* (s a b c) (- (s a b c) a) (- (s a b c) b) (- (s a b c) c) ))
)

(heron 5 4 3)