module Main

import Data.Buffer
import Data.Buffer.Ext
import Data.IORef
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


import Node.HTTP2.Client
import Node.Headers
import Node

main : IO ()
main = do
  http2 <- HTTP2.require
  server <- HTTP2.listen' $ \push =>
      routes' (text "Resource could not be found" >=> status NOT_FOUND)
        [ get $ Path.path "/query" $ \step =>
            text step.request.url.search step >>= status OK
        , get $ path "/parsed" $ Simple.search $ \step =>
            text (show step.request.url.search) step >>= status OK
        , get $ Path.path "/push" $ \step => lift $ do
            push $ MkContext
              { request = MkRequest
                { method = GET
                , url = MkURL (Just HTTP) (Just "localhost:3000") "/pushed.txt" ""
                , version = Version_2
                , headers = []
                , body = ()
                }
              , response = MkResponse
                { status = OK
                , headers = [ ("content-type", "text/plain") ]
                , body = singleton "this is pushed"
                }
              }
            text "this is the response" step >>= status OK
        ]

  defer $ do
    session <- http2.connect "http://localhost:3000"

    counter <- newIORef 1
    let closer = do
      modifyIORef counter (\x => x-1)
      count <- readIORef counter
      putStrLn "\nclose counter is at \{show count}"
      when (count <= 0) $ do
        putStrLn "closing session and server"
        session.close
        server.close

    session.onStream $ \stream, headers => do
      stream.onPush $ \headers => debugJsValue headers
      putStrLn "PUSH"
      debugJsValue headers
      onData stream putStr
      onEnd stream closer

    stream <- session.get "/push" =<< empty
    stream.onResponse $ \headers => do
      putStrLn "GET"
      onData stream putStr
      onEnd stream closer

    stream.end
