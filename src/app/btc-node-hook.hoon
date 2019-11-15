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
      :: wallet=@t
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
      ::  TODO: wallet should be part of the state.
      ::  few hook actions have a wallet name added for demo
      ::  purposes but it should be removed
      ::
      ::  wallet  'urbit-wallet'
      ::
      endpoint  'http://127.0.0.1:8332'
      headers
        :~  ['Accept' 'application/json']
            ['Content-Type' 'text/plain']
            ['Authorization' 'Basic dXJiaXRjb2luZXI6dXJiaXRjb2luZXI']
    ==  ==
  [~ this(+<+ u.old)]
::
++  poke-noun
  |=  act=btc-node-hook-action
  ^-  (quip move _this)
  =/  body=request:rpc:jstd
    (request-to-rpc:btc-rpc:lib act)
  =/  req=request:http
    :*  %'POST'
        ?+    -.act
          endpoint
        ::
            %get-balance
          ::  FIXME: fails when wallet.act is ''
          ::
          ::    url='http://127.0.0.1:8332/wallet/'
          ::
          ::  this example works with curl:
          ::
          ::
          :: curl --user XXX:YYY
          ::      --data-binary '{
          ::        "jsonrpc": "1.0",
          ::        "id":"curltest",
          ::        "method": "getwalletinfo",
          ::        "params": []
          ::      }'
          ::      -H 'content-type: text/plain;'
          ::      http://127.0.0.1:8332/wallet/
          ::
          (crip "{(trip endpoint)}/wallet/{(trip wallet.act)}")
        ::
            %get-wallet-info
          ::  FIXME: fails when name.act is ''
          ::
          (crip "{(trip endpoint)}/wallet/{(trip name.act)}")
        ::
        ::  TODO: add rest of wallet-related actions
        ::  that might require a /wallet/<file_name>
        ::
            %get-address-info
          ::  FIXME: fails when name.act is ''
          ::
          (crip "{(trip endpoint)}/wallet/{(trip wallet.act)}")
        ==
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
  ::
  ?.  ?=(%finished -.response)
    [~ this]
  =*  status    status-code.response-header.response
  ::  Only (FOR NOW) parse successful responses
  ::
  =/  hit=httr:eyre
    (to-httr:iris response-header.response full-file.response)
  =/  rpc-resp=response:rpc:jstd  (httr-to-rpc-response hit)
  ?.  =(%result -.rpc-resp)
    ~&  +.rpc-resp
    [~ this]
  ::
  =/  btc-resp=response:btc-rpc
    (parse-response:btc-rpc:lib rpc-resp)
  ?+    -.btc-resp  ~|  [%unsupported-response -.btc-resp]  !!
      %create-wallet
    =/  btc-store-req=btc-node-store-action
      :+  %add-wallet   name.btc-resp
      ?:(=('' warning.btc-resp) ~ (some warning.btc-resp))
    :_  this
    [(btc-node-store-poke /store btc-store-req)]~
  ::
      %get-address-info
    ~&  [%address-info +.btc-resp]
    [~ this]
  ::
      %get-balance
    ~&  [%wallet-balance +.btc-resp]
    [~ this]
  ::
      %get-wallet-info
    =/  btc-store-req=btc-node-store-action
      ::  +>:btc-resp
      ::  Discards  %get-wallet-info and wallet-name
      ::  and passes just the wallet attributes
      ::
      [%update-wallet wallet-name.btc-resp +>:btc-resp]
    :_  this
    [(btc-node-store-poke /update btc-store-req)]~
  ::
      %list-wallets
    ~&  [%remote-wallets +.btc-resp]
    :_  this
    [(btc-node-store-poke /list [%list-wallets ~])]~
  ::
      %list-transactions
    ~&  [%transactions +.btc-resp]
    [~ this]
  ::
  ==
::
::  From:
::  https://github.com/urbit/arvo/pull/973/commits/be296f6897ca6c96225d844912d7e92ea93ea75a#diff-32b4dc798ca3aa3aa5c9fbd963627d4eR1941
::
++  httr-to-rpc-response
  |=  hit=httr:eyre
  ^-  response:rpc:jstd
  ~|  hit
  ?.  ?=($2 (div p.hit 100))
    fail+hit
  =/  a=json  (need (de-json:html q:(need r.hit)))
  =,  dejs-soft:format
  ^-  response:rpc:jstd
  =;  dere
    =+  res=((ar dere) a)
    ?~  res  (need (dere a))
    [%batch u.res]
  |=  a=json
  ^-  (unit response:rpc:jstd)
  =/  res=(unit [@t json])
    ::  TODO  breaks when no id present
    ::
    ((ot id+so result+some ~) a)
    ::  TODO: Modify to use dejs instead of dejs-soft
    ::
    :: %.  a
    :: =-  (ou -)
    :: :~  ['id' (uf ~ (mu so))]
    ::     ['result' some]
    :: ==
  ?^  res  `[%result u.res]
  ~|  a
  :+  ~  %error  %-  need
  ((ot id+so error+(ot code+no message+so ~) ~) a)
::
++  btc-node-store-poke
  |=  [pax=path act=btc-node-store-action]
  ^-  move
  ::  TODO: implement +coup arm
  ::
  :*  ost.bol
      %poke
      pax
      [our.bol %btc-node-store]
      [%btc-node-store-action act]
  ==
::
--
