(* Approximate numerical integration using the Composite Simpson's rule for x in
   [a,b]. n must be an even number. *)

datatype parity = Even | Odd

fun parity n = if (n mod 2) = 0 then Even else Odd

fun simpson (f: real -> real) (a: real) (b: real) (n: int): real =
  let val h = (b - a) / (Real.fromInt n)
      and s = (f a) + (f b)
  in
      let val l = List.tabulate (n, fn i =>
                                       case parity i of
                                           Even => 4.0 * (f (a + (Real.fromInt i) * h))
                                         | Odd => 2.0 * (f (a + (Real.fromInt i) * h)))
      in
          (List.foldl (op +) s l) * h / 3.0
      end
  end

fun power b e : real = if e = 0 then 1.0 else b * power b (e-1)

fun f' x = power x 3;

simpson f' 0.0 10.0 2;
simpson f' 0.0 10.0 100000;

fun f'' x = power x 4;

simpson f'' 0.0 10.0 2;
simpson f'' 0.0 10.0 100000;

datatype crv = CRV of { a: real, b: real, pdf: real -> real, cdf: real -> real };

fun crvPDF (CRV {a,b,pdf,cdf}) = pdf

val gaussian = CRV {
        a = Real.negInf,
        b = Real.posInf,
        pdf = fn x => let val exp = ~(power x 2) / 2.0
                          and den = Math.sqrt (2.0 * Math.pi)
                      in
                          (Math.exp exp) / den
                      end,
        cdf = fn x => x
    };

crvPDF gaussian 1.0;
