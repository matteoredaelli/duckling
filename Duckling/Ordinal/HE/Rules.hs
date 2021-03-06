-- Copyright (c) 2016-present, Facebook, Inc.
-- All rights reserved.
--
-- This source code is licensed under the BSD-style license found in the
-- LICENSE file in the root directory of this source tree. An additional grant
-- of patent rights can be found in the PATENTS file in the same directory.

{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}

module Duckling.Ordinal.HE.Rules
  ( rules ) where

import Data.Maybe
import Data.String
import Data.Text (Text)
import Prelude
import qualified Data.Text as Text

import Duckling.Dimensions.Types
import Duckling.Numeral.Helpers (parseInt)
import Duckling.Ordinal.Helpers
import Duckling.Ordinal.Types (OrdinalData (..))
import Duckling.Regex.Types
import Duckling.Types
import qualified Duckling.Ordinal.Types as TOrdinal

ruleOrdinal4 :: Rule
ruleOrdinal4 = Rule
  { name = "ordinal 4"
  , pattern =
    [ regex "(\x05d0\x05e8\x05d1\x05e2\x05d4|\x05e8\x05d1\x05d9\x05e2\x05d9)"
    ]
  , prod = \_ -> Just $ ordinal 4
  }

ruleOrdinal9 :: Rule
ruleOrdinal9 = Rule
  { name = "ordinal 9"
  , pattern =
    [ regex "(\x05ea\x05e9\x05e2\x05d4|\x05ea\x05e9\x05d9\x05e2\x05d9)"
    ]
  , prod = \_ -> Just $ ordinal 9
  }

ruleOrdinal10 :: Rule
ruleOrdinal10 = Rule
  { name = "ordinal 10"
  , pattern =
    [ regex "(\x05e2\x05e9\x05e8\x05d4|\x05e2\x05e9\x05d9\x05e8\x05d9)"
    ]
  , prod = \_ -> Just $ ordinal 10
  }

ruleOrdinal12 :: Rule
ruleOrdinal12 = Rule
  { name = "ordinal 12"
  , pattern =
    [ regex "(\x05e9\x05e0\x05d9\x05d9\x05dd \x05e2\x05e9\x05e8|\x05ea\x05e8\x05d9 \x05e2\x05e9\x05e8)"
    ]
  , prod = \_ -> Just $ ordinal 12
  }

ruleOrdinal17 :: Rule
ruleOrdinal17 = Rule
  { name = "ordinal 17"
  , pattern =
    [ regex "(\x05e9\x05d1\x05e2(\x05d4)? \x05e2\x05e9\x05e8(\x05d4)?)"
    ]
  , prod = \_ -> Just $ ordinal 17
  }

ruleOrdinal18 :: Rule
ruleOrdinal18 = Rule
  { name = "ordinal 18"
  , pattern =
    [ regex "(\x05e9\x05de\x05d5\x05e0\x05d4 \x05e2\x05e9\x05e8(\x05d4)?)"
    ]
  , prod = \_ -> Just $ ordinal 18
  }

ruleOrdinalDigits :: Rule
ruleOrdinalDigits = Rule
  { name = "ordinal (digits)"
  , pattern =
    [ regex "0*(\\d+) "
    ]
  , prod = \tokens -> case tokens of
      (Token RegexMatch (GroupMatch (match:_)):_) -> ordinal <$> parseInt match
      _ -> Nothing
  }

ruleOrdinal15 :: Rule
ruleOrdinal15 = Rule
  { name = "ordinal 15"
  , pattern =
    [ regex "(\x05d7\x05de\x05d9\x05e9\x05d4 \x05e2\x05e9\x05e8|\x05d7\x05de\x05e9 \x05e2\x05e9\x05e8\x05d4?)"
    ]
  , prod = \_ -> Just $ ordinal 15
  }

ruleOrdinal5 :: Rule
ruleOrdinal5 = Rule
  { name = "ordinal 5"
  , pattern =
    [ regex "(\x05d7\x05de\x05d9\x05e9\x05d9|\x05d7\x05de\x05d9\x05e9\x05d4)"
    ]
  , prod = \_ -> Just $ ordinal 5
  }

ruleOrdinal16 :: Rule
ruleOrdinal16 = Rule
  { name = "ordinal 16"
  , pattern =
    [ regex "(\x05e9\x05e9(\x05d4)? \x05e2\x05e9\x05e8(\x05d4)?)"
    ]
  , prod = \_ -> Just $ ordinal 16
  }

ruleOrdinal14 :: Rule
ruleOrdinal14 = Rule
  { name = "ordinal 14"
  , pattern =
    [ regex "(\x05d0\x05e8\x05d1\x05e2(\x05d4)? \x05e2\x05e9\x05e8(\x05d4)?)"
    ]
  , prod = \_ -> Just $ ordinal 14
  }

