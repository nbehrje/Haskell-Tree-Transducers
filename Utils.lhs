> {-|
>   Utils
> |-}

> module Utils where

> cartProd :: [[a]] -> [[a]]
> cartProd [] = []
> cartProd (xs:[]) = [[x] | x <- xs]
> cartProd (xs:xss) = [ x:y | x <- xs, y <- cartProd xss]