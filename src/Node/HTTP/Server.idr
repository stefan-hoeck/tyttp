module Node.HTTP.Server

import public Node.HTTP
import public Node.Headers

export
data IncomingMessage : Type where [external]

export
data ServerResponse : Type where [external]

namespace Request

  export
  %foreign "node:lambda: req => req.headers"
  (.headers) : IncomingMessage -> Headers

  export
  %foreign "node:lambda: req => req.httpVersion"
  (.httpVersion) : IncomingMessage -> String

  export
  %foreign "node:lambda: req => req.method"
  (.method) : IncomingMessage -> String

  export
  %foreign "node:lambda: req => req.url"
  (.url) : IncomingMessage -> String

  %foreign "node:lambda: (ty, req, data) => { req.on('data', a => data(a)()) }"
  ffi_onData : IncomingMessage -> (a -> PrimIO ()) -> PrimIO ()

  export
  (.onData) : HasIO io => IncomingMessage -> (a -> IO ()) -> io ()
  (.onData) req cb = primIO $ ffi_onData req $ \a => toPrim $ cb a

  %foreign "node:lambda: (req, end) => { req.on('end', () => end()()) }"
  ffi_onEnd : IncomingMessage -> (() -> PrimIO ()) -> PrimIO ()

  export
  (.onEnd) : HasIO io => IncomingMessage -> (() -> IO ()) -> io ()
  (.onEnd) req cb = primIO $ ffi_onEnd req $ \_ => toPrim $ cb ()

  %foreign "node:lambda: (ty, req, error) => { req.on('error', e => error(e)()) }"
  ffi_onError : IncomingMessage -> (e -> PrimIO ()) -> PrimIO ()

  export
  (.onError) : HasIO io => IncomingMessage -> (e -> IO ()) -> io ()
  (.onError) req cb = primIO $ ffi_onError req $ \e => toPrim $ cb e

namespace Response

  %foreign "node:lambda: res => res.end()"
  ffi_end : ServerResponse -> PrimIO ()

  export
  (.end) : HasIO io => ServerResponse -> io ()
  (.end) res = primIO $ ffi_end res

  %foreign "node:lambda: (ty, res, data) => res.write(data)"
  ffi_write : { 0 a : _ } -> ServerResponse -> a -> PrimIO ()

  export
  (.write) : HasIO io => ServerResponse -> a -> io ()
  (.write) res a = primIO $ ffi_write res a

  %foreign "node:lambda: (res, status, headers) => res.writeHead(status, headers)"
  ffi_writeHead : ServerResponse -> Int -> Headers -> PrimIO ()

  export
  (.writeHead) : HasIO io => ServerResponse -> Int -> Headers -> io ()
  (.writeHead) res status headers = primIO $ ffi_writeHead res status headers

export
data Server : Type where [external]

%foreign "node:lambda: http => http.createServer()"
ffi_createServer : HTTP -> PrimIO Server

export
(.createServer) : HasIO io => HTTP -> io Server
(.createServer) http = primIO $ ffi_createServer http

%foreign "node:lambda: (server, handler) => server.on('request', (req, res) => handler(req)(res)())"
ffi_onRequest : Server -> (IncomingMessage -> ServerResponse -> PrimIO ()) -> PrimIO ()

export
(.onRequest) : HasIO io => Server -> (IncomingMessage -> ServerResponse -> IO()) -> io ()
(.onRequest) server callback = 
  let primCallback = \req => \res => toPrim $ callback req res
  in primIO $ ffi_onRequest server primCallback

%foreign "node:lambda: (server, port) => server.listen(port)"
ffi_listen : Server -> Int -> PrimIO ()

export
(.listen) : HasIO io => Server -> Int -> io ()
(.listen) server port = primIO $ ffi_listen server port

%foreign "node:lambda: server => server.close()"
ffi_close : Server -> PrimIO ()

export
(.close) : HasIO io => Server -> io ()
(.close) server = primIO $ ffi_close server

