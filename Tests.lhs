> {-|
> Test Sentences
> |-}

> import Trees
> import Transducer
  
> runTests tt tests = map (\(inTree, outTrees) -> transduce tt inTree == outTrees) tests

== Subject only ==

> testSubj = runTests subjTT [(test1In, test1Out),(test2In,test2Out),(test3In,test3Out),(test4In,test4Out)]

> subjTT = TT {
>         states = ["qNP", "qWP"]
>       , sigma = ["the dog"]
>       , finals = ["qCPWh"]
>       , delta = dSubj
> }

> dSubj [] "the dog" = [("qNoun", Node "the dog" []), ("qWhat", Node "what" [])]
> dSubj [] "the dogs" = [("qNoun", Node "the dogs" []), ("qWhat", Node "what" [])]
> dSubj [] "I" = [("qNoun", Node "I" []), ("qWhat", Node "what" [])]
> dSubj [] "is" = [("qIs", Node "is" [])]
> dSubj [] "are" = [("qAre", Node "are" [])]
> dSubj [] "am" = [("qIs", Node "is" [])]
> dSubj [] "big" = [("qAdjective", Node "big" [])]
> dSubj [] "runs" = [("qVerb_sing", Node "runs" [])]
> dSubj [] "run" = [("qVerb_pl", Node "run" [])]
> dSubj ["qNoun"] "NP" = [("qNP", Node "NP" [VarIdx 0])]
> dSubj ["qWhat"] "NP" = [("qNPWh", Node "NP" [])]
> dSubj ["qIs"] "T" = [("qT_is", Node "T" [])]
> dSubj ["qAre"] "T" = [("qT_are", Node "T" [])]
> dSubj ["qAdjective"] "ADJ" = [("qADJ", Node "ADJ" [VarIdx 0])]
> dSubj ["qVerb_sing"] "V" = [("qV_sing", Node "V" [VarIdx 0])]
> dSubj ["qVerb_pl"] "V" = [("qV_pl", Node "V" [VarIdx 0])]
> dSubj ["qV_sing"] "VP" = [("qVP_sing", Node "VP" [VarIdx 0])]
> dSubj ["qV_pl"] "VP" = [("qVP_pl", Node "VP" [VarIdx 0])]
> dSubj ["qVP_sing"] "T'" = [("qT'_sing", Node "T'" [VarIdx 0])]
> dSubj ["qVP_pl"] "T'" = [("qT'_pl", Node "T'" [VarIdx 0])]
> dSubj ["qT_is", "qADJ"] "T'" = [("qT'_is", Node "T'" [VarIdx 1])]
> dSubj ["qT_are", "qADJ"] "T'" = [("qT'_are", Node "T'" [VarIdx 1])]
> dSubj ["qNPWh", "qT'_is"] "TP" = [("qTPWh_is", Node "TP" [VarIdx 1])]
> dSubj ["qNPWh", "qT'_are"] "TP" = [("qTPWh_are", Node "TP" [VarIdx 1])]
> dSubj ["qNPWh", "qT'_null"] "TP" = [("qTPWh_null", Node "TP" [VarIdx 1])]
> dSubj ["qNPWh", "qT'_pl"] "TP" = [("qTPWh_null", Node "TP" [VarIdx 1])]
> dSubj ["qNPWh", "qT'_sing"] "TP" = [("qTPWh_null", Node "TP" [VarIdx 1])]
> dSubj ["qTPWh_is"] "C'" = [("qC'Wh", Node "C'" [tC "is", VarIdx 0])]
> dSubj ["qTPWh_are"] "C'" = [("qC'Wh", Node "C'" [tC "are", VarIdx 0])]
> dSubj ["qTPWh_null"] "C'" = [("qC'Wh", Node "C'" [VarIdx 0])]
> dSubj ["qC'Wh"] "CP" = [("qCPWh", Node "CP" [tWhat, VarIdx 0])]
> dSubj _ _ = [("undef", VarIdx (-1))]

The dog is big.
What is big?

> test1In = tCP [tC' [tTP [tNP [tLf "the dog"], tT' [tT "is", tADJ "big"]]]]

> test1Out = [tCP [tWhat, tC' [tC "is", tTP [tT' [tADJ "big"]]]]]

The dogs are big.
What are big?

> test2In = tCP [tC' [tTP [tNP [tLf "the dog"], tT' [tT "are", tADJ "big"]]]]

> test2Out = [tCP [tWhat, tC' [tC "are", tTP [tT' [tADJ "big"]]]]]

I am big.
What is big?

> test3In = tCP [tC' [tTP [tNP [tLf "I"], tT' [tT "am", tADJ "big"]]]]

