module nat where
import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl)
open Eq.≡-Reasoning using (begin_; step-≡-∣; _∎)

data ℕ : Set where
  zero : ℕ
  succ : ℕ → ℕ

one : ℕ
one = succ zero

two : ℕ
two = succ one
