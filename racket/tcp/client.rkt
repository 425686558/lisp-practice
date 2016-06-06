#!/usr/bin/racket
#lang racket/base
(require racket/tcp)

(define-values (client-in client-out) (tcp-connect "127.0.0.1" 7000))
(display (read-line client-in))
(display "\n")
