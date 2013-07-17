;;
;;Parse infix expression
;;Author: Stanley Ding
;;Email: stanley811213@gmail.com
;;

(defvar input)

(defun parse(x)
  (let ((stack nil))
    (loop
      (when (eql nil (car x)) 
        (progn 
          (dolist (op stack) (write-string (format nil "~A " op)))
          (return)))
      (cond ((numberp (car x)) (princ (format nil "~A " (car x))))
            ((listp (car x)) (parse (car x)))
            ((find (car x) '(+ -))
             (progn (dolist (op stack) (write-string (format nil "~A " op)))
                    (setq stack (cons (car x) nil))))
            ((find (car x) '(* /))
             (cond ((= 0 (length stack)) (setq stack (cons (car x) nil)))
                   ((find (car stack) '(* /))
                    (progn (write-string (format nil "~A " (car stack)))
                           (setq stack (cons (car x) (cdr stack)))))
                   (t (setq stack (cons (car x) stack))))))
      (setq x (cdr x)))))

(loop
  (setq input (read-line T nil 'eof))
  (when (equal input 'eof) (return))
  (setq input (concatenate 'string "(" input ")"))
  (parse (read-from-string input))
  (write-line ""))
