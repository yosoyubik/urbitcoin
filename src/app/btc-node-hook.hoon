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
      %_  this
        endpoint  ''
        headers   ~
      ==
    ::
    ++  on-save   !>(state)
    ++  on-load
      |=  old=vase
      `this(state !<(state-zero old))
    ::
    ++  on-poke
      |=  [=mark =vase]
      ^-  (quip card _this)
      |^  ?+    mark    (on-poke:def mark vase)
              %btc-node-hook-action
            (hook-action !<(btc-node-hook-action vase))
          ::
              %btc-node-hook-command
            (hook-command !<(btc-node-hook-command vase))
          ==
      ::
      ++  hook-action
        |=  act=btc-node-hook-action
        ^-  (quip card _this)
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
      ::
      ++  hook-command
        |=  comm=btc-node-hook-command
        ^-  (quip card _this)
        ?+    -.comm  ~|  [%unsupported-hook-command -.comm]  !!
            %credentials
          :_  this(endpoint url.comm, headers heads.comm)
          [%pass / %arvo %d %flog [%text "credentials updated..."]]~
        ==
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
  =/  jon=json  (need (de-json:html q:(need r.hit)))
  ?.  =(%2 (div p.hit 100))
    (parse-error jon)
  =,  dejs-soft:format
  ^-  response:rpc:jstd
  =;  dere
    =+  res=((ar dere) jon)
    ?~  res  (need (dere jon))
    [%batch u.res]
  |=  jon=json
  ^-  (unit response:rpc:jstd)
  =/  res=[id=(unit @t) res=(unit json) err=(unit json)]
    %.  jon
    =,  dejs:format
    =-  (ou -)
    :~  ['id' (uf ~ (mu so))]
        ['result' (uf ~ (mu same))]
        ['error' (uf ~ (mu same))]
    ==
  ?:  ?=([^ * ~] res)
    `[%result [u.id.res ?~(res.res ~ u.res.res)]]
  ~|  jon
  `(parse-error jon)
::
++  parse-error
  |=  =json
  ^-  response:rpc:jstd
  :-  %error
  ?~  json  ['' '' '']
  %.  json
  =,  dejs:format
  =-  (ou -)
  :~  =-  ['id' (uf '' (cu - (mu so)))]
      |*(a=(unit) ?~(a '' u.a))
      :-  'error'
      =-  (uf ['' ''] -)
      =-  (cu |*(a=(unit) ?~(a ['' ''] u.a)) (mu (ou -)))
      :~  ['code' (uf '' no)]
          ['message' (uf '' so)]
  ==  ==
::
++  http-response
  |=  [=wire response=client-response:iris]
  ^-  (quip card _state)
  ?.  ?=(%finished -.response)
    [~ state]
  =*  status    status-code.response-header.response
  =/  rpc-resp=response:rpc:jstd
    %-  httr-to-rpc-response
    %+  to-httr:iris
      response-header.response
    full-file.response
  ?.  ?=([%result *] rpc-resp)
    ~&  [%error +.rpc-resp]
    [~ state]
  %-  handle-btc-response
    (parse-response:btc-rpc:lib rpc-resp)
::
++  handle-btc-response
  |=  btc-resp=btc-node-hook-response
  ^-  (quip card _state)
  :_  state
  ^-  (list card)
  ?+    -.btc-resp
      ::  By default we just print all RPC responses that are not
      ::  considered here explicitly for proper format printing or
      ::  for being passed on to the store app.
      ::
      ~&  btc-resp
      ~
  ::
      :: %abandon-transaction
      :: %abort-rescan
      :: %add-multisig-address
      :: %backup-wallet
      :: %bump-fee
      %create-wallet
    ^-  (list card)
    =/  btc-store-req=btc-node-store-action
      :+  %add-wallet   name.btc-resp
      ?:(=('' warning.btc-resp) ~ (some warning.btc-resp))
    [(btc-node-store-poke /store btc-store-req)]~
  ::
      :: %dump-privkey
      :: %dump-wallet
      :: %encrypt-wallet
      :: %get-addresses-by-label
  ::
      %get-address-info
    ^-  (list card)
    ~&  [%address-info +.btc-resp]
    ~
  ::
      %get-balance
    ^-  (list card)
    ~&  [%amount (trip +.btc-resp)]
    ~
  ::
      :: %get-balance
      :: %get-new-address
      :: %get-raw-change-address
      :: %get-received-by-address
      :: %get-received-by-label
      :: %get-transaction
      :: %get-unconfirmed-balance
  ::
      %get-wallet-info
    ^-  (list card)
    =/  btc-store-req=btc-node-store-action
      [%update-wallet wallet-name.btc-resp +>:btc-resp]
    [(btc-node-store-poke /update btc-store-req)]~
  ::
      :: %import-address
      :: %import-multi
      :: %import-privkey
      :: %import-pruned-funds
      :: %import-pubkey
      :: %import-wallet
      :: %key-pool-refill
      :: %list-address-groupings
      :: %list-labels
      :: %list-lock-unspent
      :: %list-received-by-address
      :: %list-received-by-label
      :: %lists-in-ceblock
  ::
      %list-transactions
    ^-  (list card)
    ~&  [%transactions +.btc-resp]
    ~
  ::
      :: %list-unspent
      :: %list-wallet-dir
  ::
      %list-wallets
    ^-  (list card)
    [(btc-node-store-poke /list [%list-wallets ~])]~
  ::
      :: %load-wallet
      :: %lock-unspent
      :: %remove-pruned-funds
      :: %rescan-blockchain
      :: %send-many
      :: %send-to-address
      :: %set-hd-seed
      :: %set-label
      :: %set-tx-fee
      :: %sign-message
      :: %sign-raw-transaction-with-wallet
      :: %unload-wallet
      :: %wallet-create-fundedpsbt
      :: %wallet-lock
      :: %wallet-passphrase
      :: %wallet-passphrase-change
      :: %wallet-process-psbt
  ==
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
  .^  @t
      %gx
      (scot %p our.bowl)
      %btc-node-store
      (scot %da now.bowl)
      /default-wallet/noun
  ==
::
++  n-wallets
  .^  @ud
    %gx
    (scot %p our.bowl)
    %btc-node-store
    (scot %da now.bowl)
    /n-wallets/noun
  ==
::
++  endpoint-url
  |=  [act=btc-node-hook-action]
  ?.  ?|  ?=(%abandon-transaction -.act)
          ?=(%abort-rescan -.act)
          ?=(%add-multisig-address -.act)
          ?=(%backup-wallet -.act)
          ?=(%bump-fee -.act)
          ?=(%dump-privkey -.act)
          ?=(%dump-wallet -.act)
          ?=(%encrypt-wallet -.act)
          ?=(%fund-raw-transaction -.act)
          ?=(%get-balance -.act)
          ?=(%get-addresses-by-label -.act)
          ?=(%get-address-info -.act)
          ?=(%get-new-address -.act)
          ?=(%get-raw-change-address -.act)
          ?=(%get-received-by-address -.act)
          ?=(%get-received-by-label -.act)
          ?=(%get-transaction -.act)
          ?=(%get-unconfirmed-balance -.act)
          ?=(%get-wallet-info -.act)
          ?=(%import-address -.act)
          ?=(%import-multi -.act)
          ?=(%import-privkey -.act)
          ?=(%import-pruned-funds -.act)
          ?=(%import-pubkey -.act)
          ?=(%import-wallet -.act)
          ?=(%key-pool-refill -.act)
          ?=(%list-address-groupings -.act)
          ?=(%list-labels -.act)
          ?=(%list-lock-unspent -.act)
          ?=(%list-received-by-address -.act)
          ?=(%list-received-by-label -.act)
          ?=(%lists-in-ceblock -.act)
          ?=(%list-transactions -.act)
          ?=(%list-unspent -.act)
          ?=(%lock-unspent -.act)
          ?=(%remove-pruned-funds -.act)
          ?=(%rescan-blockchain -.act)
          ?=(%send-many -.act)
          ?=(%send-to-address -.act)
          ?=(%set-hd-seed -.act)
          ?=(%set-label -.act)
          ?=(%set-tx-fee -.act)
          ?=(%sign-message -.act)
          ?=(%sign-raw-transaction-with-wallet -.act)
          ?=(%wallet-create-fundedpsbt -.act)
          ?=(%wallet-lock -.act)
          ?=(%wallet-passphrase -.act)
          ?=(%wallet-passphrase-change -.act)
          ?=(%wallet-process-psbt -.act)
      ==
    endpoint
  ?:  ?=([?(%dump-wallet %import-wallet) filename=@t] act)
    (crip "{(trip endpoint)}wallet/{(trip filename.act)}")
  ::  FIXME: fails when default-wallet is '' and more than 1 wallet
  ::  has been created
  ::
  ::    url='http://127.0.0.1:18443/wallet/'
  ::
  ::  although this example works with curl:
  ::
  :: curl --user XXX:YYY
  ::      --data-binary '{
  ::        "jsonrpc": "1.0",
  ::        "id":"curltest",
  ::        "method": "getwalletinfo",
  ::        "params": []
  ::      }'
  ::      -H 'content-type: text/plain;'
  ::      http://127.0.0.1:18443/wallet/
  ::
  ::  A %switch-wallet command needs to be issued against the store app
  ::  after a wallet is created, in order to use it.
  ::
  ::  e.g.  > :btc-node-store|command [%switch-wallet 'local']
  ::
  ?:  (lte n-wallets 1)
    endpoint
  %-  crip  %+  weld
    "{(trip endpoint)}wallet/"
  ?:  =('' default-wallet)  ~
  "{(trip default-wallet)}"
--
