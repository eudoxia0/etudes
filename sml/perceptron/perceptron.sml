(* I forget which textbook this is based on. *)

datatype class = Setosa | Versicolor

fun classNumber Setosa = 1.0
  | classNumber Versicolor = ~1.0

fun numberClass n = if (Real.==) (n, 1.0) then
                        Setosa
                    else
                        Versicolor

type example = real list * class

val data: example list = [
    ([6.6, 3.0, 4.4, 1.4], Versicolor),
    ([5.1, 3.8, 1.5, 0.3], Setosa),
    ([5.1, 3.5, 1.4, 0.2], Setosa),
    ([5.7, 3.8, 1.7, 0.3], Setosa),
    ([5.1, 3.8, 1.6, 0.2], Setosa),
    ([5.7, 2.8, 4.1, 1.3], Versicolor),
    ([6.7, 3.1, 4.7, 1.5], Versicolor),
    ([5.2, 3.4, 1.4, 0.2], Setosa),
    ([4.8, 3.4, 1.6, 0.2], Setosa),
    ([4.7, 3.2, 1.3, 0.2], Setosa),
    ([5.2, 4.1, 1.5, 0.1], Setosa),
    ([4.6, 3.2, 1.4, 0.2], Setosa),
    ([5.8, 4.0, 1.2, 0.2], Setosa),
    ([5.5, 3.5, 1.3, 0.2], Setosa),
    ([6.0, 2.9, 4.5, 1.5], Versicolor),
    ([6.5, 2.8, 4.6, 1.5], Versicolor),
    ([5.7, 2.8, 4.5, 1.3], Versicolor),
    ([5.1, 3.7, 1.5, 0.4], Setosa),
    ([5.0, 3.4, 1.6, 0.4], Setosa),
    ([4.8, 3.4, 1.9, 0.2], Setosa),
    ([5.6, 3.0, 4.1, 1.3], Versicolor),
    ([5.0, 3.3, 1.4, 0.2], Setosa),
    ([6.1, 2.9, 4.7, 1.4], Versicolor),
    ([5.9, 3.0, 4.2, 1.5], Versicolor),
    ([5.5, 2.4, 3.7, 1.0], Versicolor),
    ([5.7, 4.4, 1.5, 0.4], Setosa),
    ([5.1, 3.8, 1.9, 0.4], Setosa),
    ([4.3, 3.0, 1.1, 0.1], Setosa),
    ([4.9, 3.1, 1.5, 0.1], Setosa),
    ([4.4, 3.2, 1.3, 0.2], Setosa),
    ([6.1, 2.8, 4.0, 1.3], Versicolor),
    ([5.4, 3.4, 1.7, 0.2], Setosa),
    ([5.7, 3.0, 4.2, 1.2], Versicolor),
    ([6.1, 3.0, 4.6, 1.4], Versicolor),
    ([6.3, 2.5, 4.9, 1.5], Versicolor),
    ([7.0, 3.2, 4.7, 1.4], Versicolor),
    ([5.4, 3.9, 1.7, 0.4], Setosa),
    ([5.4, 3.9, 1.3, 0.4], Setosa),
    ([5.0, 3.6, 1.4, 0.2], Setosa),
    ([4.9, 2.4, 3.3, 1.0], Versicolor),
    ([6.2, 2.2, 4.5, 1.5], Versicolor),
    ([6.6, 2.9, 4.6, 1.3], Versicolor),
    ([4.9, 3.1, 1.5, 0.1], Setosa),
    ([5.0, 3.4, 1.5, 0.2], Setosa),
    ([6.7, 3.0, 5.0, 1.7], Versicolor),
    ([5.0, 3.5, 1.6, 0.6], Setosa),
    ([5.2, 3.5, 1.5, 0.2], Setosa),
    ([6.1, 2.8, 4.7, 1.2], Versicolor),
    ([4.4, 3.0, 1.3, 0.2], Setosa),
    ([5.1, 2.5, 3.0, 1.1], Versicolor),
    ([5.0, 2.3, 3.3, 1.0], Versicolor),
    ([6.4, 3.2, 4.5, 1.5], Versicolor),
    ([5.8, 2.6, 4.0, 1.2], Versicolor),
    ([4.9, 3.1, 1.5, 0.1], Setosa),
    ([4.6, 3.4, 1.4, 0.3], Setosa),
    ([5.6, 2.9, 3.6, 1.3], Versicolor),
    ([6.0, 2.2, 4.0, 1.0], Versicolor),
    ([6.8, 2.8, 4.8, 1.4], Versicolor),
    ([5.0, 3.2, 1.2, 0.2], Setosa),
    ([5.5, 2.3, 4.0, 1.3], Versicolor),
    ([6.2, 2.9, 4.3, 1.3], Versicolor),
    ([5.0, 3.5, 1.3, 0.3], Setosa),
    ([5.7, 2.6, 3.5, 1.0], Versicolor),
    ([5.2, 2.7, 3.9, 1.4], Versicolor),
    ([5.1, 3.4, 1.5, 0.2], Setosa),
    ([5.4, 3.7, 1.5, 0.2], Setosa),
    ([5.1, 3.5, 1.4, 0.3], Setosa),
    ([5.8, 2.7, 4.1, 1.0], Versicolor),
    ([5.8, 2.7, 3.9, 1.2], Versicolor),
    ([5.4, 3.4, 1.5, 0.4], Setosa),
    ([6.3, 2.3, 4.4, 1.3], Versicolor),
    ([6.4, 2.9, 4.3, 1.3], Versicolor),
    ([4.6, 3.6, 1.0, 0.2], Setosa),
    ([5.5, 2.4, 3.8, 1.1], Versicolor),
    ([5.0, 2.0, 3.5, 1.0], Versicolor),
    ([5.3, 3.7, 1.5, 0.2], Setosa),
    ([5.6, 3.0, 4.5, 1.5], Versicolor),
    ([5.5, 4.2, 1.4, 0.2], Setosa),
    ([4.5, 2.3, 1.3, 0.3], Setosa),
    ([5.0, 3.0, 1.6, 0.2], Setosa),
    ([6.3, 3.3, 4.7, 1.6], Versicolor),
    ([4.9, 3.0, 1.4, 0.2], Setosa),
    ([6.0, 2.7, 5.1, 1.6], Versicolor),
    ([4.7, 3.2, 1.6, 0.2], Setosa),
    ([5.4, 3.0, 4.5, 1.5], Versicolor),
    ([4.8, 3.0, 1.4, 0.1], Setosa),
    ([5.5, 2.5, 4.0, 1.3], Versicolor),
    ([4.8, 3.0, 1.4, 0.3], Setosa),
    ([6.9, 3.1, 4.9, 1.5], Versicolor),
    ([5.6, 2.7, 4.2, 1.3], Versicolor),
    ([6.0, 3.4, 4.5, 1.6], Versicolor),
    ([5.9, 3.2, 4.8, 1.8], Versicolor),
    ([6.7, 3.1, 4.4, 1.4], Versicolor),
    ([5.7, 2.9, 4.2, 1.3], Versicolor),
    ([5.1, 3.3, 1.7, 0.5], Setosa),
    ([4.4, 2.9, 1.4, 0.2], Setosa),
    ([5.6, 2.5, 3.9, 1.1], Versicolor),
    ([4.8, 3.1, 1.6, 0.2], Setosa),
    ([4.6, 3.1, 1.5, 0.2], Setosa),
    ([5.5, 2.6, 4.4, 1.2], Versicolor)
];

