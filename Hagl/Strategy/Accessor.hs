{-# LANGUAGE MultiParamTypeClasses #-}

module Hagl.Strategy.Accessor where

import Control.Monad (liftM, liftM2)
import Data.List     (transpose)
import Data.Maybe    (fromMaybe)

import Hagl.Base

--------------------
-- Data Accessors --
--------------------

-- | The game being played.
game :: GameM m g => m g
game = liftM _game getExec

-- | The players playing.
players :: GameM m g => m (ByPlayer (Player g))
players = liftM _players getExec

-- | Current location in the game tree.
location :: GameM m g => m (GameTree (State g) (Move g))
location = liftM _location getExec

-- | Transcript of all moves so far.
transcript :: GameM m g => m (Transcript (Move g))
transcript = liftM _transcript getExec

-- | The number of moves each player has played.
numMoves :: GameM m g => m (ByPlayer Int)
numMoves = liftM _numMoves getExec

-- | The index of the currently active player.
myIx :: GameM m g => m PlayerIx
myIx = location >>= return . (fromMaybe e) . playerIx
  where e = error "Internal error: myIx on non-decision node!"

-- | The currently active player.
me :: GameM m g => m (Player g)
me = liftM2 forPlayer myIx players

-- | The number of players playing the game.
numPlayers :: GameM m g => m Int
numPlayers = liftM dlength players

-- | Summary of each player's moves so far.
moveSummary :: GameM m g => m (MoveSummary (Move g))
moveSummary = liftM2 summarize numPlayers transcript

-- | Same as !moveSummary but reads better in many strategies.
move:: GameM m g => m (MoveSummary (Move g))
move = moveSummary