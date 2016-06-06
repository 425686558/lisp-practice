#!/usr/bin/racket
#lang racket/base
(require racket/tcp)

(define tcp-fd (tcp-listen 7000))
(define-values (ser-in ser-out) (tcp-accept tcp-fd))
(do ([i 0 (+ i 1)])
  ([< i 0])
  (display (read-line ser-in ))
  (display "\n")
  (sleep 1)
)
