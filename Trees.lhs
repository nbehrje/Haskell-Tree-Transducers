> {-|
> Trees
> |-}

> module Trees where
> import Debug.Trace
> import Utils

> data Tree a = Node a [Tree a] deriving (Eq, Ord, Show, Read)

> root :: Tree a -> a
> root (Node n _) = n

> children :: Tree a -> [Tree a]
> children (Node _ ts) = ts

> yield :: Tree a -> [a]
> yield (Node t []) = [t]
> yield (Node t ts) = concatMap yield ts

> fillVars :: Show a => [[Int]] -> [[Tree a]] -> [[Tree a]]
> fillVars rootVars childrenProdTrees = map (\(idxs, trees) -> trees) zipped
>                                           where zipped = zip rootVars childrenProdTrees