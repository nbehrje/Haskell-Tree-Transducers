> {-|
> Transducer
> |-}


> module Transducer where
> import Trees
> import Debug.Trace
> import Utils

> data BFTT q b = TT { states :: [q]
>                      , sigma  :: [b]
>                      , finals :: [q]
>                      , delta  :: [q] -> b -> [(q, Tree b)]}

> process :: Show q => Show b => BFTT q b -> Tree b -> [(q, Tree b)]
> process tt (Node n []) =  map (\(state, tree) -> (state, tree)) (d [] n) 
>                             where d = delta tt
> process tt (Node n ts) =  outputs
>                             where d = delta tt
>                                   childrenProd = cartProd (map (process tt) ts)
>                                   childrenStates = map (map fst) childrenProd
>                                   childrenProdTrees = map (map snd) childrenProd
>                                   rootOutputs = concat [d children n | children <- childrenStates]
>                                   valid = filter (isValid . snd . fst) (zip rootOutputs childrenProdTrees)
>                                   (validRootOutputs, validChildTrees) = unzip valid
>                                   (validStates, validVarTrees) = unzip validRootOutputs
>                                   filledChildTrees = map (uncurry fillVars) (zip validVarTrees validChildTrees)
>                                   outputs = (zip validStates filledChildTrees)

> transduce tt (Node n ts) = map snd  (process tt (Node n ts))
>                               where f = finals tt