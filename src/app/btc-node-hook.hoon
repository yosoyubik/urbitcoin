::  btc-node-hook: send JSON rpc requests to bitcoin full node
::  and poke the responses into the btc-node-store
::
/-  *btc-node-hook, *btc-node-store, sole
/+  default-agent, sole, lib=btc-node-json, verb
::
=>  |%
    +$  card  card:agent:gall
    +$  versioned-state
      $%  [%0 state-zero]
      ==
    ::
    +$  state-zero
      $:  endpoint=@t
          headers=header-list:http
      ==
    --
::
=|  state-zero
=*  state  -
::  Main
::
%+  verb  |
^-  agent:gall
=<  |_  =bowl:gall
    +*  this      .
        btc-core  +>
        bc        ~(. btc-core bowl)
        def       ~(. (default-agent this %|) bowl)
    ::
    ++  on-init
      ^-  (quip card _this)
      :-  ~
      %=  this
        endpoint  'http://127.0.0.1:8332'
        headers
          :~  ['Accept' 'application/json']
              ['Content-Type' 'text/plain']
              ['Authorization' 'Basic dXJiaXRjb2luZXI6dXJiaXRjb2luZXI']
      ==  ==
    ::
    ++  on-save   !>(state)
    ++  on-load
      |=  old=vase
      `this(state !<(state-zero old))
    ::
    ++  on-poke
      |=  [=mark =vase]
      ^-  (quip card _this)
      |^
      ?+    mark    (on-poke:def mark vase)
          %btc-node-hook-action  (hook-action !<(btc-node-hook-action vase))
      ==
      ::
      ++  hook-action
        |=  act=btc-node-hook-action
        =/  body=request:rpc:jstd
          (request-to-rpc:btc-rpc:lib act)
        =/  req=request:http
          :*  %'POST'
              (endpoint-url:bc act)
              headers
              =,  html
              %-  some
                %-  as-octt:mimes
                  (en-json (request-to-json:rpc:jstd body))
          ==
        =/  out  *outbound-config:iris
        :_  this
        [%pass /[(scot %da now.bowl)] %arvo %i %request req out]~
      --
    ::
    ++  on-watch  on-watch:def
    ++  on-leave  on-leave:def
    ++  on-peek   on-peek:def
    ++  on-agent  on-agent:def
    ++  on-arvo
      |=  [=wire =sign-arvo]
      ^-  (quip card _this)
      =*  response  client-response.sign-arvo
      =^  cards  state
        ?+    +<.sign-arvo    (on-arvo:def wire sign-arvo)
            %http-response    (http-response:bc wire response)
        ==
      [cards this]
    ::
    ++  on-fail   on-fail:def
    --
::
|_  =bowl:gall
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
++  http-response
  |=  [=wire response=client-response:iris]
  ?.  ?=(%finished -.response)
    [~ state]
  =*  status    status-code.response-header.response
  =/  rpc-resp=response:rpc:jstd
    %-  httr-to-rpc-response
      %+  to-httr:iris
        response-header.response
      full-file.response
  ::  Only (FOR NOW) parse successful responses
  ::
  ?.  =(%result -.rpc-resp)
    ~&  +.rpc-resp
    [~ state]
  %-  handle-btc-response
    (parse-response:btc-rpc:lib rpc-resp)
::
++  handle-btc-response
  |=  btc-resp=btc-node-hook-response
  ^-  (quip card _state)
  :_  state
  ^-  (list card)
  ;:  weld
      ::  Print term for each succesful RPC request (used by :ph)
      ::
      ^-  (list card)
      [%pass / %arvo %d %flog [%text (trip -.btc-resp)]]~
      ?+    -.btc-resp  ~|  [%unsupported-response -.btc-resp]  !!
          %create-wallet
        ^-  (list card)
        =/  btc-store-req=btc-node-store-action
          :+  %add-wallet   name.btc-resp
          ?:(=('' warning.btc-resp) ~ (some warning.btc-resp))
        [(btc-node-store-poke /store btc-store-req)]~
      ::
          %get-address-info
        ^-  (list card)
        ~&  [%address-info +.btc-resp]
        ~
      ::
          %get-balance
        ^-  (list card)
        :_  ~
        :*  %pass  /  %arvo  %d  %flog
            %text  "amount={(trip +.btc-resp)}"
        ==
      ::
          %get-wallet-info
        ^-  (list card)
        =/  btc-store-req=btc-node-store-action
          [%update-wallet wallet-name.btc-resp +>:btc-resp]
        [(btc-node-store-poke /update btc-store-req)]~
      ::
          %list-wallets
        ^-  (list card)
        [(btc-node-store-poke /list [%list-wallets ~])]~
      ::
          %list-transactions
        ^-  (list card)
        ~&  [%transactions +.btc-resp]
        ~
  ==  ==
::
++  btc-node-store-poke
  |=  [pax=path act=btc-node-store-action]
  ^-  card
  :*  %pass   pax
      %agent  [our.bowl %btc-node-store]
      %poke   [%btc-node-store-action !>(act)]
  ==
::
++  default-wallet
  =-  .^(@t %gx -)
  %+  weld  /(scot %p our.bowl)/btc-node-store
  /(scot %da now.bowl)/default-wallet/noun
::
++  n-wallets
  =-  .^(@ud %gx -)
  %+  weld  /(scot %p our.bowl)/btc-node-store
  /(scot %da now.bowl)/n-wallets/noun
::
++  endpoint-url
  |=  [act=btc-node-hook-action]
  ?.  ?|  =(-.act %get-balance)
          =(-.act %get-address-info)
          =(-.act %get-wallet-info)
      ==
      endpoint
  ::  FIXME: fails when default-wallet is '' and more than 1 wallet
  ::  has been created
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
  ::  A %switch-wallet command needs to be issued against the store app
  ::  when a wallet is created
  ::  e.g.  > btc-node-store|command [%switch-wallet 'local']
  ::
  ?:  (lte n-wallets 1)
    endpoint
  %-  crip  %+  weld
    "{(trip endpoint)}/wallet/"
  ?:  =('' default-wallet)  ~
  "{(trip default-wallet)}"
--
