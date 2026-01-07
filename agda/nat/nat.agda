module nat where
import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl)
open Eq.≡-Reasoning using (begin_; step-≡-∣; _∎)

data ℕ : Set where
  zero : ℕ
  succ : ℕ → ℕ
{-# BUILTIN NATURAL ℕ #-}

_+_ : ℕ → ℕ → ℕ
0        + n = n
(succ m) + n = succ (m + n)

_ : 2 + 3 ≡ 5
_ =
  begin
    2 + 3
  ≡⟨⟩
    (succ (succ 0)) + (succ (succ (succ 0)))
  ≡⟨⟩
    succ ((succ 0) + (succ (succ (succ 0))))
  ≡⟨⟩
    succ (succ (0 + (succ (succ (succ 0)))))
  ≡⟨⟩
    succ (succ (succ (succ (succ 0))))
  ≡⟨⟩
    5
  ∎

_ : 2 + 3 ≡ 5
_ = refl

_*_ : ℕ → ℕ → ℕ
0        * n  =  0
(succ m) * n  =  n + (m * n)

_∸_ : ℕ → ℕ → ℕ
m      ∸ 0      = m
0      ∸ succ n = 0
succ m ∸ succ n = m ∸ n

_ : 5 ∸ 3 ≡ 2
_ =
  begin
    5 ∸ 3
  ≡⟨⟩
    4 ∸ 2
  ≡⟨⟩
    3 ∸ 1
  ≡⟨⟩
    2 ∸ 0
  ≡⟨⟩
    2
  ∎
