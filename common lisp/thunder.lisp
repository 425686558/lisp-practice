#!/usr/bin/sbcl --script
(defvar *thunder-num* nil)
(defvar *thunder-width* 10)
(defvar *thunder-height* 10)
(defvar *thunder-array* (make-array 1 :fill-pointer 0 :adjustable t))
(defvar *all-list-len* (* *thunder-width* *thunder-height*))
(defvar *all-possible-array* nil)
(defvar *thunder-region* nil)
(defvar *thunder-up* nil)
(defvar *thunder-left* nil)
(defvar *thunder-right* nil)
(defvar *thunder-down* nil)

(defun get-random-num(num)
   (setf *random-state* (make-random-state t))
   (random num))

(defun usage (err)
  (format t "error:")
  (cond 
    ((= err 0) (format t "please input 1 argument~%"))
    ((= err 1) (format t "the argument should be digit nunber~%"))
    ((= err 2) (format t "input number is larger than width*height~%"))))

(defun argv-par () 
  (if (= (length *posix-argv*) 2)
    (let* ((num (read-from-string (nth 1 *posix-argv*))))
      (if (numberp num)
        (setf *thunder-num* num)
        (usage 1)))
    (usage 0)))

(defun init-possible-array (num)
  (do ((i 0 (incf i)) (r nil))
    ((= i num ) r)
    (setf r (cons i r))))

(defun init-thunder-array (num)
  (if (<= num *all-list-len*)
    (do ((i (- num 1) (decf i)) (j nil))
        ((< i 0))
        (setf j (get-random-num (+ i (- *all-list-len* num) 1)))
        (vector-push-extend (nth j *all-possible-array*) *thunder-array*)
        (setf *all-possible-array* (remove (nth j *all-possible-array*) *all-possible-array*)))
    (usage 2)))

(defun init-thunder-eregion ()
  (make-array *all-list-len*))

(defun show-region (width height vec)
  (do ((h 0 ))
    ((= h height))
    (do ((w 0 (incf w)))
        ((= w width) (incf h))
        (format t "~a " (elt vec (+ w (* h height)))))
    (format t "~%")))

(defun set-thunder ()
  (do ((i 0 (incf i)))
    ((= i *thunder-num*))
    (setf (elt *thunder-region* (elt *thunder-array* i) ) "*" )))

(defun put-thunder (num)
  (unless *thunder-up*
    (unless (equal (elt *thunder-region* (- num *thunder-width*)) "*")
      (incf (elt *thunder-region* (- num *thunder-width*)))))

  (unless *thunder-left*
    (unless (equal (elt *thunder-region* (- num 1)) "*")
      (incf (elt *thunder-region* (- num 1)))))

  (unless *thunder-right*
    (unless (equal (elt *thunder-region* (+ num 1)) "*")
      (incf (elt *thunder-region* (+ num 1)))))

  (unless *thunder-down*
    (unless (equal (elt *thunder-region* (+ num *thunder-width*)) "*")
      (incf (elt *thunder-region* (+ num *thunder-width*)))))

   (unless (or *thunder-left* *thunder-up*)
      (unless (equal (elt *thunder-region* (- num *thunder-width* 1)) "*")
        (incf (elt *thunder-region* (- num *thunder-width* 1)))))

   (unless (or *thunder-right* *thunder-up*)
      (unless (equal (elt *thunder-region* (+ (- num *thunder-width*) 1)) "*")
        (incf (elt *thunder-region* (+ (- num *thunder-width*) 1)))))

   (unless (or *thunder-left* *thunder-down*)
      (unless (equal (elt *thunder-region* (- (+ num *thunder-width*) 1)) "*")
        (incf (elt *thunder-region* (- (+ num *thunder-width*) 1)))))

   (unless (or *thunder-right* *thunder-down*)
      (unless (equal (elt *thunder-region* (+ num *thunder-width* 1)) "*")
        (incf (elt *thunder-region* (+ num *thunder-width* 1)))))

    (setf *thunder-left* nil)
    (setf *thunder-right* nil)
    (setf *thunder-up* nil)
    (setf *thunder-down* nil))


(defun show-direct ()
  (format t "left :~a~%" *thunder-left*)
  (format t "right:~a~%" *thunder-right*)
  (format t "up   :~a~%" *thunder-up*)
  (format t "dwon :~a~%" *thunder-down*)
)

(defun calc-set-thunder ()
  (do ((i 0 (incf i)))
    ((= i *all-list-len*))
    (if (equal (elt *thunder-region* i) "*")
       (progn
        (cond 
          ((<= i (- *thunder-width* 1)) (setf *thunder-up* t) )
	  ((>= i (- *all-list-len* *thunder-width*)) (setf *thunder-down* t) ));up and down
        (cond
          ((= (mod (+ i 1) *thunder-width*) 1) (setf *thunder-left* t))
          ((= (mod (+ i 1) *thunder-width*) 0) (setf *thunder-right* t)));right and left
        (put-thunder i))
        ();next
    )))

(argv-par)
;(format t "thunder:~a~%" *thunder-num*)
(setf *all-possible-array* (init-possible-array *all-list-len*) )

;(format t "len:~a~%" (length *all-possible-array*))

(init-thunder-array *thunder-num*)
;(format t "array:~a~%" *thunder-array*)
;(format t "len:~a~%" (length *all-possible-array*))

(setf *thunder-region* (init-thunder-eregion))

(set-thunder)

(calc-set-thunder)
;(show-direct)
(show-region *thunder-width* *thunder-height* *thunder-region*)
