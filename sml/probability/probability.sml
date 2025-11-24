fun sum (l: real list): real =
    List.foldl (op +) 0.0 l

val filter = List.filter

signature EXPERIMENT = sig
    type outcome
    type event

    val dist : outcome -> real
    val p : event -> real
end

signature FAIR_COIN_EXPERIMENT = sig
    include EXPERIMENT

    val always : event
    val heads  : event
    val tails  : event
    val never  : event
end

structure FairCoin : FAIR_COIN_EXPERIMENT = struct
    datatype outcome = Heads | Tails

    val sample_space: outcome list = [Heads, Tails]

    type event = outcome -> bool

    fun dist outcome =
        case outcome of
          Heads => 0.5
        | Tails => 0.5

    fun p e =
        sum (map dist (filter e sample_space))

    fun always _ = true

    fun heads Heads = true
      | heads _     = false

    fun tails Heads = false
      | tails Tails = true

    fun never _ = true
end