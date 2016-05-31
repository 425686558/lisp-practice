#!/usr/bin/racket
#lang racket/base

(require ffi/unsafe
         ffi/unsafe/define)

(define randlib (ffi-lib "./rand"))
(struct t-direction (left right up down) #:mutable)

(define rand-seq null)
(define rand-gen null)
(define thunder-width 40)
(define thunder-height 40)
(define thunder-count 300)
(define global-dir (t-direction 0 0 0 0))

(define thunder-map (make-vector (* thunder-width thunder-height) 0))

(define (rand-make num)
  (do [(i 0 (+ i 1)) 
       (q null)]
    [(= i num) q]
    (set! q (cons i q))))

(set! rand-seq (rand-make (* thunder-width thunder-height)))

(define-c get_rand_num randlib (_fun -> _int32))

(define-c huix_rand randlib (_fun _int32 -> _int32))

(define (get_num_range num)
   (let* [ (rand_num (get_rand_num))
           (seed 0) ]
     (remainder rand_num num)))

(define (rand-gen-make num)
  (do ([i  (* thunder-width thunder-height) (- i 1)]
       [rand-num null]
       [temp 0])
    [(= i (- (* thunder-width thunder-height) num))]
    (set! rand-num (get_num_range i))
    (set! temp (list-ref rand-seq rand-num))
    (set! rand-seq (remove temp rand-seq))
    (set! rand-gen (append rand-gen (list temp)))
  )
)

(define (show-map)
  (do ([i 1 (+ i 1)])
    ([= i (+ (* thunder-width thunder-height) 1)])
    (printf "~a" (vector-ref thunder-map (- i 1)))
    (if (= 0 (remainder i thunder-width))
      (printf "\n") (printf " "))
))

(define (put-thunder list-name)
  (vector-set! thunder-map (car list-name) '*)
  (unless (equal? (cdr list-name) null)
    (put-thunder (cdr list-name))))

(define (thunder-calc num)
    (unless (= (t-direction-left global-dir) 1)
      (unless (equal? (vector-ref thunder-map (- num 1)) '*)
        (vector-set! thunder-map (- num 1) (+ (vector-ref thunder-map (- num 1)) 1))))

    (unless (= (t-direction-right global-dir) 1)
      (unless (equal? (vector-ref thunder-map (+ num 1)) '*)
        (vector-set! thunder-map (+ num 1) (+ (vector-ref thunder-map (+ num 1)) 1))))

    (unless (= (t-direction-up global-dir) 1)
      (unless (equal? (vector-ref thunder-map (- num thunder-width)) '*)
        (vector-set! thunder-map (- num thunder-width) (+ (vector-ref thunder-map (- num thunder-width)) 1))))

    (unless (= (t-direction-down global-dir) 1)
      (unless (equal? (vector-ref thunder-map (+ num thunder-width)) '*)
        (vector-set! thunder-map (+ num thunder-width) (+ (vector-ref thunder-map (+ num thunder-width)) 1))))

    (unless (or (= (t-direction-left global-dir) 1) (= (t-direction-up global-dir) 1))
      (unless (equal? (vector-ref thunder-map (- num 1 thunder-width)) '*)
        (vector-set! thunder-map (- num 1 thunder-width) (+ (vector-ref thunder-map (- num 1 thunder-width)) 1))))

    (unless (or (= (t-direction-left global-dir) 1) (= (t-direction-down global-dir) 1))
      (unless (equal? (vector-ref thunder-map (+ (- num 1) thunder-width)) '*)
        (vector-set! thunder-map (+ (- num 1) thunder-width) (+ (vector-ref thunder-map (+ (- num 1) thunder-width)) 1))))

    (unless (or (= (t-direction-right global-dir) 1) (= (t-direction-up global-dir) 1))
      (unless (equal? (vector-ref thunder-map (- (+ num 1) thunder-width)) '*)
        (vector-set! thunder-map (- (+ num 1) thunder-width) (+ (vector-ref thunder-map (- (+ num 1) thunder-width)) 1))))

    (unless (or (= (t-direction-right global-dir) 1) (= (t-direction-down global-dir) 1))
      (unless (equal? (vector-ref thunder-map (+ num 1 thunder-width)) '*)
        (vector-set! thunder-map (+ num 1 thunder-width) (+ (vector-ref thunder-map (+ num 1 thunder-width)) 1))))
)

(define (dir-reset)
  (set-t-direction-left! global-dir 0)
  (set-t-direction-right! global-dir 0)
  (set-t-direction-up! global-dir 0)
  (set-t-direction-down! global-dir 0)
)

(define (thunder-direction list-name)
  (when (= (remainder (car list-name) thunder-width) 0)
    (set-t-direction-left! global-dir 1))
  (when (= (remainder (car list-name) thunder-width) (- thunder-width 1))
    (set-t-direction-right! global-dir 1))
  (when (< (/ (car list-name) thunder-width) 1)
    (set-t-direction-up! global-dir 1))
  (when (> (/ (+ (car list-name) 1) thunder-width) (- thunder-height 1 ))
    (set-t-direction-down! global-dir 1))

  (thunder-calc (car list-name))
  (dir-reset)
  (unless (equal? (cdr list-name) null)
    (thunder-direction (cdr list-name)))
)

(define (show-dir)
  (printf "left:~a\n" (t-direction-left global-dir))
  (printf "right:~a\n" (t-direction-right global-dir))
  (printf "up:~a\n" (t-direction-up global-dir))
  (printf "down:~a\n" (t-direction-down global-dir))
)

(rand-gen-make thunder-count)
(put-thunder rand-gen)
(thunder-direction rand-gen)
(show-map)
