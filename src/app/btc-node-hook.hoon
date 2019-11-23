::  btc-node-hook: send JSON rpc requests to bitcoin full node
::  and poke the responses into the btc-node-store
::
/-  *btc-node-hook, *btc-node-store, sole
/+  sole, lib=btc-node-json
::
=,  sole
::
|%
+$  move  (pair bone card)
+$  card
  $%  [%request wire request:http outbound-config:iris]
      [%diff %sole-effect sole-effect]
      [%flog wire flog:dill]
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
      ::  $consol: console state
      ::
      ::     $conn:  id for console connection
      ::     $state: data in the console
      ::
      consol=[conn=bone state=sole-share]
  ==
--
::
|_  [bol=bowl:gall state]
::
::  %alias: rewording of commonly used nouns
::
+|  %alias
::
::  %this: common idiom to refer to our whole %app door and its context
::
++  this  .
::
::  Aliasing arms declared within cores (requiered by gall)
::
++  poke-sole-action          poke-sole-action:co:view
++  peer-sole-action          peer-sole-action:co:view
:: ++  peer-sole                 peer-sole:co:view
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
::  %view
::
::    Arms for displaying notes on the console and frontend
::
++  view
  |%
  ::
  ::  %co: console
  ::
  ::    %sole arms to receive console moves and prompt formatting
  ::
  ++  co
    |%
    ++  peer-sole
      |=  path
      ^-  (quip move _this)
      ~&  "peered..."
      =.  consol  [ost.bol *sole-share]
      ~&  consol
      [~ this]
      :: :_  this
      :: :_  ~
      :: (send (prompt enter))
      :: =.  consol  [ost.bol *sole-share]
      :: :_  this
      :: [(send (prompt enter))]~
    ::
    ++  send
      |=  e=sole-effect
      ^-  move
      [conn.consol %diff %sole-effect e]
    ::
    ++  prompt
      |=  dial=styx
      ^-  sole-effect
      pro+[| %$ dial]
    :: ::
    ++  enter
      ^-  styx
      [[```%y] " | BTC | "]~
    ::
    ++  poke-sole-action
      |=  act=sole-action
      ^-  (quip move _this)
      ?.  =(conn.consol ost.bol)  ~|(%strange-sole !!)
      =*  share  state.consol
      ?+    -.act  [~ this]
          ::  %clr: clear screen
          ::
          %clr
        [~ this]
      ::
          ::  %ret: enter key pressed
          ::
          %ret
        [~ this]
      ::
          ::  %det: key press
          ::  pressed key is stored in the console state
          ::
          %det
        (edit-sole +.act)
      ==
    :: ::
    ++  to-sole
      |=  inv=sole-edit
      ^-  [sole-change sole-share]
      (~(transmit ..transmit state.consol) inv)
    ::
    ++  edit-sole
      |=  cal=sole-change
      ^-  (quip move _this)
      =^  edit  state.consol
        (~(transceive ..transceive state.consol) cal)
      [~ this]
    --
  --
::
++  poke-atom
  |=  a=@
  ^-  (quip move _this)
  :_  this
  [ost.bol %flog / ^-(flog:dill text+"done")]~
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
          %-  crip
          %+  weld  "{(trip endpoint)}/wallet/"
          ?:  =('' wallet.act)  ~
          "{(trip wallet.act)}"
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
        ::
          ::   %list-transactions
          :: ::  FIXME: fails when name.act is ''
          :: ::
          :: (crip "{(trip endpoint)}/wallet/{(trip wallet.act)}")
        ==
        headers
        %-  some
          %-  as-octt:mimes:html
            (en-json:html (request-to-json:rpc:jstd body))
    ==
  :_  this
  [ost.bol %request /[(scot %da now.bol)] req *outbound-config:iris]~
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
  ^-  (quip move _this)
  %-  parse-response
    ^-  response:btc-rpc
    %-  parse-response:btc-rpc:lib
      ^-  response:rpc:jstd
      rpc-resp
::
++  parse-response
  |=  rpc-resp=response:btc-rpc
  ^-  (quip move _this)
  :_  this
  ;:  weld
      ::  Print term for each succesful RPC request
      ::
      [ost.bol %flog / [%text (trip -.rpc-resp)]]~
      ?+    -.rpc-resp  ~|  [%unsupported-response -.rpc-resp]  !!
          %create-wallet
        =/  btc-store-req=btc-node-store-action
          :+  %add-wallet   name.rpc-resp
          ?:(=('' warning.rpc-resp) ~ (some warning.rpc-resp))
        [(btc-node-store-poke /store btc-store-req)]~
      ::
          %get-address-info
        ~&  [%address-info +.rpc-resp]
        ~
      ::
          %get-balance
        :_  ~
        :*  ost.bol   %flog   /   %text
            "amount={(trip +.rpc-resp)}"
        ==
      ::
          %get-wallet-info
        =/  btc-store-req=btc-node-store-action
          [%update-wallet wallet-name.rpc-resp +>:rpc-resp]
        [(btc-node-store-poke /update btc-store-req)]~
      ::
          %list-wallets
        :~  (btc-node-store-poke /list [%list-wallets ~])
        :*  ost.bol   %flog   /   %text
            "wallets={<`wain`+.rpc-resp>}"
        ==  ==
      ::
          %list-transactions
        ~&  [%transactions +.rpc-resp]
        ~
  ==  ==
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
