#lang web-server/insta

(define BLOG '())
(define global-req "")

(struct blog (title content))

(define (blog-parse? bindings)
  (and (exists-binding? 'title bindings)
       (exists-binding? 'title bindings)))

(define (blog-parse bindings)
  (blog (extract-binding/single 'title bindings)
        (extract-binding/single 'content bindings)))

(define (start request)
  (define web-req (request-bindings request))
  (set! global-req web-req)
  (define (response embed/url)
    (set! BLOG (cons (insert-title web-req embed/url) BLOG))
    (render-blog-page web-req request))
  (send/suspend/dispatch response))

(define (insert-title web-blog embed/url)
  (define temp-blog "")
  (define (post-page-handler request)
    (post-page temp-blog request))
  (if (blog-parse? web-blog)
    (begin
      (set! temp-blog (blog-parse web-blog)) 
      `(p (a ((href ,(embed/url post-page-handler))) ,(blog-title temp-blog)) (br)
          ,(blog-content temp-blog)))
    ""))

(define (post-page a-post request)
  (response/xexpr
    `(html
        (head (title "Post Page"))
        (body
           ,(blog-title a-post)))))

(define (show-blog)
  (append (list 'p) BLOG))

(define (render-blog-page web-req request)
  (response/xexpr 
    `(html 
       (head (title "Huix Blog"))
       (body 
         (h1 "My blog")
        ,(show-blog)
         (form 
           "title:"(input ((name "title"))) (br)
           "content:"(input ((name "content"))) (br)
           (input ((type "submit"))))))))

