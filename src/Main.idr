module Main

import Data.Buffer
import Control.Monad.Trans
import Control.Monad.Either
import Control.Monad.Maybe
import Node.HTTP2.Server
import TyTTP.Adapter.Node.HTTP2
import TyTTP.Adapter.Node.URI
import TyTTP.HTTP
import TyTTP.HTTP.Consumer
import TyTTP.HTTP.Producer
import TyTTP.HTTP.Routing
import TyTTP.URL
import TyTTP.URL.Path
import TyTTP.URL.Search

main : IO ()
main = do
  http <- HTTP2.require
  ignore $ HTTP2.listen' {e = String} $
      routes' (text "Resource could not be found" >=> status NOT_FOUND)
        [ get $ path "/query" $ \step =>
            text step.request.url.search step >>= status OK
        , get $ path "/parsed" $ Simple.search $ \step =>
            text (show step.request.url.search) step >>= status OK
        ]
