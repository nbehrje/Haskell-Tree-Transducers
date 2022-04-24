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

> process :: Show b => Show q =>  BFTT q b -> Tree b -> [(q, Tree b)]
> process tt (Node n []) = traceShow ("processing",n) map (\(state, root, _) -> (state, Node root [])) (d [] n) 
>                             where d = delta tt
> process tt (Node n ts) = traceShow ("processing",n) (map (\((state, root, _),trees) -> (state, Node root trees)) (zip rootOutputs rootTrees))
>                             where d = delta tt
>                                   childrenProd = traceShow ("childrenProd",n,cartProd (map (process tt) ts)) cartProd (map (process tt) ts)
>                                   childrenStates = traceShow ("childrenStates",map (map fst) childrenProd) (map (map fst) childrenProd)
>                                   childrenProdTrees = traceShow ("childrenProdTrees",map (map snd) childrenProd) (map (map snd) childrenProd)
>                                   rootOutputs = traceShow ("rootOutputs", concat [d children n | children <- childrenStates]) (concat [d children n | children <- childrenStates])
>                                   rootStates = traceShow ("rootStates",map fst3 rootOutputs) (map fst3 rootOutputs)
>                                   rootVars = traceShow ("rootVars",map thd rootOutputs) (map thd rootOutputs)
>                                   rootOutroots = traceShow ("rootStates",map snd3 rootOutputs) (map snd3 rootOutputs)
>                                   rootTrees = traceShow ("fillVars", fillVars rootVars childrenProdTrees) (fillVars rootVars childrenProdTrees)

 process tt (Node n ts) = traceShow("processing",n) zip rootStates rootTrees
                             where d = delta tt
                                   childrenProd = traceShow ("childrenProd",n,cartProd (map (process tt) ts)) (cartProd (map (process tt) ts))

                                   childrenProdTrees = traceShow ("childrenProdTrees",map (map snd) childrenProd) (map (map snd) childrenProd)
                                   childrenStates = traceShow ("childrenStates",map (map fst) childrenProd) (map (map fst) childrenProd)
                                   rootOutputs = traceShow ("rootOutputs", concat [d children n | children <- childrenStates]) (concat [d children n | children <- childrenStates])
                                   rootStates = traceShow ("rootStates",map fst rootOutputs) (map fst rootOutputs)
                                   rootVars = traceShow ("rootVars",map snd rootOutputs) (map snd rootOutputs)
                                   rootTrees = traceShow ("fillVars", fillVars rootVars childrenProdTrees) (fillVars rootVars childrenProdTrees)

[[(q1, tree1),(q2, tree2)], [(q1, tree3), (q2, tree4)]]