> test3Out = [tCP [tWhat, tC' [tC "is", tTP [tT' [tADJ "big"]]]]]

The dog runs.
What runs?

> test4In = tCP [tC' [tTP [tNP [tLf "the dog"], tT' [tVP [tV "runs"]]]]]

> test4Out = [tCP [tWhat, tC' [tTP [tT' [tVP [tV "runs"]]]]]]


== Subject and Object ==

> testSubjObj = runTests subjObjTT [(test5In,test5Out),(test6In, test6Out),(test7In,test7Out),(test8In,test8Out)]

> subjObjTT = TT {
>         states = ["qNP", "qWP"]
>       , sigma = ["the dog"]
>       , finals = ["qCPWh"]
>       , delta = dSubjObj
> }

> dSubjObj [] "an animal" = [("qNoun", Node "an animal" []), ("qWhat", Node "what" [])]
> dSubjObj [] "animals" = [("qNoun", Node "animals" []), ("qWhat", Node "what" [])]
> dSubjObj [] "the cat" = [("qNoun", Node "the cat" []), ("qWhat", Node "what" [])]
> dSubjObj [] "chases" = [("qVerb_sing", Node "chases" [])]
> dSubjObj [] "chase" = [("qVerb_pl", Node "chase" [])]
> dSubjObj ["qV_sing", "qNP"] "VP"= [("qVP_sing", Node "VP" [VarIdx 0, VarIdx 1])]
> dSubjObj ["qV_pl", "qNP"] "VP"= [("qVP_pl", Node "VP" [VarIdx 0, VarIdx 1])]
> dSubjObj ["qV_sing", "qNPWh"] "VP"= [("qVPWh_sing", Node "VP" [VarIdx 0])]
> dSubjObj ["qV_pl", "qNPWh"] "VP"= [("qVPWh_pl", Node "VP" [VarIdx 0])]
> dSubjObj ["qVPWh_pl"] "T'" = [("qT'Wh_do", Node "T'" [VarIdx 0])]
> dSubjObj ["qT_is","qNP"] "T'" = [("qT'_is", Node "T'" [VarIdx 1]),("qT'Wh_is", Node "T'" [])]
> dSubjObj ["qT_are","qNP"] "T'" = [("qT'_are", Node "T'" [VarIdx 1]),("qT'Wh_are", Node "T'" [])]
> dSubjObj ["qNP", "qT'Wh_is"] "TP" = [("qTPWh_is", Node "TP" [VarIdx 0])]
> dSubjObj ["qNP", "qT'Wh_are"] "TP" = [("qTPWh_are", Node "TP" [VarIdx 0])]
> dSubjObj ["qNP","qT'Wh_do"] "TP" = [("qTPWh_do", Node "TP" [VarIdx 0, VarIdx 1])]
> dSubjObj ["qTPWh_do"] "C'" = [("qC'Wh", Node "C'" [tC "do", VarIdx 0])]
> dSubjObj qs n = dSubj qs n

The dog is an animal.
What is the dog?
What is an animal?

> test5In = tCP [tC' [tTP [tNP [tLf "the dog"], tT' [tT "is", tNP [tLf "an animal"]]]]]

> test5Out = [tCP [tWhat, tC' [tC "is", tTP [tNP [tLf "the dog"]]]],
>             tCP [tWhat, tC' [tC "is", tTP [tT' [tNP [tLf "an animal"]]]]]]

The dogs are animals.
What are the dogs?
What are animals?

> test6In = tCP [tC' [tTP [tNP [tLf "the dogs"], tT' [tT "are", tNP [tLf "animals"]]]]]

> test6Out = [tCP [tWhat, tC' [tC "are", tTP [tNP [tLf "the dogs"]]]],
>             tCP [tWhat, tC' [tC "are", tTP [tT' [tNP [tLf "animals"]]]]]]

The dog chases the cat.
X What does the dog chase?
What chases the cat?

> test7In = tCP [tC' [tTP [tNP [tLf "the dog"], tT' [tVP [tV "chases", tNP [tLf "the cat"]]]]]]

> test7Out = [tCP [tWhat, tC' [tTP [tT' [tVP [tV "chases", tNP [tLf "the cat"]]]]]]]

The dogs chase the cats.
What do the dogs chase?
What chase the cats?

> test8In = tCP [tC' [tTP [tNP [tLf "the dogs"], tT' [tVP [tV "chase", tNP [tLf "the cat"]]]]]]

> test8Out = [tCP [tWhat, tC' [tC "do", tTP [tNP [tLf "the dogs"], tT' [tVP [tV "chase"]]]]],
>             tCP [tWhat, tC' [tTP [tT' [tVP [tV "chase", tNP [tLf "the cat"]]]]]]]