;; sbcl --noinform --no-userinit --load ramp.lisp --quit

(loop with width = 100
   for i from 0 to width
   do
     (let ((r (- 255 (* i (/ 255 width))))
           (g (* i (/ 510 width)))
           (b (* i (/ 255 width))))
       (when (> g 256)
         (setf g (- 510 g)))
       (let ((r (round r))
             (g (round g))
             (b (round b)))
         (write-char #\Esc)
         (format t "[48;2;~D;~D;~Dm" r g b)
         (write-char #\Esc)
         (format t "[38;2;~D;~D;~Dm" (- 255 r) (- 255 g) (- 255 b))
         (format t " ")
         (write-char #\Esc)
         (format t "[0m"))))
