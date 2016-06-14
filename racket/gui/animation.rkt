#lang racket
(require racket/gui/base)

(define x 0)

(define frame (new frame% [label "Frame"] [width 500] [height 500]))
(define canvas (new canvas% [parent frame]
                    [paint-callback
                     (λ (c dc)
                       (send dc set-pen "red" 4 'solid)
                       (send dc clear)
                       (send dc draw-line x 250 x 250))]))
(send frame show #t)


(define (loop)
  (send canvas on-paint)
  (set! x (remainder (+ x 1) 500))
  (sleep/yield 0.02)
  (loop))

(loop)
