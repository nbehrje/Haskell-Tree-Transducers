> {-|
> Test Sentences
> |-}

> import Trees
> import Transducer
  
> runTests tt tests = map (\(inTree, outTrees) -> transduce tt inTree == outTrees) tests

== Subject only ==

> testSubj = runTests subjTT [(test1In, test1Out),(test2In,test2Out),(test3In,test3Out),(test4In,test4Out)]

> subjTT = TT {
>         states = subjStates
>       , sigma = symbols 
>       , delta = dSubj
> }

> nouns = ["the dog","the dogs","an animal","animals","the cat","the cats","the mat","the mats","the bird","the birds","the fish","I"]
> verbSing = ["runs","sits","chases","thinks"]
> verbPl = ["run","sit","chase","think"]
> adjectives = ["big"]
> symbols = nouns ++ verbSing ++ verbPl ++ ["what","is","big","are","does","on","and","that","CP","C'","C","TP","T'","T","VP","V","ADJ","CONJ","NP","N","P","PP"]
> subjStates = ["qNP","qNoun","qWhat","qIs","qAre","qAdjective","qVerb_sing","qVerb_pl","qNPWh","qT_is","qT","qT_are","qADJ","qV_sing","qV_pl","qVP_sing","qVP_pl","qT'_sing","qT'_pl","qT'_is,","qT'_are","qTPWh_is","qTPWh_are","qTPWh_null","qC'Wh","qCPWh"]

> dSubj [] n | n `elem` nouns = [("qNoun", Node n []), ("qWhat", Node "what" [])]
>            | n `elem` verbSing = [("qVerb_sing", Node n [])]
>            | n `elem` verbPl = [("qVerb_pl", Node n [])]
>            | n `elem` ["is", "am"] = [("qIs", Node "is" [])]
>            | n == "are" = [("qAre", Node "are" [])]
>            | n `elem` adjectives = [("qAdjective", Node n [])]
> dSubj ["qNoun"] "NP" = [("qNP", Node "NP" [VarIdx 0])]
> dSubj ["qWhat"] "NP" = [("qNPWh", Node "NP" [])]
> dSubj ["qIs"] "T" = [("qT_is", Node "T" []), ("qT", Node "T" [Node "is" []])]
> dSubj ["qAre"] "T" = [("qT_are", Node "T" []), ("qT", Node "T" [Node "are" []])]
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

> test1In = tCP [tC' [tTP [tNP [tN "the dog"], tT' [tT "is", tADJ "big"]]]]
> test1Out = [tCP [tWhat, tC' [tC "is", tTP [tT' [tADJ "big"]]]]]

The dogs are big.
What are big?

> test2In = tCP [tC' [tTP [tNP [tN "the dogs"], tT' [tT "are", tADJ "big"]]]]
> test2Out = [tCP [tWhat, tC' [tC "are", tTP [tT' [tADJ "big"]]]]]

I am big.
What is big?

> test3In = tCP [tC' [tTP [tNP [tN "I"], tT' [tT "am", tADJ "big"]]]]
> test3Out = [tCP [tWhat, tC' [tC "is", tTP [tT' [tADJ "big"]]]]]

The dog runs.
What runs?

> test4In = tCP [tC' [tTP [tNP [tN "the dog"], tT' [tVP [tV "runs"]]]]]
> test4Out = [tCP [tWhat, tC' [tTP [tT' [tVP [tV "runs"]]]]]]


== Subject and Object ==

> testSubjObj = runTests subjObjTT [(test5In,test5Out),(test6In, test6Out),(test7In,test7Out),(test8In,test8Out)]

> subjObjTT = TT {
>         states = subjObjStates
>       , sigma = symbols
>       , delta = dSubjObj
> }

> subjObjStates = subjStates

