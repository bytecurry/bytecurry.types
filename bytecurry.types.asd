;;;; bytecurry.types.asd
;;;
;;; Copyright (c) 2015 Thayne McCombs <bytecurry.software@gmail.com>

(asdf:defsystem #:bytecurry.types
  :description "Collection of additional lisp types"
  :author "Thayne McCombs <bytecurry.software@gmail.com>"
  :license "MIT"
  :defsystem-depends-on (:asdf-package-system)
  :class :package-inferred-system
  :depends-on (#:bytecurry.types/interface))
