module Main where

-- In this context, a function maps a real to a real.
type Function = Double -> Double

-- An integration interval
data Interval = Interval (Double, Double)

-- The number of partitions to divide the interval onto.
type Partitions = Int

-- An integration method
data IntegrationMethod = LeftRectangular
                       | RightRectangular
                       | MidpointRectangular

integrate :: Function -> IntegrationMethod -> Interval -> Partitions -> Double
integrate f m i p =
  let partitions = partition i p in
    sum (map integratePartition partitions)
    where
      partitions :: [Interval]
      partitions = partition i p

      integratePartition :: Interval -> Double
      integratePartition i =
        integrateInterval f m i

integrateInterval :: Function -> IntegrationMethod -> Interval -> Double
integrateInterval f LeftRectangular (Interval (a, b)) =
  f(a) * length
  where
    length = b - a
integrateInterval f RightRectangular (Interval (a, b)) =
  f(b) * length
  where
    length = b - a
integrateInterval f MidpointRectangular (Interval (a, b)) =
  f(midpoint) * length
  where
    midpoint = (a + b) / 2
    length = b - a


-- Utility functions

-- Given a closed interval [a,b], and a number of partitions, return a list of
-- intervals.
--
-- Constraints: n > 0
partition :: Interval -> Partitions -> [Interval]
partition (Interval (a, b)) n =
  map f [1..n]
  where
    f :: Int -> Interval
    f i = Interval (left i, right i)

    left :: Int -> Double
    left i = (fromIntegral (i-1)) * length

    right :: Int -> Double
    right i = (fromIntegral i)*length

    length :: Double
    length = (b-a) / (fromIntegral n)

-- Entrypoint

integrals :: [(Int, Double)]
integrals =
  [(n, integrate func method interval n) | n <- [1..1000]]
  where
    func = \x -> x*x
    method = LeftRectangular
    interval = Interval (0.0, 1.0)

display :: [(Int, Double)] -> String
display is =
  concat (map disp is)
  where
    disp (n, i) =
      (show n) ++ " => " ++ (show i) ++ "\n"

main :: IO ()
main = do
  putStrLn "Integral of f(x) = x^2, left rectangular:"
  putStrLn (display integrals)
