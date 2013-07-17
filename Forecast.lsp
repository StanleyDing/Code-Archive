;;
;;Fetch weather forecast from www.cwb.gov.tw
;;Author: Stanley Ding
;;Email: stanley811213@gmail.com
;;

;;Redirect the output of quicklisp
(with-open-file 
  (*standard-output* "/dev/null" :direction :output :if-exists :supersede)
  (ql:quickload :drakma)
  (ql:quickload :com.informatimago.common-lisp.html-parser))

(defvar website "http://www.cwb.gov.tw/V7/forecast/f_index.htm")
(defvar html (drakma:http-request website :external-format-in :utf-8))
(defvar hl (com.informatimago.common-lisp.html-parser.parse-html:parse-html-string html))
(defvar NorthArea (nthcdr 5 (nth 3 (caddar hl))))
(defvar CenterArea (nthcdr 5 (nth 3 (car (cdddar hl)))))
(defvar EastArea (nthcdr 5 (nth 3 (caddr (cadddr hl)))))
(defvar SouthArea (nthcdr 5 (nth 3 (cadddr (cadddr hl)))))
(defvar Archipelagoes (nthcdr 5 (nth 3 (car (cddddr (cadddr hl))))))
(defvar data nil)

(defun parseCity (n)
  (let ((name (subseq (cadadr n) 0 (- (length (cadadr n)) 4)))
        (chiname (third (third (fourth n))))
        (temp (third (third (sixth n))))
        (p (subseq (third (third (eighth n)))
            0 (- (length (third (third (eighth n)))) 5)))
        (spic (tenth (cadr (third (third (third (tenth n))))))))
    (list name chiname temp p spic)))

(defun parseArea (n)
  (dolist (sublist n) 
    (if (listp sublist) (setq data (cons (parseCity sublist) data)))))

;;parse each area
(parseArea NorthArea)
(parseArea CenterArea)
(parseArea EastArea)
(parseArea SouthArea)
(parseArea Archipelagoes)

(setq data (sort data #'string-lessp :key #'car))   ;;sort the list

(dolist (result data)   ;;print results
  (write-string (format nil "~A  ~A~A  ~A~A  ~A~%"
                        (second result)
                        (third result) "C"
                        (fourth result) "%"
                        (fifth result))))