> dSubjObj ["qV_sing", "qNP"] "VP"= [("qVP_sing", Node "VP" [VarIdx 0, VarIdx 1])]
> dSubjObj ["qV_pl", "qNP"] "VP"= [("qVP_pl", Node "VP" [VarIdx 0, VarIdx 1])]
> dSubjObj ["qV_sing", "qNPWh"] "VP"= [("qVPWh_sing", Node "VP" [VarIdx 0])]
> dSubjObj ["qV_pl", "qNPWh"] "VP"= [("qVPWh_pl", Node "VP" [VarIdx 0])]
> dSubjObj ["qVPWh_pl"] "T'" = [("qT'Wh_do", Node "T'" [VarIdx 0])]
> dSubjObj ["qT_is","qNP"] "T'" = [("qT'_is", Node "T'" [VarIdx 1])]
> dSubjObj ["qT_is","qNPWh"] "T'" = [("qT'Wh_is", Node "T'" [])]
> dSubjObj ["qT_are","qNP"] "T'" = [("qT'_are", Node "T'" [VarIdx 1])]
> dSubjObj ["qT_are","qNPWh"] "T'" = [("qT'Wh_are", Node "T'" [])]
> dSubjObj ["qNP", "qT'Wh_is"] "TP" = [("qTPWh_is", Node "TP" [VarIdx 0, VarIdx 1])]
> dSubjObj ["qNP", "qT'Wh_are"] "TP" = [("qTPWh_are", Node "TP" [VarIdx 0, VarIdx 1])]
> dSubjObj ["qNP","qT'Wh_do"] "TP" = [("qTPWh_do", Node "TP" [VarIdx 0, VarIdx 1])]
> dSubjObj ["qTPWh_do"] "C'" = [("qC'Wh", Node "C'" [tC "do", VarIdx 0])]
> dSubjObj qs n = dSubj qs n

The dog is an animal.
What is the dog?
What is an animal?

> test5In = tCP [tC' [tTP [tNP [tN "the dog"], tT' [tT "is", tNP [tN "an animal"]]]]]
> test5Out = [tCP [tWhat, tC' [tC "is", tTP [tNP [tN "the dog"], tT' []]]],
>             tCP [tWhat, tC' [tC "is", tTP [tT' [tNP [tN "an animal"]]]]]]

The dogs are animals.
What are the dogs?
What are animals?

> test6In = tCP [tC' [tTP [tNP [tN "the dogs"], tT' [tT "are", tNP [tN "animals"]]]]]
> test6Out = [tCP [tWhat, tC' [tC "are", tTP [tNP [tN "the dogs"], tT' []]]],
>             tCP [tWhat, tC' [tC "are", tTP [tT' [tNP [tN "animals"]]]]]]

The dog chases the cat.
What chases the cat?

> test7In = tCP [tC' [tTP [tNP [tN "the dog"], tT' [tVP [tV "chases", tNP [tN "the cat"]]]]]]
> test7Out = [tCP [tWhat, tC' [tTP [tT' [tVP [tV "chases", tNP [tN "the cat"]]]]]]]

The dogs chase the cats.
What do the dogs chase?
What chase the cats?

> test8In = tCP [tC' [tTP [tNP [tN "the dogs"], tT' [tVP [tV "chase", tNP [tN "the cat"]]]]]]
> test8Out = [tCP [tWhat, tC' [tC "do", tTP [tNP [tN "the dogs"], tT' [tVP [tV "chase"]]]]],
>             tCP [tWhat, tC' [tTP [tT' [tVP [tV "chase", tNP [tN "the cat"]]]]]]]


== Prepositional Phrases ==

> testPP = runTests ppTT [(test9In, test9Out),(test10In,test10Out),(test11In, test11Out),(test12In,test12Out),(test13In,test13Out)]

> ppTT = TT {
>         states = ppStates
>       , sigma = symbols
>       , delta = dPP
> }

> ppStates = subjObjStates ++ ["qP","qPP","qPPWh"]

