module TyTTP.HTTP

import Data.List
import public TyTTP

public export
data Method
  = OPTIONS
  | GET
  | HEAD
  | POST
  | PUT
  | DELETE
  | TRACE
  | CONNECT
  | OtherMethod String

export
Eq Method where
  (==) OPTIONS OPTIONS = True
  (==) GET     GET = True
  (==) HEAD    HEAD = True
  (==) POST    POST = True
  (==) PUT     PUT = True
  (==) DELETE  DELETE = True
  (==) TRACE   TRACE = True
  (==) CONNECT CONNECT = True
  (==) (OtherMethod a) (OtherMethod b) = a == b
  (==) _ _ = False

export
Show Method where
  show m = case m of
    OPTIONS => "OPTIONS" 
    GET => "GET" 
    HEAD => "HEAD" 
    POST => "POST" 
    PUT => "PUT" 
    DELETE => "DELETE" 
    TRACE => "TRACE" 
    CONNECT => "CONNECT" 
    OtherMethod str => str


export
parseMethod : String -> Method
parseMethod str = case str of
  "OPTIONS" => OPTIONS
  "GET" => GET
  "HEAD" => HEAD
  "POST" => POST
  "PUT" => PUT
  "DELETE" => DELETE
  "TRACE" => TRACE
  "CONNECT" => CONNECT
  s => OtherMethod s

public export
data Version
  = Version_1_0
  | Version_1_1
  | Version_2
  | OtherVersion String

export
Eq Version where
  (==) Version_1_0 Version_1_0 = True
  (==) Version_1_1 Version_1_1 = True
  (==) Version_2 Version_2 = True
  (==) (OtherVersion v1) (OtherVersion v2) = v1 == v2
  (==) _ _ = False

export
Show Version where
  show v = case v of
    Version_1_0 => "1.0"
    Version_1_1 => "1.1"
    Version_2 => "2.0"
    OtherVersion v => v

export
parseVersion : String -> Version
parseVersion s = case s of
  "1.0" => Version_1_0
  "1.1" => Version_1_1
  "2.0" => Version_2
  v => OtherVersion v

public export
StringHeaders : Type
StringHeaders = List (String, String)

public export
interface HasContentType a where
  getContentType : a -> Maybe String

export
implementation HasContentType StringHeaders where
  getContentType headers = lookup "content-type" headers


public export
HttpRequest : Type -> Type -> Type -> Type
HttpRequest p h a = Request Method p Version h a

export
mkRequest : (m : Method) -> p -> Version -> h -> a -> HttpRequest p h a
mkRequest m p v h a = MkRequest m p v h a

public export
data Status
  = CONTINUE
  | SWITCHING_PROTOCOLS
  | PROCESSING
  | EARLY_HINTS
  | OK
  | CREATED
  | ACCEPTED
  | NON_AUTHORITATIVE_INFORMATION
  | NO_CONTENT
  | RESET_CONTENT
  | PARTIAL_CONTENT
  | MULTI_STATUS
  | ALREADY_REPORTED
  | IM_USED
  | MULTIPLE_CHOICES
  | MOVED_PERMANENTLY
  | FOUND
  | SEE_OTHER
  | NOT_MODIFIED
  | USE_PROXY
  | TEMPORARY_REDIRECT
  | PERMANENT_REDIRECT
  | BAD_REQUEST
  | UNAUTHORIZED
  | PAYMENT_REQUIRED
  | FORBIDDEN
  | NOT_FOUND
  | METHOD_NOT_ALLOWED
  | NOT_ACCEPTABLE
  | PROXY_AUTHENTICATION_REQUIRED
  | REQUEST_TIMEOUT
  | CONFLICT
  | GONE
  | LENGTH_REQUIRED
  | PRECONDITION_FAILED
  | PAYLOAD_TOO_LARGE
  | URI_TOO_LONG
  | UNSUPPORTED_MEDIA_TYPE
  | RANGE_NOT_SATISFIABLE
  | EXPECTATION_FAILED
  | TEAPOT
  | MISDIRECTED_REQUEST
  | UNPROCESSABLE_ENTITY
  | LOCKED
  | FAILED_DEPENDENCY
  | TOO_EARLY
  | UPGRADE_REQUIRED
  | PRECONDITION_REQUIRED
  | TOO_MANY_REQUESTS
  | REQUEST_HEADER_FIELDS_TOO_LARGE
  | UNAVAILABLE_FOR_LEGAL_REASONS
  | INTERNAL_SERVER_ERROR
  | NOT_IMPLEMENTED
  | BAD_GATEWAY
  | SERVICE_UNAVAILABLE
  | GATEWAY_TIMEOUT
  | HTTP_VERSION_NOT_SUPPORTED
  | VARIANT_ALSO_NEGOTIATES
  | INSUFFICIENT_STORAGE
  | LOOP_DETECTED
  | BANDWIDTH_LIMIT_EXCEEDED
  | NOT_EXTENDED
  | NETWORK_AUTHENTICATION_REQUIRED

