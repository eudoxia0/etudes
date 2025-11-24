val largestWord = Word.- (Word.fromInt 0, Word.fromInt 1);

val halfwayWord = Word.div (largestWord, Word.fromInt 2);

fun printnl s = print (s ^ "\n")

fun lsb word = Word.andb (word, Word.fromInt 1)

fun mod2 word = Word.mod (word, Word.fromInt 2)

fun randBool () = let val v = Word.toInt (mod2 (MLton.Random.rand ()))
                  in
                      if v = 0 then false else true
                  end

fun randBool' () = let val w = MLton.Random.rand ()
                   in
                       if (Word.< (w, halfwayWord)) then false else true
                   end

fun seed () = let val s = MLton.Random.useed ()
              in
                  case s of
                      SOME v => let in
                                    printnl ("# Seed: " ^ (Word.toString v));
                                    MLton.Random.srand v
                                end
                    | NONE => raise Fail "Can't seed the RNG"
              end

fun sim p n = if n = 0 then
                  nil
              else
                  let val p' = step p
                  in
                      p' :: (sim p' (n-1))
                  end
and multiplier true = 1.01
  | multiplier false = 0.99
and step p = p * multiplier (randBool' ())

fun randBoolSim 0 = nil
  | randBoolSim n = (randBool ()) :: (randBoolSim (n - 1))

fun main () = let
in
    seed ();
    (*let val trials = randBoolSim 10000
    in
        let val trues = List.filter (fn x => x) trials
            and falses = List.filter (fn x => not x) trials
        in
            printnl ("Number true: " ^ (Int.toString (length trues)));
            printnl ("Number false: " ^ (Int.toString (length falses)))
        end
    end*)
    app printnl (map Real.toString (sim 100.0 1000))
end

val _ = main ();
