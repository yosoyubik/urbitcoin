::  btc-node-hook: send JSON rpc requests to bitcoin full node
::  and poke the responses into the btc-node-store
::
/-  *btc-node-hook, *btc-node-store
/+  *btc-node-json
|%
+$  move  [bone card]
+$  card
  $%  [%request wire request:http outbound-config:iris]
      :: [%hiss wire ~ mark %hiss hiss:eyre]
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
  ::  TODO: send a JSON rpc request based on the action
  :: =/  req=request:http
  ::   [%'POST' endpoint headers *(unit octs)]
  :: =/  out  *outbound-config:iris

  :: [ost.bol %request /[(scot %da now.bol)] req out]~
  =/  body=request:rpc:jstd
    :*  ::jsonrpc='1.0'
        id='curltext'
        method='getblockchaininfo'
        params=[%object ~]
    ==
  =/  req=request:http
    :*  %'POST'
        endpoint
        headers
        %-  some
          %-  as-octt:mimes:html
          (en-json:html (request-to-json:rpc:jstd body))
    ==
  =/  out  *outbound-config:iris
  :: =/  hiss=hiss:eyre
  ::   (request-to-hiss:rpc:jstd endpoint req)
  :: =/  auth=[@t (list @t)]
  ::   'Authorization'^['Basic dXJiaXRjb2luZXI6dXJiaXRjb2luZXI=']~
  :: =.  hiss  hiss(q (~(put in q.hiss) auth))
  ~&  req+req
  :: ~&  (~(put in q.hiss) auth)
  :_  this
  [ost.bol %request /[(scot %da now.bol)] req out]~
  :: :_  ~
  :: :-  ost.bol
  :: ^-  card
  :: :*  %hiss
  ::     /[(scot %da now.bol)]
  ::     ~
  ::     %json-rpc-response
  ::     %hiss
  ::     hiss(q.q (~(put in q.q.hiss) auth))
  ::     :: ^-(hiss:eyre [p.hiss [p.q.hiss (~(put in q.q.hiss) auth) r.q.hiss]])
  :: ==
  :: ~
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
