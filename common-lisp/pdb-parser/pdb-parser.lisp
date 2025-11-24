(in-package :cl-user)
(defpackage pdb-parser
  (:use :cl)
  (:export :<atom>
           :serial
           :x-pos
           :y-pos
           :z-pos
           :element
           :<bond>
           :bond-1
           :bond-2
           :bond-3
           :bond-4
           :<atom-group>
           :atoms
           :bonds
           :parse-string
           :parse-file))
(in-package :pdb-parser)

(defparameter +months+
  (remove-if
   #'(lambda (str) (equal str ""))
   (loop for month across local-time:+short-month-names+ collecting
     (string-upcase month))))

(defun parse-pdb-date (date-string)
  (let* ((day (1+ (parse-integer (subseq date-string 0 2))))
         (month-string (subseq date-string 3 6))
         (month (1+ (position month-string +months+ :test #'equal)))
         (year (+ 2000 (parse-integer (subseq date-string 7 9)))))
    (local-time:encode-timestamp 0 0 0 0 day month year
                                 :timezone local-time:+utc-zone+)))

(defun strip (string)
  (string-trim '(#\Newline #\Space #\Tab) string))

(defclass <pdb-record> ()
  ()
  (:documentation "The base class of PDB records."))

(defparameter *records* (make-hash-table :test #'equal))

(defmacro define-pdb-record (name string-name fields)
  `(progn
     (defclass ,name (<pdb-record>)
       (,@(loop for field in fields collecting
            (destructuring-bind (field-name &key range type) field
              (declare (ignore range type))
              `(,field-name :accessor ,field-name
                            :initarg ,(intern (symbol-name field-name)
                                              :keyword))))))

     (defmethod populate-record ((record ,name) string)
       ,@(loop for field in fields collecting
           (destructuring-bind (field-name &key range type) field
             `(let ((field-text (subseq string ,(1- (first range)) ,(second range))))
                (setf (,field-name record)
                      (case ,type
                        (:string
                         (strip field-text))
                        (:integer
                         (parse-integer (strip field-text)))
                        (:float
                         (parse-number:parse-real-number (strip field-text)))
                        (:date
                         (parse-pdb-date field-text))
                        (t
                         (error "Unknown column type '~A'." ,type))))))))

     (setf (gethash ,string-name *records*) ',name)))

(define-pdb-record <atom> "ATOM"
  ((serial :range (7 11)
           :type :string)
   (x-pos :range (31 38)
          :type :float)
   (y-pos :range (39 46)
          :type :float)
   (z-pos :range (47 54)
          :type :float)
   (element :range (77 78)
            :type :string)))

(setf (gethash "HETATM" *records*) '<atom>)

(define-pdb-record <bond> "CONECT"
  ((serial :range (7 11)
           :type :string)
   (bond-1 :range (12 16)
           :type :string)
   (bond-2 :range (17 21)
           :type :string)
   (bond-3 :range (22 26)
           :type :string)
   (bond-4 :range (27 31)
           :type :string)))

(defun parse-line (line)
  (let* ((record-name (subseq line 0 6))
         (record-class (gethash record-name *records*)))
    (when record-class
      (let ((record-instance (make-instance record-class)))
        (populate-record record-instance line)
        record-instance))))

(defclass <atom-group> ()
  ((atoms :reader atoms
          :initarg :atoms
          :documentation "An array of <atom> instances.")
   (bonds :reader bonds
          :initarg :bonds
          :documentation "An array of <bond> instances.")))

(defun parse-pdb (stream)
  (let ((atoms (make-array 0 :fill-pointer 0 :adjustable t))
        (bonds (make-array 0 :fill-pointer 0 :adjustable t)))
    (handler-case
        (do ((line (read-line stream) (read-line stream)))
            ((not line))
          (let ((record (parse-line line)))
            (when record
              (cond
                ((typep record '<atom>)
                 (vector-push-extend record atoms))
                ((typep record '<bond>)
                 (vector-push-extend record bonds))
                (t
                 t)))))
      (error () t))
    (make-instance '<atom-group> :atoms atoms :bonds bonds)))

(defun parse-string (string)
  "Parse a PDB string."
  (with-input-from-string (stream string)
    (parse-pdb stream)))

(defun parse-file (pathname)
  "Parse a PDB file."
  (with-open-file (input-stream pathname
                                :direction :input)
    (parse-pdb input-stream)))
