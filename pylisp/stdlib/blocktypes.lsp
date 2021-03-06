
(def::macro let (vars . body)
  (if (atom? (car vars))
    `((fn (,(car vars)) ,@body) ,(cadr vars))
    `((fn ,(map car vars) ,@body) ,@(map cadr vars))))

(def while* (test-fn body-fn)
  (if (test-fn)
    (block (body-fn) (while* test-fn body-fn))))

(def::macro while (test . body)
  `(while* {:,test} {:,@body}))

(def::macro do-while (test . body)
  `(block
     ,@body
     (while ,test ,@body)))

(def::macro for (vardef . body)
  `(map (fn (,(car vardef)) ,@body)
       ,(cadr vardef)))

(def::macro map::macro (f l)
  `(block ,@(map (fn (x) (list f x)) l)))

(def::macro cond (. pairs)
  (if (= (len pairs) 0)
    `#0
    (let (p (car pairs))
      `(if ,(car p)
         ,(cadr p)
         (cond ,@(cdr pairs))))))

(def::macro case (expr . pairs)
  (let (g1 (gensym))
    `(let (,g1 ,expr)
       (case
         ,@(map {p: `((= ,g1 ,(car p)) ,@(cdr p))} pairs)))))