> dPP [] "on" = [("qPrep", Node "on" [])]
> dPP ["qPrep"] "P" = [("qP", Node "P" [VarIdx 0])]
> dPP ["qP", "qNP"] "PP" = [("qPP", Node "PP" [VarIdx 0, VarIdx 1])]
> dPP ["qP", "qNPWh"] "PP" = [("qPPWh", Node "PP" [VarIdx 0])]
> dPP ["qT_is", "qPP"] "T'" = [("qT'_is", Node "T'" [VarIdx 1])]
> dPP ["qT_is", "qPPWh"] "T'" = [("qT'Wh_is", Node "T'" [VarIdx 1])]
> dPP ["qT_are", "qPP"] "T'" = [("qT'_are", Node "T'" [VarIdx 1])]
> dPP ["qT_are", "qPPWh"] "T'" = [("qT'Wh_are", Node "T'" [VarIdx 1])]
> dPP ["qV_pl", "qPP"] "VP" = [("qVP_pl", Node "VP" [VarIdx 0, VarIdx 1])]
> dPP ["qV_pl", "qPPWh"] "VP" = [("qVPWh_pl", Node "VP" [VarIdx 0, VarIdx 1])]
> dPP ["qV_sing", "qPP"] "VP" = [("qVP_sing", Node "VP" [VarIdx 0, VarIdx 1])]
> dPP ["qV_sing", "qPPWh"] "VP" = [("qVPWh_sing", Node "VP" [VarIdx 0, VarIdx 1])]
> dPP ["qV_sing", "qNP", "qPP"] "VP" = [("qVP_sing", Node "VP" [VarIdx 0, VarIdx 1, VarIdx 2])]
> dPP ["qV_pl", "qNP", "qPP"] "VP" = [("qVP_sing", Node "VP" [VarIdx 0, VarIdx 1, VarIdx 2])]
> dPP ["qV_pl", "qNPWh", "qPP"] "VP" = [("qVPWh_pl", Node "VP" [VarIdx 0, VarIdx 2])]
> dPP ["qV_sing", "qNP", "qPPWh"] "VP" = [("qVPWh_sing", Node "VP" [VarIdx 0, VarIdx 1, VarIdx 2])]
> dPP ["qV_pl", "qNP", "qPPWh"] "VP" = [("qVPWh_pl", Node "VP" [VarIdx 0, VarIdx 1, VarIdx 2])]
> dPP qs n = dSubjObj qs n

The dog is on the mat.
What is on the mat?
What is the dog on?

> test9In = tCP [tC' [tTP [tNP [tN "the dog"], tT' [tT "is", tPP [tP "on", tNP [tN "the mat"]]]]]]
> test9Out = [tCP [tWhat, tC' [tC "is", tTP [tNP [tN "the dog"], tT' [tPP [tP "on"]]]]],
>             tCP [tWhat, tC' [tC "is", tTP [tT' [tPP [tP "on", tNP [tN "the mat"]]]]]]]

The dogs are on the mats.
What are the dogs on?
What are on the mat?

> test10In = tCP [tC' [tTP [tNP [tN "the dogs"], tT' [tT "are", tPP [tP "on", tNP [tN "the mats"]]]]]]
> test10Out = [tCP [tWhat, tC' [tC "are", tTP [tNP [tN "the dogs"], tT' [tPP [tP "on"]]]]],
>              tCP [tWhat, tC' [tC "are", tTP [tT' [tPP [tP "on", tNP [tN "the mats"]]]]]]]

The dogs sit on the mat.
What sit on the mat?
What do the dogs sit on?

> test11In = tCP [tC' [tTP [tNP [tN "the dogs"], tT' [tVP [tV "sit", tPP [tP "on", tNP [tN "the mat"]]]]]]]
> test11Out = [tCP [tWhat, tC' [tC "do", tTP [tNP [tN "the dogs"], tT' [tVP [tV "sit", tPP [tP "on"]]]]]],
>              tCP [tWhat, tC' [tTP [tT' [tVP [tV "sit", tPP [tP "on", tNP [tN "the mat"]]]]]]]]          

The dog chases [the cat] [on the mat].
What chases [the cat] [on the mat]?
X What does the dog chase on the mat?

> test12In = tCP [tC' [tTP [tNP [tN "the dog"], tT' [tVP [tV "chases", tNP [tN "the cat"], tPP [tP "on", tNP [tN "the mat"]]]]]]]
> test12Out = [tCP [tWhat, tC' [tTP [tT' [tVP [tV "chases", tNP [tN "the cat"], tPP [tP "on", tNP [tN "the mat"]]]]]]]]

