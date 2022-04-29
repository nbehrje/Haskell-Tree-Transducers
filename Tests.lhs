> {-|
> Test Sentences
> |-}

> import Trees
> import Transducer
  
> runTests tt tests = map (\(inTree, outTrees) -> transduce tt inTree == outTrees) tests

== Subject only ==

> testSubj = runTests subjTT [(test1In, test1Out),(test2In,test2Out),(test3In,test3Out),(test4In,test4Out),(test5In,test5Out)]

> subjTT = TT {
>         states = ["qNP", "qWP"]
>       , sigma = ["the dog"]
>       , finals = ["qCPWh"]
>       , delta = dSubj
> }

> dSubj [] "the dog" = [("qNoun", Node "the dog" []), ("qWhat", Node "what" [])]
> dSubj [] "the dogs" = [("qNoun", Node "the dogs" []), ("qWhat", Node "what" [])]
> dSubj [] "I" = [("qNoun", Node "I" []), ("qWhat", Node "what" [])]
> dSubj [] "is" = [("qBe", Node "is" [])]
> dSubj [] "are" = [("qBe", Node "are" [])]
> dSubj [] "am" = [("qBe", Node "is" [])]
> dSubj [] "big" = [("qAdjective", Node "big" [])]
> dSubj [] "runs" = [("qVerb", Node "runs" [])]
> dSubj [] "run" = [("qVerb", Node "run" [])]
> dSubj [] "running" = [("qVerb", Node "running" [])]
> dSubj ["qNoun"] "NP" = [("qNP", Node "NP" [VarIdx 0])]
> dSubj ["qWhat"] "NP" = [("qNPWh", Node "NP" [])]
> dSubj ["qBe"] "T" = [("qT", Node "T" [VarIdx 0])]
> dSubj ["qAdjective"] "ADJ" = [("qADJ", Node "ADJ" [VarIdx 0])]
> dSubj ["qVerb"] "V" = [("qV", Node "V" [VarIdx 0])]
> dSubj ["qV"] "VP" = [("qVP", Node "VP" [VarIdx 0])]
> dSubj ["qVP"] "T'" = [("qT'", Node "T'" [VarIdx 0])]
> dSubj ["qT", "qADJ"] "T'" = [("qT'", Node "T'" [VarIdx 0, VarIdx 1])]
> dSubj ["qT", "qVP"] "T'" = [("qT'", Node "T'" [VarIdx 0, VarIdx 1])]
> dSubj ["qNPWh", "qT'"] "TP" = [("qTPWh", Node "TP" [VarIdx 1])]
> dSubj ["qTPWh"] "C'" = [("qC'Wh", Node "C'" [VarIdx 0])]
> dSubj ["qC'Wh"] "CP" = [("qCWh", Node "CP" [tWhat, VarIdx 0])]
> dSubj _ _ = [("undef", VarIdx (-1))]

The dog is big.
What is big?

> test1In = tCP [tC' [tTP [tNP [tLf "the dog"], tT' [tT "is", tADJ "big"]]]]

> test1Out = [tCP [tWhat, tC' [tTP [tT' [tT "is", tADJ "big"]]]]]

The dogs are big.
What are big?

> test2In = tCP [tC' [tTP [tNP [tLf "the dog"], tT' [tT "are", tADJ "big"]]]]

> test2Out = [tCP [tWhat, tC' [tTP [tT' [tT "are", tADJ "big"]]]]]

I am big.
What is big?

> test3In = tCP [tC' [tTP [tNP [tLf "I"], tT' [tT "am", tADJ "big"]]]]

> test3Out = [tCP [tWhat, tC' [tTP [tT' [tT "is", tADJ "big"]]]]]

The dog runs.
What runs?

> test4In = tCP [tC' [tTP [tNP [tLf "the dog"], tT' [tVP [tV "runs"]]]]]

> test4Out = [tCP [tWhat, tC' [tTP [tT' [tVP [tV "runs"]]]]]]

The dogs are running.
What are running?

> test5In = tCP [tC' [tTP [tNP [tLf "the dogs"], tT' [tT "are", tVP [tV "running"]]]]]

> test5Out = [tCP [tWhat, tC' [tTP [tT' [tT "are", tVP [tV "running"]]]]]]


== Subject and Object ==


> subjObjTT = TT {
>         states = ["qNP", "qWP"]
>       , sigma = ["the dog"]
>       , finals = ["qCPWh"]
>       , delta = dSubjObj
> }

> dSubjObj [] "an animal" = [("qNoun", Node "an animal" []), ("qWhat", Node "what" [])]
> dSubjObj qs n = dSubj qs n

The dog is an animal.
What is the dog?
What is an animal?


The dogs are animals.
What are the dogs?
What are animals?

The dog chases the cat.
What does the dog chase?
What chases the cat?

The dogs chase the cats.
What do the dogs chase?
What chase the cat?

The dogs are chasing the cats.
What are chasing the cats?
What are the dogs chasing?