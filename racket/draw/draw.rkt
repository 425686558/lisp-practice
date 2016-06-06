#!/usr/bin/racket
#lang racket/gui
(require racket/draw)
(define target (make-bitmap 30 30)) ; A 30x30 bitmap
(define dc (new bitmap-dc% [bitmap target]))
(send dc draw-rectangle
      0 10   ; Top-left at (0, 10), 10 pixels down from top-left
      30 10) ; 30 pixels wide and 10 pixels high
(send dc draw-line
      0 0    ; Start at (0, 0), the top-left corner
      30 30) ; and draw to (30, 30), the bottom-right corner
(send dc draw-line
      0 30   ; Start at (0, 30), the bottom-left corner
      30 0)  ; and draw to (30, 0), the top-right corner

(define frame (new frame% [label "button" ] [min-height 300] [min-width 300] ))

(define buttonimage (new button% [label target] [parent frame] [callback (lambda (b e) (printf "hello,world\n"))]))
(define buttontext (new button% [label "test"] [parent frame] [callback (lambda (b e) (printf "hello,world\n"))]))

(send frame show #t)

;(send target save-file "box.png" 'png)