The dogs chase [the cat] [on the mat].
What chase [the cat] [on the mat]?
What do the dogs chase on the mat?
What do the dogs chase the cat on?

> test13In = tCP [tC' [tTP [tNP [tN "the dogs"], tT' [tVP [tV "chase", tNP [tN "the cat"], tPP [tP "on", tNP [tN "the mat"]]]]]]]
> test13Out = [tCP [tWhat, tC' [tC "do", tTP [tNP [tN "the dogs"], tT' [tVP [tV "chase", tNP [tN "the cat"], tPP [tP "on"]]]]]],
>              tCP [tWhat, tC' [tC "do", tTP [tNP [tN "the dogs"], tT' [tVP [tV "chase", tPP [tP "on", tNP [tN "the mat"]]]]]]],
>              tCP [tWhat, tC' [tTP [tT' [tVP [tV "chase", tNP [tN "the cat"], tPP [tP "on", tNP [tN "the mat"]]]]]]]]


== Coordination == 

> testCoord = runTests coordTT [(test14In,test14Out),(test15In,test15Out)]

> coordTT = TT {
>         states = coordStates
>       , sigma = symbols
>       , delta = dCoord
> }

> coordStates = ppStates ++ ["qConj"]

> dCoord [] "and" = [("qConj", Node "and" [])]
> dCoord ["qConj"] "CONJ" = [("qCONJ", Node "CONJ" [VarIdx 0])]
> dCoord ["qNP", "qCONJ", "qNP"] "NP" = [("qNP", Node "NP" [VarIdx 0, VarIdx 1, VarIdx 2]), ("qNPWh", tWhat)]
> dCoord qs n = dPP qs n

The cat and the dog are big.
What are big?

> test14In = tCP [tC' [tTP [tNP [tNP [tN "the cat"], tConj "and", tNP [tN "the dog"]], tT' [tT "are", tADJ "big"]]]]
> test14Out = [tCP [tWhat, tC' [tC "are", tTP [tT' [tADJ "big"]]]]]

The dogs chase the cat and the bird.
What do the dogs chase?
What chase the cat and the bird?

> test15In = tCP [tC' [tTP [tNP [tN "the dogs"], tT' [tVP [tV "chase", tNP [tNP [tN "the cat"], tConj "and", tNP [tN "the bird"]]]]]]]
> test15Out = [tCP [tWhat, tC' [tC "do", tTP [tNP [tN "the dogs"], tT' [tVP [tV "chase"]]]]],
>              tCP [tWhat, tC' [tTP [tT' [tVP [tV "chase", tNP [tNP [tN "the cat"], tConj "and", tNP [tN "the bird"]]]]]]]]


== Embedded CP ==

> testEmbed = runTests embedTT [(test16In,test16Out),(test17In,test17Out)]

> embedTT = TT {
>         states = embedStates
>       , sigma = symbols
>       , delta = dEmbed
> }

> embedStates = coordStates ++ ["qComp"]

> dEmbed [] "that" = [("qComp", Node "that" [])]
> dEmbed ["qComp"] "C" = [("qC", Node "C" [VarIdx 0])]
> dEmbed ["qV_pl", "qCP"] "VP" = [("qVP_pl", Node "VP" [VarIdx 0, VarIdx 1])]
> dEmbed ["qV_pl", "qCPWh_do"] "VP" = [("qVPWh_pl", Node "VP" [VarIdx 0, VarIdx 1])]
> dEmbed ["qV_pl", "qCPWh_null"] "VP" = [("qVPWh_pl", Node "VP" [VarIdx 0, VarIdx 1])]
> dEmbed ["qNP", "qT'_pl"] "TP" = [("qTP", Node "TP" [VarIdx 0, VarIdx 1])]
> dEmbed ["qNP", "qT'"] "TP" = [("qTP", Node "TP" [VarIdx 0, VarIdx 1])]
> dEmbed ["qT", "qADJ"] "T'" = [("qT'", Node "T'" [VarIdx 0, VarIdx 1])]
> dEmbed ["qC", "qTP"] "C'" = [("qC'", Node "C'" [VarIdx 0, VarIdx 1])]
> dEmbed ["qC", "qTPWh_do"] "C'" = [("qC'Wh_do", Node "C'" [VarIdx 0, VarIdx 1])]
> dEmbed ["qC", "qTPWh_null"] "C'" = [("qC'Wh_null", Node "C'" [VarIdx 1])]
> dEmbed ["qC", "qTP_are"] "C'" = [("qC'", Node "C'" [VarIdx 0, VarIdx 1])]
> dEmbed ["qC'"] "CP" = [("qCP", Node "CP" [VarIdx 0])]
> dEmbed ["qC'Wh_do"] "CP" = [("qCPWh_do", Node "CP" [VarIdx 0])]
> dEmbed ["qC'Wh_null"] "CP" = [("qCPWh_null", Node "CP" [VarIdx 0])]
> dEmbed qs n = dCoord qs n

