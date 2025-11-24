(* Abstract algebra in OCaml *)

(** A semigroup is a set of objects plus an associative binary operation. *)
module type SEMIGROUP = sig
  type t

  val f : t -> t -> t
end

(** A group is a set of objects plus a  binary operation `f`, such that:

  1. `f` is associative.

  2. There exists an element `e` such that `f a e = e` and `f e a = e` for all `a`.

  3. For every element `a` there exists an element `inv a` such that `inv (inv a) = a`.
 *)
module type GROUP = sig
  type t

  val f : t -> t -> t
  val e : t
  val inv : t -> t
end

(** The parity group. *)
module ParityGroup : GROUP = struct
  type t = Even | Odd

  let f (a: t) (b: t): t =
    match (a, b) with
    | (Even, Even) -> Even
    | (Even, Odd)  -> Odd
    | (Odd,  Even) -> Odd
    | (Odd,  Odd)  -> Even

  let e = Even

  let inv (a: t): t =
    match a with
    | Even -> Odd
    | Odd  -> Even
end
