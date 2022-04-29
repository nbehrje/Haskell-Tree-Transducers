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