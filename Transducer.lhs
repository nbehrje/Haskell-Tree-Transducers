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
>                                   outputs = (map (\((rootState,rootTree), children) -> (rootState, fillVars rootTree children)) (filter (\((rootState,rootTree), children) -> rootTree /= VarIdx (-1)) ((concatMap (\children -> (map (\rootOut -> (rootOut, (map snd) children))) (d ((map fst) children) n))) childrenProd)))

> transduce tt (Node n ts) = map snd (process tt (Node n ts))