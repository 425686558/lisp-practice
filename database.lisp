#!/usr/bin/sbcl
(defvar *database* nil)
(defvar *table-namespace* (make-hash-table))

(defmacro parse-list (type-list)
  `(let ((ret nil))
      (do ((rest-argument ,type-list (setf rest-argument (cdr rest-argument))) (meta-name nil)  (meta-type nil))
         ((equal rest-argument nil))
         (setf meta-name (car rest-argument))
         (setf rest-argument (cdr rest-argument))
         (setf meta-type (car rest-argument))
         (cond 
           ((eq meta-type 'int) 
             (setf ret (cons (list 'int meta-name) ret)))
           ((eq meta-type 'string) 
             (setf ret (cons (list 'string meta-name) ret))))
         (format t "~a~%" ret))
       ret))

(defmacro create (data-type data-name &rest type-list)
  `(let* ((table-element (list nil nil)))
    (if (equal ',data-type 'table)
      (progn
        ;(setf table-element (list ',data-name nil nil))
        ;(push table-element *table-namespace*)
        (if (equal nil (nth 1 (multiple-value-list (gethash ',data-name *table-namespace*))))
          (progn
            (setf (nth 1 table-element) (make-array 1 :fill-pointer 0 :adjustable t))
            (setf (gethash ',data-name *table-namespace*) table-element))
          (format t "~a is already exist~%" ',data-name)
        )
      )
      (format t "usage~%"))
    (setf (nth 0 table-element) (parse-list ,@type-list))
))

(defmacro insert (insert-method table-name &key (attr nil) (values nil))
  (if (equal insert-method 'into)
    (if (equal t (nth 1 (multiple-value-list (gethash table-name *table-namespace*))))
      (if (equal attr nil)
        (if (= (length (car (gethash table-name *table-namespace*))) (length values))
          (do (;(all (car (gethash table-name *table-namespace*)))
               (i t) 
               (temp (car (gethash table-name *table-namespace*)))
               (values-i t)
               (values-temp values)
               (ret nil))
            ((or (equal temp nil) (equal values-temp nil)) 
              (unless (or (equal ret nil) (= (count nil ret) (length ret))) 
              (vector-push-extend (reverse ret) (nth 1 (gethash table-name *table-namespace*)))))
            (setf i (car temp))
            (setf values-i (car values-temp))
            (cond 
              ((equal (car i) 'int) 
                (if (integerp values-i)
                  (setf ret (cons values-i ret))
                  (setf ret (cons nil ret))
              ))
              ((equal (car i) 'string) 
                (if (stringp  values-i)
                  (setf ret (cons values-i ret))
                  (setf ret (cons nil ret))
              ))
              ( t (format t "it is other style,and error~%"))
            )
            (setf temp (cdr temp))
            (setf values-temp (cdr values-temp))
          )
          (format t "values length error"))
        (format t "attr way~%"))
      (format t "table doesn't exist~%"))
    (format t "no this method~%"))
)
