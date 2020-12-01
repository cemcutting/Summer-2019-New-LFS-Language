#lang forge/core
(require "../desugar/desugar_helpers.rkt")
(require "../desugar/desugar.rkt")
(require "forge_ex.rkt")
(require "test_helpers.rkt")
(require (prefix-in @ rackunit))


(run udt
     #:preds [isUndirectedTree]
     #:scope [(Node 7)])

; product-helper
(define currTupIfAtomic (list 'Node0))
(define LHS univ)
(define RHS Node)
(define rightTupleContext (projectTupleRange currTupIfAtomic (- (node/expr-arity LHS) 1) (node/expr-arity RHS)))
(define leftTupleContext (projectTupleRange currTupIfAtomic 0 (node/expr-arity LHS)))
(define formulas (list
                  (node/formula/op/in empty-nodeinfo (list (tup2Expr leftTupleContext udt empty-nodeinfo) LHS))
                  (node/formula/op/in empty-nodeinfo (list (tup2Expr rightTupleContext udt empty-nodeinfo) RHS))))
(@test-case
 "TEST product-helper on valid input same arity"
 (@check-equal?
  (to-string (product-helper (list edges Node univ) (list Node edges) currTupIfAtomic empty-nodeinfo udt))
  (to-string formulas)))


(define currTupIfAtomic_different_arity (list 'Node0 'Node1))
; arity 2
(define LHS_different_arity edges)
; arity 1
(define RHS_different_arity Node)
(define rightTupleContext_different_arity (projectTupleRange
                                           currTupIfAtomic_different_arity
                                           (- (node/expr-arity LHS_different_arity) 1)
                                           (node/expr-arity RHS_different_arity)))
(define leftTupleContext_different_arity (projectTupleRange currTupIfAtomic_different_arity 0 (node/expr-arity LHS_different_arity)))
(define formulas_different_arity (list
                                  (node/formula/op/in empty-nodeinfo (list (tup2Expr leftTupleContext_different_arity udt empty-nodeinfo) LHS_different_arity))
                                  (node/formula/op/in empty-nodeinfo (list (tup2Expr rightTupleContext_different_arity udt empty-nodeinfo) RHS_different_arity))))
(@test-case
 "TEST product-helper on valid input different arity"
 (@check-equal?
  (to-string (product-helper (list Node edges) (list Node edges) currTupIfAtomic_different_arity empty-nodeinfo udt))
  (to-string formulas_different_arity)))

; join-helper


; tup2Expr
(define tuple (list 'Node0 'Node1 'Node2))

(@test-case
 "TEST tup2ExprValid"
 (@check-equal?
  (to-string (tup2Expr tuple udt empty-nodeinfo))
  (to-string (node/expr/op/-> empty-nodeinfo 3 (list
                                                (node/expr/atom empty-nodeinfo 1 'Node0)
                                                (node/expr/atom empty-nodeinfo 1 'Node1)
                                                (node/expr/atom empty-nodeinfo 1 'Node2))))))
; empty list
(@check-exn
 exn:fail?
 (lambda () 
   (tup2Expr '() udt empty-nodeinfo)))

; not a list
(@check-exn
 exn:fail?
 (lambda () 
   (tup2Expr 'Node0 udt empty-nodeinfo)))

; element that is a list
(@check-exn
 exn:fail?
 (lambda () 
   (tup2Expr (list (list 'Node0)) udt empty-nodeinfo)))

; transposeTup
(define tup-arity-2 (list 1 2))
(define tup-arity-3 (list 1 2 3))

(@test-case
 "TEST transposeTup on valid tuple"
 (@check-equal?
  (to-string (transposeTup tup-arity-2))
  (to-string (list 2 1))))

(@check-exn
 exn:fail?
 (lambda () 
   (transposeTup tup-arity-3)))

; mustHaveTupleContext
; not list
(@check-exn
 exn:fail?
 (lambda () 
   (mustHaveTupleContext 'Node0 edges)))


; length of tup is 0
(@check-exn
 exn:fail?
 (lambda () 
   (mustHaveTupleContext '() edges)))

; first thing in tuple is a list
(@check-exn
 exn:fail?
 (lambda () 
   (mustHaveTupleContext (list (list 'Node0)) edges)))


; isGroundProduct
; not an expr error
(@check-exn
 exn:fail?
 (lambda () 
   (isGroundProduct (node/int/constant empty-nodeinfo 1))))

; quantifier-var
(@test-case
 "TEST isGroundProduct on valid quantifier-var"
 (@check-equal?
  (to-string (isGroundProduct (node/expr/quantifier-var empty-nodeinfo 1 (gensym "m2q"))))
  (to-string #t)))

; return false
(define product-expr (node/expr/op/-> empty-nodeinfo 2 (list Node Node)))
(@test-case
 "TEST isGroundProduct on valid product-expr"
 (@check-equal?
  (to-string (isGroundProduct product-expr))
  (to-string #f)))

; product case, should return true
(define quantifier-expr (node/expr/op/-> empty-nodeinfo 1 (list (node/expr/atom empty-nodeinfo 1 'Node0))))
(@test-case
 "TEST isGroundProduct quantifier case"
 (@check-equal?
  (to-string (isGroundProduct quantifier-expr))
  (to-string #t)))

; number and constant
(@test-case
 "TEST isGroundProduct on valid constant"
 (@check-equal?
  (to-string (isGroundProduct (node/expr/constant empty-nodeinfo 1 'Int)))
  (to-string #t)))

; atom
(@test-case
 "TEST transposeTup on valid tuple"
 (@check-equal?
  (to-string (transposeTup tup-arity-2))
  (to-string (list 2 1))))

; getColumnRight
; error
(@check-exn
 exn:fail?
 (lambda () 
   (getColumnRight '())))

; valid arity more than 1 (hits recursive call and base case)
(@test-case
 "TEST getColumnRight on valid"
 (@check-equal?
  (to-string (getColumnRight edges))
  (to-string (join univ edges))))

; getColumnLeft
; error
(@check-exn
 exn:fail?
 (lambda () 
   (getColumnLeft '())))

; valid arity more than 1 (hits recursive call and base case)
(@test-case
 "TEST getColumnLeft on valid"
 (@check-equal?
  (to-string (getColumnLeft edges))
  (to-string (join edges univ))))

; createNewQuantifier
(define form (in edges edges))

; error length decls not 1
(@check-exn
 exn:fail?
 (lambda () 
   (createNewQuantifier (list 1 2) '() form udt empty-nodeinfo 'some '())))

; error desugaring unsupported
(@check-exn
 exn:fail?
 (lambda () 
   (createNewQuantifier (list 1) '() form udt empty-nodeinfo 'no '())))

; some case


; all case
