(uiop:define-package "bytecurry.types/interface"
    (:nicknames :bytecurry.types :btypes :tp)
  (:documentation "Collection of additional lisp types.

This is an extension to trivial-types.")
  (:use-reexport :trivial-types
                 :bytecurry.types/number))