fun signum v = Real.fromInt (Real.sign v)

fun innerprod xs ys = foldl (op +) 0.0 (ListPair.map (fn (a, b) => a * b) (xs, ys))

fun vecadd (xs: real list) (ys: real list) =
  ListPair.map (fn (a, b) => a + b) (xs, ys)

fun vecmul (a: real) (xs: real list) = map (fn x => a * x) xs

fun perceptron inputs weights = signum (innerprod inputs weights)

fun zero n = List.tabulate (n, fn i => 0.0)

fun train (data: example list) n eta =
  let val weights = zero n
  in
      train' data weights eta
  end
and train' data weights eta =
    case data of
        (s, c)::rest => let val y = perceptron s weights
                        in
                            let val d = if (c = numberClass y) then
                                            1.0
                                        else
                                            ~1.0
                            in
                                train' rest
                                       (vecadd weights
                                               (vecmul (eta * (d - y)) s))
                                       eta
                            end
                        end
      | nil => weights

val model = train data 4 0.1;

fun m s = numberClass (perceptron s model);

val accuracy = map (fn (s, c) => (Real.==) (perceptron s model, classNumber c)) data;

val correct = List.length (List.filter (fn x => x) accuracy);

val wrong = List.length (List.filter (fn x => not x) accuracy);
