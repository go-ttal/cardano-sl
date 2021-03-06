module Cardano.Wallet.API.V1.Swagger.Example where

import           Universum

import           Cardano.Wallet.API.Response
import           Cardano.Wallet.API.V1.Types

import           Pos.Client.Txp.Util (InputSelectionPolicy (..))
import qualified Pos.Core.Common as Core
import qualified Pos.Crypto.Signing as Core
import           Pos.Util.BackupPhrase (BackupPhrase)

import           Test.QuickCheck (Arbitrary (..), Gen, listOf1)

class Arbitrary a => Example a where
    example :: Gen a
    example = arbitrary

instance Example ()
instance Example a => Example (NonEmpty a)

-- NOTE: we don't want to see empty list examples in our swagger doc :)
instance Example a => Example [a] where
    example = listOf1 example

-- NOTE: we don't want to see "null" examples in our swagger doc :)
instance Example a => Example (Maybe a) where
    example = Just <$> example

instance Example Core.PassPhrase
instance Example Core.Coin

instance Example a => Example (WalletResponse a) where
    example = WalletResponse <$> example
                             <*> pure SuccessStatus
                             <*> example

instance Example Address
instance Example Metadata
instance Example AccountId
instance Example WalletId
instance Example BackupPhrase
instance Example AssuranceLevel
instance Example SyncProgress
instance Example BlockchainHeight
instance Example LocalTimeDifference
instance Example PaymentDistribution
instance Example AccountUpdate
instance Example Wallet
instance Example WalletUpdate
instance Example PasswordUpdate
instance Example EstimatedFees
instance Example Transaction
instance Example WalletSoftwareUpdate
instance Example NodeSettings
instance Example SlotDuration
instance Example WalletAddress
instance Example NewAccount
instance Example AddressValidity
instance Example NewAddress

instance Example InputSelectionPolicy where
    example = pure OptimizeForHighThroughput

instance Example TransactionGroupingPolicy where
    example = pure OptimiseForHighThroughputPolicy

instance Example Account where
    example = Account <$> example
                      <*> example -- NOTE: this will produce non empty list
                      <*> example
                      <*> pure "My account"
                      <*> example

instance Example NewWallet where
    example = NewWallet <$> example
                        <*> example -- Note: will produce `Just a`
                        <*> example
                        <*> pure "My Wallet"

instance Example NodeInfo where
    example = NodeInfo <$> example
                       <*> example  -- NOTE: will produce `Just a`
                       <*> example
                       <*> example

instance Example Payment where
    example = Payment <$> example
                      <*> example
                      <*> example
                      <*> example -- TODO: will produce `Just groupingPolicy`
                      <*> example

-- IMPORTANT: if executing `grep "[]\|null" wallet-new/spec/swagger.json` returns any element - then we have to add Example instances for those objects because we don't want to see [] or null examples in our docs.
--
-- TODO: We should probably add this as a part of our swagger CI script and fail swagger if we find some of them - with instruction to the developer above what is said above.
--
-- Most of it comes to removing Nothing from `Arbitrary (Maybe a)` instance and removing empty list from `Arbitrary [a]` instance. It could be done automatically with some quickcheck hacks but I think it would be an overkill.
