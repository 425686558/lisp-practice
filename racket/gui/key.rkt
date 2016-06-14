#lang racket/gui

(define game-canvas%
  (class canvas%
    (define/override (on-char ke)
	 (printf "~a\n" (send ke get-key-code))
        )
  (define/override (on-event e)
	(printf "~a x:~a y:~a\n" (send e get-event-type)
                                 (send e get-x)
	                         (send e get-y)))
    (super-new)))

(define game-frame (new frame% (label "game") (width 600) (height 400)))
(define game-canvas (new game-canvas% (parent game-frame)))
(send game-frame show #t)
