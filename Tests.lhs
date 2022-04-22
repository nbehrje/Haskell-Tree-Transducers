> {-|
> Test Sentences
> |-}

> import Trees

== Subject only ==

The dog is big.
What is big?

> test1In = Node "S" [
>                    Node "NP" [
>                        Node "N" [
>                            Node "the dog" []
>                        ]
>                    ],
>                    Node "VP" [
>                        Node "AUX" [
>                            Node "is" []
>                        ],
>                        Node "ADJ" [
>                            Node "big" []
>                        ]
>                    ]
>   ]

> test1Out = Node "S" [
>                   Node "WP" [
>                       Node "what" []
>                   ],
>                   Node "VP" [
>                       Node "AUX" [
>                            Node "is" []
>                       ],
>                        Node "ADJ" [
>                            Node "big" []
>                        ]
>                   ]
>   ]

The dogs are big.
What are big?

> test2In = Node "S" [
>                    Node "NP" [
>                        Node "N" [
>                            Node "the dogs" []
>                        ]
>                    ],
>                    Node "VP" [
>                        Node "AUX" [
>                            Node "are" []
>                        ],
>                        Node "ADJ" [
>                            Node "big" []
>                        ]
>                    ]
>   ]

> test2Out = Node "S" [
>                   Node "WP" [
>                       Node "what" []
>                   ],
>                   Node "VP" [
>                       Node "AUX" [
>                            Node "are" []
>                       ],
>                        Node "ADJ" [
>                            Node "big" []
>                        ]
>                   ]
>   ]

I am big.
What is big?

> test3In = Node "S" [
>                    Node "NP" [
>                        Node "N" [
>                            Node "I" []
>                        ]
>                    ],
>                    Node "VP" [
>                        Node "AUX" [
>                            Node "am" []
>                        ],
>                        Node "ADJ" [
>                            Node "big" []
>                        ]
>                    ]
>   ]

> test3Out = Node "S" [
>                   Node "WP" [
>                       Node "what" []
>                   ],
>                   Node "VP" [
>                       Node "AUX" [
>                            Node "is" []
>                       ],
>                        Node "ADJ" [
>                            Node "big" []
>                        ]
>                   ]
>   ]

The dog runs.
What runs?

> test4In = Node "S" [
>                    Node "NP" [
>                        Node "N" [
>                            Node "the dog" []
>                        ]
>                    ],
>                    Node "VP" [
>                        Node "V" [
>                            Node "runs" []
>                        ]
>                    ]
>   ]

> test4Out = Node "S" [
>                   Node "WP" [
>                       Node "what" []
>                   ],
>                   Node "VP" [
>                        Node "V" [
>                            Node "runs" []
>                        ]
>                   ]
>   ]

The dogs are running.
What are running?

> test5In = Node "S" [
>                    Node "NP" [
>                        Node "N" [
>                            Node "the dog" []
>                        ]
>                    ],
>                    Node "VP" [
>                        Node "AUX" [
>                            Node "is" []
>                        ],
>                        Node "V" [
>                            Node "running" []
>                        ]
>                    ]
>   ]

> test5Out = Node "S" [
>                   Node "WP" [
>                       Node "what" []
>                   ],
>                   Node "VP" [
>                        Node "AUX" [
>                            Node "is" []
>                        ],
>                        Node "V" [
>                            Node "running" []
>                        ]
>                    ]
>   ]