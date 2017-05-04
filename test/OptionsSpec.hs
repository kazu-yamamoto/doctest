module OptionsSpec (spec) where

import           Test.Hspec
import           Test.QuickCheck

import           Options

spec :: Spec
spec = do
  describe "parseOptions" $ do
    let warning = ["WARNING: --optghc is deprecated, doctest now accepts arbitrary GHC options\ndirectly."]
    it "strips --optghc" $
      property $ \xs ys ->
        parseOptions (xs ++ ["--optghc", "foobar"] ++ ys) `shouldBe` Result (Run warning (xs ++ ["foobar"] ++ ys))

    it "strips --optghc=" $
      property $ \xs ys ->
        parseOptions (xs ++ ["--optghc=foobar"] ++ ys) `shouldBe` Result (Run warning (xs ++ ["foobar"] ++ ys))

    context "with --help" $ do
      it "outputs usage information" $ do
        parseOptions ["--help"] `shouldBe` Output usage

    context "with --version" $ do
      it "outputs version information" $ do
        parseOptions ["--version"] `shouldBe` Output versionInfo