module Main

import Control.Monad.Error.Interface
import Control.Monad.Error.Either
import Data.String
import Handler
import Handler.Combinators

orThrow : MonadError e m => Maybe a -> e -> m a
orThrow m e = case m of
  Just a  => pure a
  Nothing => throwError e

exampleRunWithFoldlM : Step String String -> IO ()
exampleRunWithFoldlM initialStep = do
  putStrLn "\nfoldlM\n"

  let collection = [ hConstRequest "init"
                   , hMapRequest (<+> "-req")
                   , hEcho
                   , hMapResponse (<+> "-res")
                   ] 
  result <- foldlM (flip ($)) initialStep collection

  putStrLn result.response.body

data Error = ParseError String

parseIntegerM : MonadError Error m => String -> m Int
parseIntegerM s = parseInteger s `orThrow` ParseError ("Could not parse as int: " <+> s)

exampleErrorHandling : Step String String -> IO ()
exampleErrorHandling initialStep = do
  putStrLn $ "\nErrors: " <+> initialStep.request.body <+> "\n"

  let handler = hParseRequest parseIntegerM >=> hEcho {m = EitherT Error IO}
  result <- runEitherT $ handler initialStep

  case result of
    Left  (ParseError e) => putStrLn e
    Right a => putStrLn $ show a.response.body

main : IO ()
main = do
  let req = MkRequest "request"
      res = MkResponse OK ""
      step = MkStep req res

  exampleRunWithFoldlM step
  exampleErrorHandling step
  exampleErrorHandling $ MkStep (MkRequest "134") res

