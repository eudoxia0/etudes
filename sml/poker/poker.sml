structure Poker = struct
  datatype suit = Clubs
                | Diamonds
                | Hearts
                | Spades

  datatype rank = Ace
                | King
                | Queen
                | Jack
                | R10
                | R9
                | R8
                | R7
                | R6
                | R5
                | R4
                | R3
                | R2

  datatype card = Card of suit * rank

  fun rankInt Ace = 14
    | rankInt King = 13
    | rankInt Queen = 12
    | rankInt Jack = 11
    | rankInt R10 = 10
    | rankInt R9 = 9
    | rankInt R8 = 8
    | rankInt R7 = 7
    | rankInt R6 = 6
    | rankInt R5 = 5
    | rankInt R4 = 4
    | rankInt R3 = 3
    | rankInt R2 = 2

  datatype hand_class = StraightFlush of rank
                      | FourOfAKind of rank * rank
                      | FullHouse of rank * rank
                      | Flush of rank * rank * rank * rank * rank
                      | Straight of rank
                      | ThreeOfAKind of rank * rank * rank
                      | TwoPair of rank * rank * rank
                      | OnePair of rank * rank * rank * rank
                      | HighestCard of rank * rank * rank * rank * rank
end
