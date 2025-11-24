signature SEMIGROUP = sig
  type t

  val f : t -> t -> t
end

signature MONOID = sig
  include SEMIGROUP

  val id : t
end

signature GROUP = sig
  include MONOID

  val inv : t -> t
end

signature RING = sig
  type t

  val add : t -> t -> t
  val mul : t -> t -> t

  val zero : t
  val neg : t -> t

  val show : t -> string
end

signature UNIT_RING = sig
  include RING

  val one : t
end

signature COMMUTATIVE_FINITE_FIELD = sig
  include UNIT_RING

  val inv : t -> t
end

signature MATRIX = sig
  type t
  type rowdim
  type coldim
  type matrix

  val row : int -> rowdim
  val col : int -> coldim

  val rowi : rowdim -> int
  val coli : coldim -> int

  val rows : matrix -> rowdim
  val cols : matrix -> coldim

  val sub : matrix -> rowdim -> coldim -> t

  val gen : rowdim -> coldim -> ((rowdim * coldim) -> t) -> matrix
  val zeros : rowdim -> coldim -> matrix
  val ones : rowdim -> coldim -> matrix
  val eye : rowdim -> coldim -> matrix

  exception IncompatibleSizes
  val add : matrix -> matrix -> matrix
  val neg : matrix -> matrix
  (*val sub : matrix -> matrix -> matrix*)

  val rowIndices : matrix -> rowdim list
  val colIndices : matrix -> coldim list

  val show : matrix -> string
end

functor Matrix(f: COMMUTATIVE_FINITE_FIELD): MATRIX = struct
  structure V = Vector

  type t = f.t
  datatype rowdim = Row of int
       and coldim = Col of int
  type matrix = t V.vector V.vector

  val row = Row
  val col = Col

  fun rowi (Row r) = r
  fun coli (Col c) = c

  fun rows mat = Row (V.length (V.sub (mat, 0)))
  fun cols mat = Col (V.length mat)

  fun sub mat (Row row) (Col col) = V.sub (V.sub (mat, col), row)

  fun gen (Row rows) (Col cols) f = let fun genCol col = V.tabulate (rows, fn (row) => f (Row row, Col col))
                                    in
                                        V.tabulate (cols, genCol)
                                    end

  fun zeros rows cols = gen rows cols (fn (r, c) => f.zero)
  fun ones rows cols = gen rows cols (fn (r, c) => f.one)
  fun eye rows cols = gen rows cols (fn (r, c) => if rowi r = coli c then f.one else f.zero)

  fun rowIndices m = List.tabulate (rowi (rows m), fn i => Row i)
  fun colIndices m = List.tabulate (coli (cols m), fn i => Col i)

  exception IncompatibleSizes

  fun add a b = if (rows a) = (rows b) andalso (cols a) = (cols b) then
                    add' a b
                else
                    raise IncompatibleSizes
  and add' a b = gen (rows a) (cols a) (fn (r, c) => f.add (sub a r c) (sub b r c))

  fun neg m = gen (rows m) (cols m) (fn (r, c) => f.neg (sub m r c))

  (*fun sub a b = add a (neg b)*)

  fun show m = String.concatWith "\n" (map (fn r => showRow m r) (rowIndices m))
  and showRow m r = let val vals = map (fn c => f.show (sub m r c)) (colIndices m)
                    in
                        "| " ^ (String.concatWith " " vals) ^ " |"
                    end
end

structure RealField : COMMUTATIVE_FINITE_FIELD = struct
  open Real

  type t = real

  fun add a b = a + b
  fun mul a b = a * b
  fun neg a = ~a
  val zero = 0.0
  val one = 1.0
  fun inv a = if ((op ==) (a, zero)) then
                  raise Div
              else
                  0.0

  val show = Real.toString
end

structure MatrixR = Matrix(RealField)

open MatrixR

val m = zeros (row 2) (col 3);
rows m;
cols m;

print (show m);
