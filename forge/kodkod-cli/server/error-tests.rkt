#lang reader "kkcli-reader.rkt"


(configure :bitwidth 4 :solver SAT4J :max-solutions 1 :verbosity 7 :sb 20 :core-gran 0 :log-trans 1)
(univ 20)
(ints [(-8 0)(-7 1)(-6 2)(-5 3)(-4 4)(-3 5)(-2 6)(-1 7)(0 8)(1 9)(2 10)(3 11)(4 12)(5 13)(6 14)(7 15)])
(r4 [{(0 1) (1 2) (2 3) (3 4) (4 5) (5 6) (6 7) (7 8) (8 9) (9 10) (10 11) (11 12) (12 13) (13 14) (14 15)} :: {(0 1) (1 2) (2 3) (3 4) (4 5) (5 6) (6 7) (7 8) (8 9) (9 10) (10 11) (11 12) (12 13) (13 14) (14 15)}])
(r2 [none :: {(16) (17) (18) (19)}])
(r3 [{(0) (1) (2) (3) (4) (5) (6) (7) (8) (9) (10) (11) (12) (13) (14) (15)} :: {(0) (1) (2) (3) (4) (5) (6) (7) (8) (9) (10) (11) (12) (13) (14) (15)}])
(r1 [(-> none none) :: {(16 16) (16 17) (16 18) (16 19) (17 16) (17 17) (17 18) (17 19) (18 16) (18 17) (18 18) (18 19) (19 16) (19 17) (19 18) (19 19)}])
(r0 [(-> none none) :: {(16 16) (16 17) (16 18) (16 19) (17 16) (17 17) (17 18) (17 19) (18 16) (18 17) (18 18) (18 19) (19 16) (19 17) (19 18) (19 19)}])
(f0 (in r0 (-> r2 r2 )))
(assert f0)
(f1 (in r1 (-> r2 r2 )))
(assert f1)
(f2 (&& (in (. r2 r1) r0 )))
(assert f2)
(solve)


