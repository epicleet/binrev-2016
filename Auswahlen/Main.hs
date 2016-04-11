{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Lazy.Char8 as C
import Control.Concurrent
import Control.Monad
import System.Time.Monotonic
import Data.Time.Clock
import Data.Digest.Pure.SHA
import Data.List
import Data.Bits
import Data.Char
import Flow

instants :: [DiffTime]
instants = [    534,   1167,  32842,  35504,  41825,  48903,  51177,  55530,
              65357,  68354,  79598,  79645,  79937,  81324,  82974,  85776,
              90556, 101589, 102417, 116823, 143318, 144330, 145142, 149661,
             169760, 186519, 189223, 193281, 212382, 212630, 216456, 217445,
             225601, 237527, 241956, 255747, 257270, 257612 ]

key :: BL.ByteString
key = "rA0InNdaDJR65H28IBr6yqVHVaJi4lYF"

starcrossThread :: Clock -> [DiffTime] -> IO ()
starcrossThread clock [] = return ()
starcrossThread clock (nextInstant : instants) = do
    curTime <- clockGetTime clock
    threadDelay <| round <| 1000000 * (nextInstant - curTime)
    putStrLn "*"
    starcrossThread clock instants

waitInputGetTime :: Clock -> IO DiffTime
waitInputGetTime clock = do
    getLine
    clockGetTime clock

getUserInstants :: Clock -> IO [Integer]
getUserInstants clock = map floor <$>
    replicateM (length instants) (waitInputGetTime clock)

codify :: [Integer] -> [Integer]
codify list =
    scanl' (\(lastInt, lastBS) elem ->
            let h = hmacSha256 lastBS <| C.pack <| show elem
            in (integerDigest h, bytestringDigest h))
       (0, key) list
    |> tail |> map fst

showCoded :: [Integer] -> IO ()
showCoded instants =
    (codify <| instants)
        |> map (\inst -> chr <| fromInteger <| inst .&. 0x7F)
        |> putStrLn

{-
testInstants :: IO ()
testInstants =
    map (toRational .> floor) instants |> showCoded
-}

main :: IO ()
main = do
    clock <- newClock
    forkIO <| starcrossThread clock instants
    userInstants <- getUserInstants clock
    showCoded userInstants
