# Lin-637-Final

This project is an implementation of a nondeterministic finite state bottom-up tree transducer in Haskell. Included are examples that model the construction of what-questions from declarative sentences and the wh-movement therein.

## Files

### Trees.lhs

This file contains the definition of the Tree data type used for storing parse tree and some functions used to transduce those trees. It also includes some constructors for trees to conserve space.

### Transducer.lhs

This file contains the definition of the transducer and the functions to transduce trees.

### Utils.lhs

This file contains other utility functions.

### Tests.lhs

This file contains the transducers modeling what-questions and tests for the transducers.

## Usage

<code>transduce *transducer* *input_tree*</code>

### Examples

#### Example 1

Reversing the order of the children of trees with the rules `S -> a S b` and `S -> a b`.

```
example1TT = TT {
  states = ["qA","qB","qS"],
  sigma = ["a","b","S"],
  delta = delta1
 }

 delta1 [] "a" = [("qA", Node "a" [])]
 delta1 [] "b" = [("qB", Node "b" [])]
 delta1 ["qA", "qS", "qB"] "S" = [("qS", Node "S" [VarIdx 1, VarIdx 0])]
 delta1 ["qA", "qB"] "S" = [("qS", Node "S" [VarIdx 1, VarIdx 0])]
```

Command: `transduce example1TT (Node "S" [Node "a" [], Node "b" []])`

Output: `[Node "S" [Node "b" [],Node "a" []]]`

Command: `transduce example1TT (Node "S" [Node "a" [], Node "S" [Node "a" [], Node "b" []], Node "b" []])`

Output: `[Node "S" [Node "b" [],Node "S" [Node "b" [],Node "a" []],Node "a" []]]`

#### Example 2

Optionally replacing left children `a` with `c` in trees with the rules `S -> a S b`, and `S -> a b`.

```
example2TT = TT {
 states = ["qA","qB","qS"],
 sigma = ["a","b","S"],
 delta = delta2
}

delta2 [] "a" = [("qA", Node "a" [])]
delta2 [] "b" = [("qB", Node "b" [])]
delta2 ["qA", "qS", "qB"] "S" = [("qS", Node "S" [VarIdx 0, VarIdx 1, VarIdx 2]),("qS", Node "S" [Node "c" [], VarIdx 1, VarIdx 2])]
delta2 ["qA", "qB"] "S" = [("qS", Node "S" [VarIdx 0, VarIdx 1]), ("qS", Node "S" [Node "c" [], VarIdx 1])]
```

Command: `transduce example2TT (Node "S" [Node "a" [], Node "b" []])`

Output: `[Node "S" [Node "a" [],Node "b" []],Node "S" [Node "c" [],Node "b" []]]`

Command: `transduce example2TT (Node "S" [Node "a" [], Node "S" [Node "a" [], Node "b" []], Node "b" []])`

Output: 
```
[Node "S" [Node "a" [],Node "S" [Node "a" [],Node "b" []],Node "b" []],
Node "S" [Node "c" [],Node "S" [Node "a" [],Node "b" []],Node "b" []],
Node "S" [Node "a" [],Node "S" [Node "c" [],Node "b" []],Node "b" []],
Node "S" [Node "c" [],Node "S" [Node "c" [],Node "b" []],Node "b" []]]
```
