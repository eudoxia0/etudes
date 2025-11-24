(* Variable names are strings, *)
type var = string

module VarMap =
  Map.Make(
      struct
        type t = var
        let compare = compare
      end
    )

(* Rich well formed formulae. *)
type rwff =
  | RConst of bool
  | RVar of var
  | RNot of rwff
  | RAnd of rwff * rwff
  | ROr of rwff * rwff
  | Impl of rwff * rwff
  | Iff of rwff * rwff

(* For 'minimized well formed formula' *)
type wff =
  | Const of bool
  | Var of var
  | Not of wff
  | And of wff * wff
  | Or of wff * wff

(* Remove implication and biconditional. *)
let rec minimize (a: rwff): wff =
  match a with
  | RConst b -> Const b
  | RVar v -> Var v
  | RNot x -> Not (minimize x)
  | RAnd (l, r) -> And (minimize l, minimize r)
  | ROr (l, r) -> Or (minimize l, minimize r)
  (* Remove the implication *)
  | Impl (p, q) ->
     Or (Not (minimize p), minimize q)
  (* Remove the biconditional *)
  | Iff (p, q) ->
     Or (minimize (Impl (p, q)), minimize (Impl (p, q)))

(* Remove constants *)
let rec simplify (a: wff): wff =
  match a with
  | Const b ->
     Const b
  | Var var ->
     Var var
  | Not p ->
     (match simplify p with
      (* not T -> F, not F -> T *)
      | Const b ->
         Const (not b)
      | e ->
         Not e)
  | And (p, q) ->
     let p' = simplify p
     and q' = simplify q
     in
     (match (p', q') with
      | (Const false, x) ->
         (* F and x = F *)
         Const false
      | (Const true, x) ->
         (* T and x = x *)
         x
      | (x, Const false) ->
         (* x and F = F *)
         Const false
      | (x, Const true) ->
         (* x and T = x *)
         x
      | (_, _) ->
         And (p', q'))
  | Or (p, q) ->
     let p' = simplify p
     and q' = simplify q
     in
     (match (p', q') with
      | (Const false, x) ->
         (* F or x = x *)
         x
      | (Const true, _) ->
         (* T or x = T *)
         Const true
      | (x, Const false) ->
         (* x or F = x *)
         x
      | (_, Const true) ->
         (* x or T = T *)
         Const true
      | (_, _) ->
         Or (p', q'))

(* Find a free variable. *)

let either (a: 'a option) (b: 'a option): 'a option =
  match a with
  | Some x ->
     Some x
  | None ->
     b

let rec free (e: wff): var option =
  match e with
  | Const _ ->
     None
  | Var v ->
     Some v
  | Not e ->
     free e
  | And (p, q) ->
     either (free p) (free q)
  | Or (p, q) ->
     either (free p) (free q)

(* Replace a variable with its value. *)

let rec replace (e: wff) (name: var) (value: wff): wff =
  match e with
  | Const b ->
     Const b
  | Var v ->
     if v = name then
       value
     else
       Var v
  | Not e ->
     Not (replace e name value)
  | And (p, q) ->
     And (replace p name value, replace q name value)
  | Or (p, q) ->
     Or (replace p name value, replace q name value)


(* Backtracking resolution *)

let unconst (e: wff): bool =
  match e with
  | Const b -> b
  | _ -> raise (Failure "unconst")

let rec satisfiable (e: wff): bool =
  match (free e) with
  | None ->
     unconst e
  | Some v ->
     let t = simplify (replace e v (Const true))
     and f = simplify (replace e v (Const false))
     in
     (satisfiable t) || (satisfiable f)

type bindings = bool VarMap.t

type result =
  | Satisfiable of bindings
  | Unsatisfiable

let merger (key: var) (a: bool) (b: bool): bool option =
  if a = b then
    Some a
  else
    None

