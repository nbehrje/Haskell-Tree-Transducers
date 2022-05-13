> {-|
> Transducer
> |-}


> module Transducer where
> import Trees
> import Debug.Trace
> import Data.List
> import Utils

> data BFTT q b = TT { states :: [q]
>                      , sigma  :: [b]
>                      , delta  :: [q] -> b -> [(q, Tree b)]}

> process :: Show q => Show b => Eq b => Eq q => BFTT q b -> Tree b -> [(q, Tree b)]
> process tt (Node n []) =  output
>                             where d = delta tt
>                                   output = map (\(state, tree) -> (state, tree)) (d [] n) 
> process tt (Node n ts) =  outputs
>                             where d = delta tt
>                                   childrenProd = (cartProd (map (process tt) ts))
>                                   rootChildrenPairs = concatMap (\children -> (map (\rootOut -> (rootOut, (map snd) children))) (d ((map fst) children) n)) childrenProd
>                                   validRootChildrenPairs = filter (\((rootState,rootTree), children) -> rootTree /= VarIdx (-1)) rootChildrenPairs
>                                   outputs = map (\((rootState,rootTree), children) -> (rootState, fillVars rootTree children)) validRootChildrenPairs
> process _ _ = []

> transduce :: (Show a, Show b, Eq b, Eq a) => BFTT a b -> Tree b -> [Tree b]
> transduce tt (Node n ts) = map snd (process tt (Node n ts))
> transduce _ _ = []