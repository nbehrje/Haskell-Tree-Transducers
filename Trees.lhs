> {-|
> Trees
> |-}

> module Trees where
> import Debug.Trace
> import Utils

> data Tree a = Node a [Tree a] | VarIdx Int deriving (Eq, Ord, Show, Read)

> root :: Tree a -> a
> root (Node n _) = n

> children :: Tree a -> [Tree a]
> children (Node _ ts) = ts

> yield :: Tree a -> [a]
> yield (Node t []) = [t]
> yield (Node t ts) = concatMap yield ts

> fillVars :: Tree a -> [Tree a] -> Tree a
> fillVars (Node n ts) trees = (Node n (map (\t -> fillVars t trees) ts))
> fillVars (VarIdx idx) trees = trees !! idx

> isValid :: Tree a -> Bool
> isValid (Node n ts) = True
> isValid (VarIdx idx) = idx /= (-1)

> tCP children = Node "CP" children
> tC' children = Node "C'" children
> tTP children = Node "TP" children
> tS children =  Node "S" children
> tNP children = Node "NP" children
> tVP children = Node "VP" children
> tV children = Node "V" children
> tAUX children = Node "AUX" children
> tADJ children = Node "ADJ" children
> tLf word = Node word []