#!/usr/bin/racket
#lang racket/base
(require racket/tcp)

(define-values (client-in client-out) (tcp-connect "127.0.0.1" 7000))
(do ([i 0 (+ i 1)])
  ([< i 0])
  (display (string-append (read-line) "\n") client-out)
  (flush-output client-out)
)
