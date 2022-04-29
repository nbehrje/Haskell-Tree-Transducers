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
> dSubj ["qBe"] "AUX" = [("qAUX", Node "AUX" [VarIdx 0])]
> dSubj ["qAdjective"] "ADJ" = [("qADJ", Node "ADJ" [VarIdx 0])]
> dSubj ["qVerb"] "V" = [("qV", Node "V" [VarIdx 0])]
> dSubj ["qV"] "VP" = [("qVP", Node "VP" [VarIdx 0])]
> dSubj ["qAUX", "qV"] "VP" = [("qVP", Node "VP" [VarIdx 0, VarIdx 1])]
> dSubj ["qAUX", "qADJ"] "VP" = [("qVP", Node "VP" [VarIdx 0, VarIdx 1])]
> dSubj ["qNPWh", "qVP"] "TP" = [("qTPWh", Node "TP" [VarIdx 1])]
> dSubj ["qTPWh"] "C'" = [("qC'Wh", Node "C'" [VarIdx 0])]
> dSubj ["qC'Wh"] "CP" = [("qCWh", Node "CP" [Node "NP" [Node "what" []], VarIdx 0])]
> dSubj _ _ = [("undef", VarIdx (-1))]

The dog is big.
What is big?

> test1In = tCP [tC' [tTP [tNP [tLf "the dog"], tVP [tAUX [tLf "is"], tADJ [tLf "big"]]]]]

> test1Out = [tCP [tNP [tLf "what"], tC' [tTP [tVP [tAUX [tLf "is"], tADJ [tLf "big"]]]]]]

The dogs are big.
What are big?

> test2In = tCP [tC' [tTP [tNP [tLf "the dogs"], tVP [tAUX [tLf "are"], tADJ [tLf "big"]]]]]

> test2Out = [tCP [tNP [tLf "what"], tC' [tTP [tVP [tAUX [tLf "are"], tADJ [tLf "big"]]]]]]

I am big.
What is big?

> test3In = tCP [tC' [tTP [tNP [tLf "I"], tVP [tAUX [tLf "am"], tADJ [tLf "big"]]]]]

> test3Out = [tCP [tNP [tLf "what"], tC' [tTP [tVP [tAUX [tLf "is"], tADJ [tLf "big"]]]]]]

The dog runs.
What runs?

> test4In = tCP [tC' [tTP [tNP [tLf "the dog"], tVP [tV [tLf "runs"]]]]]

> test4Out = [tCP [tNP [tLf "what"], tC' [tTP [tVP [tV [tLf "runs"]]]]]]

The dogs are running.
What are running?

> test5In = tCP [tC' [tTP [tNP [tLf "the dogs"], tVP [tAUX [tLf "are"], tV [tLf "running"]]]]]

> test5Out = [tCP [tNP [tLf "what"], tC' [tTP [tVP [tAUX [tLf "are"], tV [tLf "running"]]]]]]


== Subject and Object ==

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