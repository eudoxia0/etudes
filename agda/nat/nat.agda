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

three : ℕ
three = succ two

five : ℕ
five = succ (succ (succ (succ (succ zero))))

_+_ : ℕ → ℕ → ℕ
zero     + n = n
(succ m) + n = succ (m + n)

_ : two + three ≡ five
_ =
  begin
    two + three
  ≡⟨⟩
    (succ (succ zero)) + (succ (succ (succ zero)))
  ≡⟨⟩
    succ ((succ zero) + (succ (succ (succ zero))))
  ≡⟨⟩
    succ (succ (zero + (succ (succ (succ zero)))))
  ≡⟨⟩
    succ (succ (succ (succ (succ zero))))
  ≡⟨⟩
    five
  ∎
