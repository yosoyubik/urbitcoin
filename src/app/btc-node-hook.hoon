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
  ::  THIS WORKS!
  =/  body=request:rpc:jstd
    (request-to-rpc:btc-rpc:lib act)
  :: ~&  poking+body
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

  :: =/  en-addr=@uc  0c1GdK9UzpHBzqzX2A9JFP3Di4weBwqgmoQA
  :: =/  addr=@t      (base58-to-cord:btc-rpc:lib en-addr)
  :: =/  en-txid=@ux  0x1234.1234
  :: =/  txid=@t      (hex-to-cord:btc-rpc:lib en-txid)
  :: =/  requests=(list btc-node-hook-action)
  :: :~  [%abandon-transaction en-txid]
  ::     [%abort-rescan ~]
  ::     [%backup-wallet 'XXXX']
  ::     [%bump-fee en-txid `[`'23' `'23' `& `%'ECONOMICAL']]
  ::     [%create-wallet 'test-create-wallet' `| `|]
  ::     [%dump-privkey en-addr]
  ::     [%dump-wallet filename=*@t]
  ::     [%encrypt-wallet passphrase=*@t]
  ::     [%get-addresses-by-label label=*@t]
  ::     [%get-address-info en-addr]
  ::     :*  %get-balance
  ::         dummy=*(unit @t)
  ::         minconf=*(unit @ud)
  ::         include-watch-only=*(unit ?)
  ::     ==
  ::     [%get-new-address label=*(unit @t) address-type=`%bech32]
  ::     [%get-raw-change-address address-type=`%bech32]
  ::     [%get-received-by-address en-addr minconf=*@ud]
  ::     [%get-received-by-label *@t ~]
  ::     [%get-transaction en-txid *(unit ?)]
  ::     [%get-unconfirmed-balance ~]
  ::     [%get-wallet-info ~]
  ::     [%import-address en-addr label=*(unit @t) rescan=*(unit ?) p2sh=*(unit ?)]
  ::     [%import-multi requests=~ options=~]
  ::     [%import-privkey privkey=*@t label=*(unit @t) rescan=*(unit ?)]
  ::     [%import-pruned-funds raw-transaction=*@t tx-out-proof=*@t]
  ::     [%import-pubkey pubkey=*@t label=*(unit @t) rescan=*(unit ?)]
  ::     [%import-wallet filename=*@t]
  ::     [%key-pool-refill new-size=*(unit @ud)]
  ::     [%list-address-groupings ~]
  ::     [%list-labels purpose=*(unit @t)]
  ::     [%list-lock-unspent ~]
  ::     :*  %list-received-by-address
  ::         minconf=*(unit @ud)
  ::         include-empty=*(unit ?)
  ::         include-watch-only=*(unit ?)
  ::         address-filter=*(unit @t)
  ::     ==
  ::     :*  %list-received-by-label
  ::         minconf=*(unit @ud)
  ::         include-empty=*(unit ?)
  ::         include-watch-only=*(unit ?)
  ::     ==
  ::     :*  %lists-in-ceblock
  ::         blockhash=*(unit @t)
  ::         target-confirmations=*(unit @ud)
  ::         include-watch-only=*(unit ?)
  ::         include-removed=*(unit ?)
  ::     ==
  ::     :*  %list-transactions
  ::         label=*(unit @t)
  ::         count=*(unit @ud)
  ::         skip=*(unit @ud)
  ::         include-watch-only=*(unit ?)
  ::     ==
  ::     =/  query-options  %-  some
  ::       :*  minimum-amount=*(unit @t)  ::  n+(scot %ta minimun-amount)
  ::           maximum-amount=*(unit @t)
  ::           maximum-count=*(unit @t)
  ::           minimum-sum-amount=*(unit @t)
  ::       ==
  ::     :*  %list-unspent
  ::         minconf=*(unit @t)
  ::         maxconf=*(unit @ud)
  ::         addresses=*(unit (list @t))
  ::         include-unsafe=*(unit ?)
  ::         query-options=query-options
  ::     ==
  ::     [%list-wallet-dir ~]
  ::     [%list-wallets ~]
  ::     [%load-wallet filename=*@t]
  ::     [%lock-unspent unlock=*? transactions=*(unit (list [txid=@t vout=@ud]))]
  ::     [%remove-pruned-funds en-txid]
  ::     [%rescan-blockchain start-height=*(unit @ud) stop-height=*(unit @ud)]
  ::     :*  %send-many
  ::         dummy=%''
  ::         amounts=~
  ::         minconf=*(unit @ud)
  ::         comment=*(unit @t)
  ::         subtract-fee-from=*(unit (list address))
  ::         conf-target=*(unit @ud)
  ::         estimate-mode=*(unit @t)
  ::     ==
  ::     :*  %send-to-address
  ::         en-addr
  ::         amount=*@t
  ::         comment=*(unit @t)
  ::         comment-to=*(unit @t)
  ::         subtract-fee-from=*(unit (list address))
  ::         replaceable=*(unit ?)
  ::         conf-target=*(unit @ud)
  ::         estimate-mode=*(unit @t)
  ::     ==
  ::     [%set-hd-seed ~]
  ::     [%set-label en-addr label=*@t]
  ::     [%set-tx-fee amount=*@t]
  ::     [%sign-message en-addr message=*@t]
  ::     :: =/  prev-txs   %-  some  %-  limo
  ::     ::   :~  txid=*@t
  ::     ::       vout=*@ud
  ::     ::       script-pub-key=*@t
  ::     ::       redeem-script=*@t
  ::     ::       witness-script=*@t
  ::     ::       amount=*@t
  ::     ::    ==
  ::     :*  %sign-raw-transaction-with-wallet
  ::         *@t
  ::         ~
  ::         `%'ALL'
  ::     ==
  ::     [%unload-wallet wallet-name=*(unit @t)]
  ::     [%wallet-lock ~]
  ::     [%wallet-passphrase passphrase=*@t timeout=*@ud]
  ::     :+  %wallet-passphrase-change
  ::     old-passphrase=*(unit @t)  new-passphrase=*(unit @t)
  ::     :*  %wallet-process-psbt
  ::         psbt=*@t
  ::         sign=*(unit ?)
  ::         sig-hash-type=`%'ALL'
  ::         bip32derivs=*(unit ?)
  ::     ==
  ::     [%get-zmq-notifications ~]
  :: ==
  :: =/  op  %get-unconfirmed-balance
  :: [op ~]
  :: =/  body-1=request:rpc:jstd
  ::   (request-to-rpc:btc-rpc:lib action)
  :: ::
  :: =/  op  %get-wallet-info
  :: [op ~]
  :: =/  body-2=request:rpc:jstd

  ::
  :: :_  this
  :: ^-  (list move)
  :: %+  turn  requests
  ::   |=  action=btc-node-hook-action
  ::   =/  body=request:rpc:jstd
  ::     (request-to-rpc:btc-rpc:lib action)
  ::   =/  req=request:http
  ::     :*  %'POST'
  ::         endpoint
  ::         headers
  ::         %-  some
  ::           %-  as-octt:mimes:html
  ::           (en-json:html (request-to-json:rpc:jstd body))
  ::     ==
  ::   =/  out  *outbound-config:iris
  ::   [ost.bol %request /[-.body] req out]
::
++  http-response
  |=  [=wire response=client-response:iris]
  ^-  (quip move _this)
  ::  ignore all but %finished
  ::
  ?.  ?=(%finished -.response)
    [~ this]
  :: TODO: decode the JSON-RPC response and poke the btc-node-store
  :: with the returned data
  =*  status  status-code.response-header.response
  ::  Only (FOR NOW) parse successful responses
  ::
  ?:  =(status 200)
      ~&  response+response
      [~ this]
  [~ this]
::
++  btc-node-store-poke
  |=  [pax=path act=btc-node-store-action]
  ^-  move
  [ost.bol %poke pax [our.bol %btc-node-store] [%btc-node-store-action act]]
::
--