The birds think that the dogs chase the cats.
What think that the dogs chase the cats?
What do the birds think chase the cats?
What do the birds think that the dogs chase?
 
> test16In = tCP [tC' [tTP [tNP [tN "the birds"], tT' [tVP [tV "think", tCP [tC' [tC "that", tTP [tNP [tN "the dogs"], tT' [tVP [tV "chase", tNP [tN "the cats"]]]]]]]]]]]
> test16Out = [tCP [tWhat, tC' [tC "do", tTP [tNP [tN "the birds"], tT' [tVP [tV "think", tCP [tC' [tC "that", tTP [tNP [tN "the dogs"], tT' [tVP [tV "chase"]]]]]]]]]],
>              tCP [tWhat, tC' [tC "do", tTP [tNP [tN "the birds"], tT' [tVP [tV "think", tCP [tC' [tTP [tT' [tVP [tV "chase", tNP [tN "the cats"]]]]]]]]]]],
>              tCP [tWhat, tC' [tTP [tT' [tVP [tV "think", tCP [tC' [tC "that", tTP [tNP [tN "the dogs"], tT' [tVP [tV "chase", tNP [tN "the cats"]]]]]]]]]]]]

The fish think that the birds think that the dogs chase the cats.
What do the fish think that the birds think that the dogs chase?
What do the fish think that the birds think chase the cats?
What do the fish think think that the dogs chase the cats?
What think that the birds think that the dogs chase the cats?

> test17In = tCP [tC' [tTP [tNP [tN "the fish"], tT' [tVP [tV "think", tCP [tC' [tC "that", tTP [tNP [tN "the birds"], tT' [tVP [tV "think", tCP [tC' [tC "that", tTP [tNP [tN "the dogs"], tT' [tVP [tV "chase", tNP [tN "the cats"]]]]]]]]]]]]]]]]
> test17Out = [tCP [tWhat, tC' [tC "do", tTP [tNP [tN "the fish"], tT' [tVP [tV "think", tCP [tC' [tC "that", tTP [tNP [tN "the birds"], tT' [tVP [tV "think", tCP [tC' [tC "that", tTP [tNP [tN "the dogs"], tT' [tVP [tV "chase"]]]]]]]]]]]]]]],
>              tCP [tWhat, tC' [tC "do", tTP [tNP [tN "the fish"], tT' [tVP [tV "think", tCP [tC' [tC "that", tTP [tNP [tN "the birds"], tT' [tVP [tV "think", tCP [tC' [tTP [tT' [tVP [tV "chase", tNP [tN "the cats"]]]]]]]]]]]]]]]],
>              tCP [tWhat, tC' [tC "do", tTP [tNP [tN "the fish"], tT' [tVP [tV "think", tCP [tC' [tTP [tT' [tVP [tV "think", tCP [tC' [tC "that", tTP [tNP [tN "the dogs"], tT' [tVP [tV "chase", tNP [tN "the cats"]]]]]]]]]]]]]]]],
>              tCP [tWhat, tC' [tTP [tT' [tVP [tV "think", tCP [tC' [tC "that", tTP [tNP [tN "the birds"], tT' [tVP [tV "think", tCP [tC' [tC "that", tTP [tNP [tN "the dogs"], tT' [tVP [tV "chase", tNP [tN "the cats"]]]]]]]]]]]]]]]]]
