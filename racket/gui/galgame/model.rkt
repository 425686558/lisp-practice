#lang racket
(require 2htdp/image)
(require 2htdp/universe)

(define *galgame* "")

(struct human (type object) #:mutable) ;type 0 = static;type 1 =dynamic

(define (human-static? type)
  (if (= (human-type type) 0)
    #t
    #f))

(define (human-dynamic? type)
  (if (= (human-type  type) 1)
    #f
    #t))

(struct chat (content human) #:mutable)
(struct scene (area sound) #:mutable)
(struct room (scene chats index) #:mutable)
(struct game (room time index) #:mutable)

(define (get-room game-flag)
  (list-ref (game-room game-flag) (game-index game-flag)))

(define (get-scene game-flag)
  (room-scene (get-room game-flag)))

(define (get-chats game-flag)
  (define room-ins (get-room game-flag))
  (list-ref (room-chats room-ins) (room-index room-ins)))

(define (get-human game-flag)
  (chat-human (get-chats game-flag)))

(define (image-human game-flag)
  (define human-ins (get-human game-flag))
  (if (human-static? human-ins)
      (human-object human-ins) 
      (list-ref (human-object human-ins) (remainder (game-time game-flag) (length (human-object human-ins))))))

(define (image-chat game-flag)
   (chat-content (get-chats game-flag)))
  

(define (image-bg game-flag)
        (scene-area (room-scene (get-room game-flag))))

(define s-man (human 1 (list
                          "human/a/s_s01a.png"
                          "human/a/s_s01b.png"
                          "human/a/s_s01c.png"
                          "human/a/s_s01d.png"
                          "human/a/s_s01e.png")))

(define old-man (human 0 "human/a/s_d01a.png"))

(define chat-list (list 
                     (chat "hello" s-man) 
                     (chat "world" old-man)))

(define classroom (scene "background/classroom2.png" ""))
(define class-game (room classroom chat-list 0))
(define game-global (game (list 
                              class-game 
                              (room (scene "background/gallery2.png" "") 
                                    (list 
                                          (chat "你好" s-man)
                                          (chat " 哈哈,我是祥子大人，请你叫我大人!!!" old-man))
                                    0))
                          0 0))

(define (galgame game-flag)
   (underlay/xy (rectangle 800 600) 0 0
                 (scene-generate game-flag)))

(define (scene-generate game-flag)
  (underlay/align "center" "bottom" 
         (underlay/align "center" "center" 
                        (bitmap/file (image-bg game-flag))    ;background
                        (bitmap/file (image-human game-flag))) ;human
         (underlay/xy (rectangle 800 100 "solid" (color 140 80 140 180)) 0 0
                      (text (image-chat game-flag) 31 (color 60 0 60)))
))

(define (scene-timer game-flag)
  (set-game-time! game-flag (+ (game-time game-flag) 1))
  game-flag)

(define (key-handler game-flag a-key)
  (define room-ins (get-room game-flag))
  (if (>= (+ (room-index room-ins) 1) (length (room-chats room-ins)))
    (unless (>=  (+ (game-index game-flag) 1) (length (game-room game-flag)))
      (set-room-index! room-ins 0)
      (set-game-index! game-flag (+ 1 (game-index game-flag))))
    (set-room-index! room-ins (+ (room-index room-ins) 1)))
  game-flag)


(big-bang game-global 
    (to-draw scene-generate)
    (on-key key-handler)
    (on-tick scene-timer 0.15))
