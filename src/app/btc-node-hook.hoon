::  btc-node-hook: send JSON rpc requests to bitcoin full node
::  and poke the responses into the btc-node-store
::
/-  *btc-node-hook, *btc-node-store
/+  lib=btc-node-json
|%
+$  move  [bone card]
+$  card
  $%  [%request wire request:http outbound-config:iris]
      [%poke wire dock [%btc-node-store-action btc-node-store-action]]
  ==
::
+$  state
  $%  [%0 state-zero]
  ==
::
+$  state-zero
  $:  endpoint=@t
      headers=header-list:http
      params=json
  ==
--
::
|_  [bol=bowl:gall state]
::
++  this  .
::
++  prep
  |=  old=(unit state)
  ^-  (quip move _this)
  ?~  old
    :-  ~
    %=  this
      endpoint  'http://127.0.0.1:8332'
      headers
        :~  ['Accept' 'application/json']
            ['Content-Type' 'text/plain']
            ['Authorization' 'Basic dXJiaXRjb2luZXI6dXJiaXRjb2luZXI']
        ==
    ==
  [~ this(+<+ u.old)]
::
++  poke-noun
  |=  act=btc-node-hook-action
  ^-  (quip move _this)
  =/  body=request:rpc:jstd
    (request-to-rpc:btc-rpc:lib act)
  ~&  body
  =/  req=request:http
    :*  %'POST'
        endpoint
        headers
        %-  some
          %-  as-octt:mimes:html
          (en-json:html (request-to-json:rpc:jstd body))
    ==
  =/  out  *outbound-config:iris
  :_  this
  [ost.bol %request /[(scot %da now.bol)] req out]~
::
++  http-response
  |=  [=wire response=client-response:iris]
  ^-  (quip move _this)
  ::  ignore all but %finished
  ?.  ?=(%finished -.response)
    [~ this]
  :: TODO: decode the JSON-RPC response and poke the btc-node-store
  :: with the returned data
  ~&  response
  [~ this]
::
++  btc-node-store-poke
  |=  [pax=path act=btc-node-store-action]
  ^-  move
  [ost.bol %poke pax [our.bol %btc-node-store] [%btc-node-store-action act]]
::
--
