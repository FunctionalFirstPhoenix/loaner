module Domain exposing (..)

import Date exposing (Date)


type alias Person =
    { firstName : FirstName, lastName : LastName }


type alias FirstName =
    String


type alias LastName =
    String


type alias Account =
    { owner : Person
    , balance : Amount
    , accountType : AccountType
    , status : AccountStatus
    }


type AccountStatus
    = Active Date
    | Closed Date
    | Suspended Date SuspensionReason


type SuspensionReason
    = PastDue
    | RulesViolation
    | Voluntary


type AccountType
    = Normal
    | Gold
    | Platinum



-- data UnpaidMembership = UnpaidMembership
--   { people :: Array Person
--   , product :: Product
--   , amount :: Amount
--   }
-- data PaidMembership = PaidMembership
--   { people :: Array Person
--   , product :: Product
--   }
-- data Product = Camping Amount | Hotel Amount | Golf Amount
-- -- data Purchase = Purchase
-- --   { membership :: Membership
-- --   , quantity :: Quantity
-- --   , transactions :: Array Transaction
-- --   }
-- data Transaction = Transaction
--   { payment :: Payment
--   , product :: Product
--   }
-- data Payment = Payment
--   { paymentSource :: PaymentSource
--   , amount :: Amount
--   }
-- data PaymentSource
--   = CreditCard CcNumber
--   | Discount


type alias Amount =
    Int



-- -- type Time
-- type Price = Int
-- type Quantity = Int
-- type CcNumber = String
--
-- purchase :: Array Person -> Product -> UnpaidMembership
-- purchase people product =
--   let
--     amount = case product of
--       Camping a -> a
--       Hotel a -> a
--       Golf a -> a
--   in
--     UnpaidMembership
--       { people
--       , product
--       , amount
--       }
--
-- --pay :: Array Transaction -> UnpaidMembership -> Either FailureReason PaidMembership
