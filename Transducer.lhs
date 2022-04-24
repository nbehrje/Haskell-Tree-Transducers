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
>                      , delta  :: [q] -> b -> [(q, b, [Int])]}

> process :: Show q => Show b => BFTT q b -> Tree b -> [(q, Tree b)]
> process tt (Node n []) =  map (\(state, root, _) -> (state, Node root [])) (d [] n) 
>                             where d = delta tt
> process tt (Node n ts) =  outTrees
>                             where d = delta tt
>                                   childrenProd = cartProd (map (process tt) ts)
>                                   childrenStates = map (map fst) childrenProd
>                                   childrenProdTrees = map (map snd) childrenProd
>                                   rootOutputs = concat [d children n | children <- childrenStates]
>                                   valid = filter (\((_,_,vars),_) -> vars /= [-1]) (zip rootOutputs childrenProdTrees)
>                                   (validRootOutputs, validChildTrees) = unzip valid
>                                   (validStates, validOuts, validVars) = unzip3 validRootOutputs
>                                   filledChildTrees = fillVars validVars validChildTrees
>                                   outTrees = map (\(state, root, children) -> (state, Node root children)) (zip3 validStates validOuts filledChildTrees)

> transduce tt (Node n ts) = map snd  (process tt (Node n ts))
>                               where f = finals tt