let merge (a: result) (b: result): result =
  match a with
  | Satisfiable m ->
     (match b with
      | Satisfiable m' ->
         Satisfiable (VarMap.union merger m m')
      | Unsatisfiable ->
         a)
  | Unsatisfiable ->
     b

let rec satisfy (e: wff): result =
  satisfy' e VarMap.empty

and satisfy' (e: wff) (bs: bindings): result =
  match (free e) with
  | None ->
     (match unconst e with
      | true ->
         Satisfiable bs
      | false ->
         Unsatisfiable)
  | Some v ->
     let t = simplify (replace e v (Const true))
     and tbs = VarMap.add v true bs
     and f = simplify (replace e v (Const false))
     and fbs = VarMap.add v false bs
     in
     merge (satisfy' t tbs) (satisfy' f fbs)

(* Render wff to strings *)

let rec render (e: wff): string =
  match e with
  | Const true ->
     "T"
  | Const false ->
     "F"
  | Var v ->
     v
  | Not e ->
     "(¬" ^ (render e) ^ ")"
  | And (p, q) ->
     "(" ^ (render p) ^ " ∧ " ^ (render q) ^ ")"
  | Or (p, q) ->
     "(" ^ (render p) ^ " ∨ " ^ (render q) ^ ")"

let bool_str = function
  | true -> "T"
  | false -> "F"

let render_map (m: bool VarMap.t): string =
  let bs = VarMap.bindings m in
  let bs' = List.map (fun (n, b) -> n ^ " = " ^ (bool_str b)) bs in
  let m' = String.concat ", " bs' in
  "{ " ^ m' ^ " }"

let render_res (res: result): string =
  match res with
  | Satisfiable m ->
     "SAT " ^ (render_map m)
  | Unsatisfiable ->
     "USAT"

let test (e: rwff): unit =
  let e' = minimize e in
  print_endline ("Formula: " ^ (render e'));
  let sat: bool = satisfiable e' in
  print_endline ("Sat? " ^ (bool_str sat) ^ "\n")

let test' (e: rwff): unit =
  let e' = minimize e in
  print_endline ("Formula: " ^ (render e'));
  let sat: result = satisfy e' in
  print_endline ("Sat? " ^ (render_res sat) ^ "\n")

let test'' (e: wff): unit =
  print_endline ("Formula: " ^ (render e));
  let sat: result = satisfy e in
  print_endline ("Sat? " ^ (render_res sat) ^ "\n")

let formulas: rwff list = [
    RConst false;
    RConst true;
    RVar "P";
    ROr (RVar "P", RVar "Q");
    RAnd (RVar "P", RNot (RVar "P"));
  ]

(*let _ = List.iter test' formulas*)

(* Software Dependencies

       foo-v1 requires one of [bar-v1, bar-v2, bar-v3]

   means

       foo-v1 -> (bar-v1 or bar-v2 or bar-v3)

   Setup:

       Alpha
         v
           beta=v2 or beta=v3
           gamma=v3
       Beta
         v1
           delta=v1
         v2
           delta=v2
         v3
           delta=v2 or delta=v3
       Gamma
         v1
           delta=v1
         v2
           delta=v2
         v3
           delta=v3
       Delta
         v1
         v2
         v3

   Translation:

 *)

let rec ors (l: var list): rwff =
  match l with
  | first::rest::rest' ->
     ROr (RVar first, ors (rest::rest'))
  | [x] ->
     RVar x
  | [] ->
     raise (Failure "ors")

let rec ands (l: wff list): wff =
  match l with
  | first::rest::rest' ->
     And (first, ands (rest::rest'))
  | [x] ->
     x
  | [] ->
     raise (Failure "ands")

let dep (p: var) (deps: var list): rwff =
  Impl (RVar p, ors deps)

let notboth (a: var) (b: var): rwff =
  RNot (RAnd (RVar a, RVar b))

let formulas: rwff list = [
    RVar "A1";
    dep "A1" ["B2"; "B3"];
    dep "A1" ["G3"];
    dep "B1" ["D1"];
    dep "B2" ["D2"];
    dep "B3" ["D2"; "D3"];
    dep "G1" ["D1"];
    dep "G2" ["D2"];
    dep "G3" ["D3"];
    notboth "B1" "B2";
    notboth "B2" "B3";
    notboth "B3" "B1";
    notboth "D1" "D2";
    notboth "D2" "D3";
    notboth "D3" "D1";
    notboth "G1" "G2";
    notboth "G2" "G3";
    notboth "G3" "G1";
  ]

let a: wff list = List.map minimize formulas
let b: wff = ands a
let _ = test'' b

let _ = 10;
