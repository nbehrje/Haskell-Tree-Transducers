> {-|
>   Utils
> |-}

> module Utils where

> cartProd :: [[a]] -> [[a]]
> cartProd [] = []
> cartProd (xs:[]) = [[x] | x <- xs]
> cartProd (xs:xss) = [ x:y | x <- xs, y <- cartProd xss]

> thd :: (a,b,c) -> c
> thd (_,_,c) = c

> fst3 :: (a,b,c) -> a
> fst3 (a,_,_) = a

> snd3 :: (a,b,c) -> b
> snd3 (_,b,_) = b