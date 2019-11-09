#lang forge

sig Node {
    edges: Node
}

pred facts {
    some init: Node { some term: Node {
        edges in (Node-term) -> (Node-init)   // one->one
        all n: (Node-init) { one edges.n }
        all n: (Node-term) { one n.edges }
        init.*edges = Node
    }}
}

/*$
(mark-irreflexive edges)
*/


query1 : run facts for exactly 5 Node