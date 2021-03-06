-- Copyright (c) 2016-present, Facebook, Inc.
-- All rights reserved.
--
-- This source code is licensed under the BSD-style license found in the
-- LICENSE file in the root directory of this source tree. An additional grant
-- of patent rights can be found in the PATENTS file in the same directory.


{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilies #-}

module Duckling.Resolve
  ( Context(..)
  , DucklingTime(..)
  , Resolve(..)
  , fromUTC
  , fromZonedTime
  , toUTC
  ) where

import Data.Aeson
import Data.String
import qualified Data.Time as Time
import qualified Data.Time.LocalTime.TimeZone.Series as Series
import Prelude

import Duckling.Lang

-- | Internal time reference.
-- We work as if we were in UTC time and use `ZoneSeriesTime` to house the info.
-- We convert to local time at resolution, using `fromUTC`.
newtype DucklingTime = DucklingTime Series.ZoneSeriesTime
  deriving (Eq, Show)

data Context = Context
  { referenceTime :: DucklingTime
  , lang :: Lang
  }
  deriving (Eq, Show)

class ToJSON (ResolvedValue a) => Resolve a where
  type ResolvedValue a
  resolve :: Context -> a -> Maybe (ResolvedValue a)

fromZonedTime :: Time.ZonedTime -> DucklingTime
fromZonedTime (Time.ZonedTime localTime timeZone) = DucklingTime $
  Series.ZoneSeriesTime (toUTC localTime) (Series.TimeZoneSeries timeZone [])

-- | Given a UTCTime and an TimeZone, build a ZonedTime (no conversion)
fromUTC :: Time.UTCTime -> Time.TimeZone -> Time.ZonedTime
fromUTC (Time.UTCTime day diffTime) timeZone = Time.ZonedTime localTime timeZone
  where
    localTime = Time.LocalTime day timeOfDay
    timeOfDay = Time.timeToTimeOfDay diffTime

-- | Given a LocalTime, build a UTCTime (no conversion)
toUTC :: Time.LocalTime -> Time.UTCTime
toUTC (Time.LocalTime day timeOfDay) = Time.UTCTime day diffTime
  where
    diffTime = Time.timeOfDayToTime timeOfDay
