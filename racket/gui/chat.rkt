#!/usr/bin/racket
#lang racket/gui

(require ffi/unsafe
         ffi/unsafe/define)


(define chat-record '())

(define (chat->string list-v)
  (foldl string-append "" list-v))

(define frame (new frame% 
		     [label "Example"]))

(define subframe (new frame% 
		     [label "connect"]
		     [style '(no-resize-border no-caption)]
                     [parent frame]		     
		     [x 150]
                     [y 100]))

(define input-ip (new text-field%
		     [label ""]
		     [parent subframe]
		     [init-value "请输入对方ip"]))

(define input-button (new button%
		     [label "确认"]
		     [parent subframe]
		     [callback (lambda (b e) 
					(let* ([ip-addr-str (string-split (send input-ip get-value) ".")])
					  (if (and [= (length ip-addr-str) 4] [andmap string->number ip-addr-str])
					    (begin
					      (set! ip-addr-str (map string->number ip-addr-str))
					      (if (andmap (lambda (a) 
							    (and (< a 255) (> a 0))) ip-addr-str
                                                  )
						(begin
					          (printf "~a\n" ip-addr-str)
						  (send subframe show #f))
						(printf "ip address should be [0 255]\n"))
					    )
					    (printf "error ip\n")))
					)
]))

(define menu-bar (new menu-bar%
		      [parent frame]))

(define menu-connect (new menu%
			  [label "连接"]
			  [parent menu-bar]))

(define menu-ip (new menu-item%
		     [label "连接到目标主机ip"]
		     [parent menu-connect]
		     [callback (lambda (m e) (send subframe show #t))]))

(send frame show #t)

(define chat-title (new message%
		     [label "聊天记录"]
		     [parent frame]))

(define mainboard (new panel%
		     [parent frame]
		     [style '(vscroll)]
		     [min-height 100]))

(define message (new message% 
                     [label ""]
		     [parent mainboard]
		     [min-width 300]))

(define reply (new text-field%
		   [label ""]
		   [parent frame]))

(define button (new button% 
                    [label "发送"]
                    [parent frame]
		    [callback (lambda (button event) 
                                (set! chat-record (cons (string-append (send reply get-value) "\n") chat-record))
				(send message set-label (chat->string chat-record))
				(send message min-height (* 30 (length chat-record))))]))
