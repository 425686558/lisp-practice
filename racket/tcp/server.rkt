#!/usr/bin/racket
#lang racket/base
(require racket/tcp)

(define tcp-fd (tcp-listen 7000))
(define-values (ser-in ser-out) (tcp-accept tcp-fd))
(display "hello\n" ser-out)
(flush-output ser-out)
(display (read-line ser-in ))
(display "\n")