ruleOrdinal20 :: Rule
ruleOrdinal20 = Rule
  { name = "ordinal 20..90"
  , pattern =
    [ regex "(\x05e2\x05e9\x05e8\x05d9\x05dd|\x05e9\x05dc\x05d5\x05e9\x05d9\x05dd|\x05d0\x05e8\x05d1\x05e2\x05d9\x05dd|\x05d7\x05de\x05d9\x05e9\x05d9\x05dd|\x05e9\x05d9\x05e9\x05d9\x05dd|\x05e9\x05d1\x05e2\x05d9\x05dd|\x05e9\x05de\x05d5\x05e0\x05d9\x05dd|\x05ea\x05e9\x05e2\x05d9\x05dd)"
    ]
  , prod = \tokens -> case tokens of
      (Token RegexMatch (GroupMatch (match:_)):_) -> case match of
        "\x05e2\x05e9\x05e8\x05d9\x05dd" -> Just $ ordinal 20
        "\x05e9\x05dc\x05d5\x05e9\x05d9\x05dd" -> Just $ ordinal 30
        "\x05d0\x05e8\x05d1\x05e2\x05d9\x05dd" -> Just $ ordinal 40
        "\x05d7\x05de\x05d9\x05e9\x05d9\x05dd" -> Just $ ordinal 50
        "\x05e9\x05d9\x05e9\x05d9\x05dd" -> Just $ ordinal 60
        "\x05e9\x05d1\x05e2\x05d9\x05dd" -> Just $ ordinal 70
        "\x05e9\x05de\x05d5\x05e0\x05d9\x05dd" -> Just $ ordinal 80
        "\x05ea\x05e9\x05e2\x05d9\x05dd" -> Just $ ordinal 90
        _ -> Nothing
      _ -> Nothing
  }

ruleOrdinal :: Rule
ruleOrdinal = Rule
  { name = "ordinal 1"
  , pattern =
    [ regex "(\x05d0\x05d7\x05d3|\x05e8\x05d0\x05e9\x05d5\x05df)"
    ]
  , prod = \_ -> Just $ ordinal 1
  }

ruleOrdinal13 :: Rule
ruleOrdinal13 = Rule
  { name = "ordinal 13"
  , pattern =
    [ regex "(\x05e9\x05dc\x05d5\x05e9(\x05d4)? \x05e2\x05e9\x05e8(\x05d4)?)"
    ]
  , prod = \_ -> Just $ ordinal 13
  }

ruleOrdinal7 :: Rule
ruleOrdinal7 = Rule
  { name = "ordinal 7"
  , pattern =
    [ regex "(\x05e9\x05d1\x05e2\x05d4|\x05e9\x05d1\x05d9\x05e2\x05d9)"
    ]
  , prod = \_ -> Just $ ordinal 7
  }

ruleOrdinal8 :: Rule
ruleOrdinal8 = Rule
  { name = "ordinal 8"
  , pattern =
    [ regex "(\x05e9\x05de\x05d5\x05e0\x05d4|\x05e9\x05de\x05d9\x05e0\x05d9)"
    ]
  , prod = \_ -> Just $ ordinal 8
  }

ruleOrdinal2 :: Rule
ruleOrdinal2 = Rule
  { name = "ordinal 2"
  , pattern =
    [ regex "(\x05e9\x05ea\x05d9\x05d9\x05dd|\x05e9\x05e0\x05d9\x05d9\x05dd|\x05e9\x05e0\x05d9)"
    ]
  , prod = \_ -> Just $ ordinal 2
  }

ruleOrdinal11 :: Rule
ruleOrdinal11 = Rule
  { name = "ordinal 11"
  , pattern =
    [ regex "(\x05d0\x05d7\x05d3 \x05e2\x05e9\x05e8(\x05d4)?)"
    ]
  , prod = \_ -> Just $ ordinal 11
  }

ruleOrdinal3 :: Rule
ruleOrdinal3 = Rule
  { name = "ordinal 3"
  , pattern =
    [ regex "(\x05e9\x05dc\x05d5\x05e9\x05d4|\x05e9\x05dc\x05d9\x05e9\x05d9)"
    ]
  , prod = \_ -> Just $ ordinal 3
  }

ruleOrdinal6 :: Rule
ruleOrdinal6 = Rule
  { name = "ordinal 6"
  , pattern =
    [ regex "(\x05e9\x05e9\x05d4|\x05e9\x05d9\x05e9\x05d9)"
    ]
  , prod = \_ -> Just $ ordinal 6
  }

ruleOrdinal19 :: Rule
ruleOrdinal19 = Rule
  { name = "ordinal 19"
  , pattern =
    [ regex "(\x05ea\x05e9\x05e2(\x05d4)? \x05e2\x05e9\x05e8(\x05d4)?)"
    ]
  , prod = \_ -> Just $ ordinal 19
  }

ruleCompositeWithAnd :: Rule
ruleCompositeWithAnd = Rule
  { name = "ordinal composition (with and)"
  , pattern =
    [ dimension Ordinal
    , regex "\x05d5"
    , dimension Ordinal
    ]
  , prod = \tokens -> case tokens of
      (Token Ordinal (OrdinalData {TOrdinal.value = v1}):
       _:
       Token Ordinal (OrdinalData {TOrdinal.value = v2}):
       _) -> Just . ordinal $ v1 + v2
      _ -> Nothing
  }

rules :: [Rule]
rules =
  [ ruleCompositeWithAnd
  , ruleOrdinal
  , ruleOrdinal10
  , ruleOrdinal11
  , ruleOrdinal12
  , ruleOrdinal13
  , ruleOrdinal14
  , ruleOrdinal15
  , ruleOrdinal16
  , ruleOrdinal17
  , ruleOrdinal18
  , ruleOrdinal19
  , ruleOrdinal2
  , ruleOrdinal20
  , ruleOrdinal3
  , ruleOrdinal4
  , ruleOrdinal5
  , ruleOrdinal6
  , ruleOrdinal7
  , ruleOrdinal8
  , ruleOrdinal9
  , ruleOrdinalDigits
  ]