export
(.code) : Status -> Int
(.code) status = case status of
  CONTINUE => 100
  SWITCHING_PROTOCOLS => 101
  PROCESSING => 102
  EARLY_HINTS => 103
  OK => 200
  CREATED => 201
  ACCEPTED => 202
  NON_AUTHORITATIVE_INFORMATION => 203
  NO_CONTENT => 204
  RESET_CONTENT => 205
  PARTIAL_CONTENT => 206
  MULTI_STATUS => 207
  ALREADY_REPORTED => 208
  IM_USED => 226
  MULTIPLE_CHOICES => 300
  MOVED_PERMANENTLY => 301
  FOUND => 302
  SEE_OTHER => 303
  NOT_MODIFIED => 304
  USE_PROXY => 305
  TEMPORARY_REDIRECT => 307
  PERMANENT_REDIRECT => 308
  BAD_REQUEST => 400
  UNAUTHORIZED => 401
  PAYMENT_REQUIRED => 402
  FORBIDDEN => 403
  NOT_FOUND => 404
  METHOD_NOT_ALLOWED => 405
  NOT_ACCEPTABLE => 406
  PROXY_AUTHENTICATION_REQUIRED => 407
  REQUEST_TIMEOUT => 408
  CONFLICT => 409
  GONE => 410
  LENGTH_REQUIRED => 411
  PRECONDITION_FAILED => 412
  PAYLOAD_TOO_LARGE => 413
  URI_TOO_LONG => 414
  UNSUPPORTED_MEDIA_TYPE => 415
  RANGE_NOT_SATISFIABLE => 416
  EXPECTATION_FAILED => 417
  TEAPOT => 418
  MISDIRECTED_REQUEST => 421
  UNPROCESSABLE_ENTITY => 422
  LOCKED => 423
  FAILED_DEPENDENCY => 424
  TOO_EARLY => 425
  UPGRADE_REQUIRED => 426
  PRECONDITION_REQUIRED => 428
  TOO_MANY_REQUESTS => 429
  REQUEST_HEADER_FIELDS_TOO_LARGE => 431
  UNAVAILABLE_FOR_LEGAL_REASONS => 451
  INTERNAL_SERVER_ERROR => 500
  NOT_IMPLEMENTED => 501
  BAD_GATEWAY => 502
  SERVICE_UNAVAILABLE => 503
  GATEWAY_TIMEOUT => 504
  HTTP_VERSION_NOT_SUPPORTED => 505
  VARIANT_ALSO_NEGOTIATES => 506
  INSUFFICIENT_STORAGE => 507
  LOOP_DETECTED => 508
  BANDWIDTH_LIMIT_EXCEEDED => 509
  NOT_EXTENDED => 510
  NETWORK_AUTHENTICATION_REQUIRED => 511

