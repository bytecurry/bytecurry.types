;;; number.lisp
;;;
;;; Copyright (c) 2015 Thayne McCombs <astrothayne@gmail.com>

(uiop:define-package :bytecurry.types/number
    (:nicknames :btype/number)
  (:documentation "Additional types for numbers (and bytes).")
  (:import-from :alexandria
                #:symbolicate)
  (:export #:octet #:signed-octet
           #:bytearray #:signed-bytearray
           #:matrix
           #:array-index
           #:array-length))

(in-package :bytecurry.types/number)

;;; pragmatically export the sub-interval types
(loop for type in '(fixnum integer rational real float short-float single-float
                    double-float long-float ratio) do
     (loop for interval in '("NEGATIVE" "NON-POSITIVE" "NON-NEGATIVE" "POSITIVE")
          do (export (symbolicate interval #\- type))))

;TODO: should we define predicates for all these types?

;; octets

(deftype octet ()
  "An unsigned octet byte."
  '(unsigned-byte 8))

(deftype signed-octet ()
  "A signed octet."
  '(signed-byte 8))

(deftype bytearray (&optional (size '*))
  "A vector of octets."
  `(vector octet ,size))

(deftype signed-bytearray (&optional (size '*))
  "A vector of signed octets"
  `(vector signed-octet ,size))

;;; other numbers

(deftype matrix (&optional (type '*) ((height width) '(* *)))
  "A two-dimensional array."
  `(array ,type (,height ,width)))

;;; sub-interval types from https://common-lisp.net/project/cdr/document/5/extra-num-types.html

(defmacro define-sub-interval (type interval min max &key (name type))
  `(deftype ,(symbolicate interval #\- name) ()
     ,(format nil "~:(~a~) ~(~a~)" interval type)
     '(,type ,min ,max)))

(defmacro define-sub-interval-types (type &optional (zero 0))
  `(progn
     (define-sub-interval ,type "NEGATIVE" * (,zero))
     (define-sub-interval ,type "NON-POSITIVE" * ,zero)
     (define-sub-interval ,type "NON-NEGATIVE" ,zero *)
     (define-sub-interval ,type "POSITIVE" (,zero) *)))

;;; fixnum sub-interval types

(define-sub-interval integer "NEGATIVE" #.most-negative-fixnum -1 :name "FIXNUM")
(define-sub-interval integer "NON-POSITIVE" #.most-negative-fixnum 0 :name "FIXNUM")
(define-sub-interval integer "NON-NEGATIVE" 0 #.most-positive-fixnum :name "FIXNUM")
(define-sub-interval integer "POSITIVE" 1 #.most-positive-fixnum :name "FIXNUM")

;;; integer
(define-sub-interval-types integer)
;;; rational
(define-sub-interval-types rational)
;;; real
(define-sub-interval-types real)
;;; floats
(define-sub-interval-types float 0.0E0)
(define-sub-interval-types short-float 0.0S0)
(define-sub-interval-types single-float 0.0F0)
(define-sub-interval-types double-float 0.0D0)
(define-sub-interval-types long-float 0.0L0)

;;; ratios are more complicated
(defun ratiop (x)
  "Test if x is a non-integer ratio"
  (and (rationalp x)
       (> (denominator x) 1)))

(defun ratio-plusp (x)
  "Test if x is a positive ratio"
  (and (ratiop x)
       (plusp x)))

(defun ratio-minusp (x)
  "Test if x is a negative ratio"
  (and (ratiop x)
       (minusp x)))

(deftype negative-ratio ()
  "Negative ratio"
  '(satisfies ratio-minusp))
(deftype non-positive-ratio ()
  "Alias for negative-ratio (ratio can't be zero)"
  'negative-ratio)
(deftype positive-ratio ()
  "Positive ratio"
  '(satisfies ratio-plusp))
(deftype non-negative-ratio ()
  "Alias for positive-ratio (ratio can't be zero)"
  'positive-ratio)
