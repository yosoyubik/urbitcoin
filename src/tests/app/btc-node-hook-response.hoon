/-  *btc-node-hook
/+  *test, lib=btc-node-json
::
/=  app  /:  /===/app/btc-node-hook
             /!noun/
::
/=  http-client-raw  /:  /===/sys/vane/iris  /!noun/
::
!:
::
=/  test-pit=vase  !>(..zuse)
=/  http-client-gate  (http-client-raw test-pit)
::
=/  endpoint  'http://127.0.0.1:8332'
=/  headers
  :~  ['Accept' 'application/json']
      ['Content-Type' 'text/plain']
      ['Authorization' 'Basic dXJiaXRjb2luZXI6dXJiaXRjb2luZXI']
  ==
=/  app-state=state:app  [%0 endpoint headers ~]
::
|%
::  Others
::
++  test-get-request-to-iris  ^-  tang
  =/  op  %get-blockchain-info
  =/  action=btc-node-hook-action:lib  [op ~]
  =/  expected-body  [op (method:btc-rpc:lib op) %list ~]
  =^  request  app
    (~(poke-noun app *bowl:gall app-state) action)
  :: ~&  endpoint.app-state
  ;:  weld
    %+  expect-eq
      !>  ^-  (list move:app)
          :~  :*  ost.bol.app
                  %request
                  /~2000.1.1
                  :*  %'POST'
                      endpoint.app-state
                      headers.app-state
                      %-  some
                        %-  as-octt:mimes:html
                          (en-json:html (request-to-json:rpc:jstd expected-body))
                  ==
                  *outbound-config:iris
          ==  ==
      !>  request
  ==
  :: ~&  ^-((hobo task:able:iris) +:(snag 0 request))
  :: ~&  ?:(?=((hobo task:able:iris) +:(snag 0 request)) & |)
  :: ?~  request  ~
  :: =/  request  +:(snag 0 request)
  :: ~&  ^=  request
  :: :~  ^-(term &1:request)
  ::     :: &2:request
  :: ^-  wire  &2:request
  :: :: ^-  wire  &1:request
  :: :: ^-  request:http  &3:request
  :: :: ^-  outbound-config:iris  &4:request
  :: ==
  :: ~&  ^-(task:able:iris request)
  :: ~&  request.request
  :: ~&  outbound-config.request
  :: =^  response  http-client-gate
  ::   %-  http-client-call
  ::     :*  http-client-gate
  ::         now=(add ~1111.1.1 ~s1)
  ::         scry=*sley
  ::         ^=  call-args
  ::           :*  duct=~[/http-get-request]  ~
  ::             +:(snag 0 request)
  ::     ==    ==
  :: ~&  response
::
::  Wallet
::
++  test-abandon-transaction  ^-  tang
  %+  expect-eq
    !>  &
    !>  |
::
++  test-abort-rescan  ^-  tang
  %+  expect-eq
    !>  &
    !>  |
::
++  test-add-multisig-address  ^-  tang
  %+  expect-eq
    !>  &
    !>  |
::
++  test-backup-wallet  ^-  tang
  %+  expect-eq
    !>  &
    !>  |
::
++  test-bump-fee  ^-  tang
  =/  call=request:rpc:jstd
    :^  %bump-fee  (method:btc-rpc:lib %bump-fee)  %list  ~
  :: ~&  call
  %+  expect-eq
    !>  &
    !>  |
::
:: ++  test-create-wallet  ^-  tang
::   =/  op  %create-wallet
::   =/  action=request:btc-rpc
::     [op name='test-create-wallet' disable-private-keys=`| blank=`|]
::     %+  expect-eq
::       !>  :^  op   (method:btc-rpc:lib op)  %list
::           ~[s+'test-create-wallet' b+| b+|]
::       !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-dump-privkey  ^-  tang
::   =/  op  %dump-privkey
::   =/  action=request:btc-rpc  [op address=*@t]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list [s+'']~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-dump-wallet  ^-  tang
::   =/  op  %dump-wallet
::   =/  action=request:btc-rpc  [op filename=*@t]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list [s+'']~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-encrypt-wallet  ^-  tang
::   =/  op  %encrypt-wallet
::   =/  action=request:btc-rpc  [op passphrase=*@t]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list [s+'']~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-get-addresses-by-label  ^-  tang
::   =/  op  %get-addresses-by-label
::   =/  action=request:btc-rpc  [op label=*@t]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list [s+'']~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-get-address-info  ^-  tang
::   =/  op  %get-address-info
::   =/  action=request:btc-rpc  [op address=*@t]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list [s+'']~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-get-balance  ^-  tang
::   =/  op  %get-balance
::   =/  action=request:btc-rpc
::     [op dummy=*(unit @t) minconf=*(unit @ud) include-watch-only=*(unit ?)]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-get-new-address  ^-  tang
::   =/  op  %get-new-address
::   =/  action=request:btc-rpc
::     [op label=*(unit @t) address-type=*(unit @t)]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-get-raw-change-address  ^-  tang
::   =/  op  %get-raw-change-address
::   =/  action=request:btc-rpc
::     [op address-type=*(unit @t)]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-get-received-by-address  ^-  tang
::   =/  op  %get-received-by-address
::   =/  action=request:btc-rpc
::     [op address=*@t minconf=*@ud]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~[s+'' n+(scot %ud *@ud)]]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-get-received-by-label  ^-  tang
::   =/  op  %get-received-by-label
::   =/  action=request:btc-rpc  [op *@t ~]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~[s+'']]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-get-transaction  ^-  tang
::   =/  op  %get-transaction
::   =/  action  [op *@t *(unit ?)]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~[s+'']]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
++  test-get-unconfirmed-balance  ^-  tang
  =/  op  %get-unconfirmed-balance
  =/  action=request:btc-rpc  [op ~]
  =/  call=request:rpc:jstd  [op (method:btc-rpc:lib op) %list ~]
  :: ~&  call
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-get-wallet-info  ^-  tang
  =/  op  %get-wallet-info
  =/  action=request:btc-rpc  [op ~]
  ::
  :: =^  request  app
  ::   (~(poke-noun app *bowl:gall app-state) action)
  =/  request=request:rpc:jstd
    (request-to-rpc:btc-rpc:lib action)
  :: ?~  request  *tang
  :: =/  req=card:app  card.i.request
  ::
  =^  response  http-client-gate
    %-  http-client-call
      :*  http-client-gate
          now=(add ~1111.1.1 ~s1)
          scry=*sley
          request
      ==
  ~&  response
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
:: ++  test-import-address  ^-  tang
::   =/  op  %import-address
::   =/  action=request:btc-rpc
::     [op address=*@t label=*(unit @t) rescan=*(unit ?) p2sh=*(unit ?)]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list [s+'']~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-import-multi  ^-  tang
::   =/  op  %import-multi
::   =/  action=request:btc-rpc  [op requests=~ options=~]
::     :: :+  %import-multi
::     :: :~  desc=*@t
::     ::     script-pub-key=*@t
::     ::     timestamp=*?(@da %'now')
::     ::     redeem-script=*@t
::     ::     witness-script=*@t
::     ::     pubkeys=*(unit (list @t))
::     ::     keys=*(unit (list @t))
::     ::     range=*?(@ [@ @])
::     ::     internal=*?
::     ::     watchonly=*?
::     ::     label=*@t
::     ::     keypool=*?
::     :: ==
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-import-privkey  ^-  tang
::   =/  op  %import-privkey
::   =/  action=request:btc-rpc
::     [op privkey=*@t label=*(unit @t) rescan=*(unit ?)]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list [s+'']~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-import-pruned-funds  ^-  tang
::   =/  op  %import-pruned-funds
::   =/  action=request:btc-rpc
::     [op raw-transaction=*@t tx-out-proof=*@t]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~[s+'' s+'']]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-import-pubkey  ^-  tang
::   =/  op  %import-pubkey
::   =/  action=request:btc-rpc
::     [op pubkey=*@t label=*(unit @t) rescan=*(unit ?)]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list [s+'']~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-import-wallet  ^-  tang
::   =/  op  %import-wallet
::   =/  action=request:btc-rpc  [op filename=*@t]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list [s+'']~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-key-pool-refill  ^-  tang
::   =/  op  %key-pool-refill
::   =/  action=request:btc-rpc  [op new-size=*(unit @ud)]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-list-address-groupings  ^-  tang
::   =/  op  %list-address-groupings
::   =/  action=request:btc-rpc  [op ~]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-list-labels  ^-  tang
::   =/  op  %list-labels
::   =/  action=request:btc-rpc  [op purpose=*(unit @t)]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-list-lock-unspent  ^-  tang
::   =/  op  %list-lock-unspent
::   =/  action=request:btc-rpc  [op ~]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-list-received-by-address  ^-  tang
::   =/  op  %list-received-by-address
::   =/  action=request:btc-rpc
::     :*  op
::         minconf=*(unit @ud)
::         include-empty=*(unit ?)
::         include-watch-only=*(unit ?)
::         address-filter=*(unit @t)
::     ==
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-list-received-by-label  ^-  tang
::   =/  op  %list-received-by-label
::   =/  action=request:btc-rpc
::     :*  op
::         minconf=*(unit @ud)
::         include-empty=*(unit ?)
::         include-watch-only=*(unit ?)
::     ==
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-lists-in-ceblock  ^-  tang
::   =/  op  %lists-in-ceblock
::   =/  action=request:btc-rpc
::     :*  op
::         blockhash=*(unit @t)
::         target-confirmations=*(unit @ud)
::         include-watch-only=*(unit ?)
::         include-removed=*(unit ?)
::     ==
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-list-transactions  ^-  tang
::   =/  op  %list-transactions
::   =/  action=request:btc-rpc
::     :*  op
::         label=*(unit @t)
::         count=*(unit @ud)
::         skip=*(unit @ud)
::         include-watch-only=*(unit ?)
::     ==
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-list-unspent  ^-  tang
::   =/  query-options  %-  some
::   :*  minimum-amount=*(unit @t)  ::  n+(scot %ta minimun-amount)
::       maximum-amount=*(unit @t)
::       maximum-count=*(unit @t)
::       minimum-sum-amount=*(unit @t)
::   ==
::   =/  op  %list-unspent
::   =/  action=request:btc-rpc
::     :*  op
::         minconf=*(unit @t)
::         maxconf=*(unit @ud)
::         addresses=*(unit (list @t))
::         include-unsafe=*(unit ?)
::         query-options=query-options
::     ==
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-list-wallet-dir  ^-  tang
::     =/  op  %list-wallet-dir
::     =/  action=request:btc-rpc  [op ~]
::     %+  expect-eq
::       !>  [op (method:btc-rpc:lib op) %list ~]
::       !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-list-wallets     ^-  tang
::     =/  op  %list-wallets
::     =/  action=request:btc-rpc  [op ~]
::     %+  expect-eq
::       !>  [op (method:btc-rpc:lib op) %list ~]
::       !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-load-wallet      ^-  tang
::   =/  op  %load-wallet
::   =/  action=request:btc-rpc  [op filename=*@t]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list [s+'']~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-lock-unspent  ^-  tang
::   =/  op  %lock-unspent
::   =/  action=request:btc-rpc
::     [op unlock=*? transactions=*(unit (list [txid=@t vout=@ud]))]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list [b+&]~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-remove-pruned-funds  ^-  tang
::   =/  op  %remove-pruned-funds
::   =/  action=request:btc-rpc  [op txid=*@t]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list [s+'']~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-rescan-blockchain  ^-  tang
::   =/  op  %rescan-blockchain
::   =/  action=request:btc-rpc
::     [op start-height=*(unit @ud) stop-height=*(unit @ud)]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-send-many  ^-  tang
::   =/  op  %send-many
::   =/  action=request:btc-rpc
::     :*  op
::         dummy=%''
::         amounts=~
::         minconf=*(unit @ud)
::         comment=*(unit @t)
::         subtract-fee-from=*(unit (list address))
::         conf-target=*(unit @ud)
::         estimate-mode=*(unit @t)
::     ==
:: ::     :~  s+dummy.req
:: ::         (feob (some amounts.req))
:: ::         (feud minconf.req)
:: ::         (ferm comment.req %t)
:: ::         (feob subtract-fee-from.req)
:: ::         :: ?~  subtract-fee-from.req  ~
:: ::         :: o+(~(gas by *(map @t json)) u.subtract-fee-from.req)
:: ::         (feud conf-target.req)
:: ::         (ferm estimate-mode.req %s)
:: ::     ==
:: ::   ::
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list [s+'']~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-send-to-address  ^-  tang
::   =/  op  %send-to-address
::   =/  action=request:btc-rpc
::     :*  op
::         address=*@t
::         amount=*@t
::         comment=*(unit @t)
::         comment-to=*(unit @t)
::         subtract-fee-from=*(unit (list address))
::         replaceable=*(unit ?)
::         conf-target=*(unit @ud)
::         estimate-mode=*(unit @t)
::     ==
:: ::     :~  s+address.req
:: ::         s+amount.req
:: ::         (ferm comment.req %s)
:: ::         (ferm comment-to.req %s)
:: ::         (feob subtract-fee-from.req)
:: ::         :: ?~  subtract-fee-from.req  ~
:: ::         :: o+(~(gas by *(map @t json)) u.subtract-fee-from.req)
:: ::         (ferm replaceable.req %b)
:: ::         (feud conf-target.req)
:: ::         (ferm estimate-mode.req %s)
:: ::     ==
:: ::   ::
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~[s+'' s+'']]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-set-hd-seed   ^-  tang
::     =/  op  %set-hd-seed
::     =/  action=request:btc-rpc  [op ~]
::     %+  expect-eq
::       !>  [op (method:btc-rpc:lib op) %list ~]
::       !>  (request-to-rpc:btc-rpc:lib action)
::   ::
:: ++  test-set-label     ^-  tang
::   =/  op  %set-label
::   =/  action=request:btc-rpc  [op address=*@t label=*@t]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~[s+'' s+'']]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-set-tx-fee    ^-  tang
::   =/  op  %set-tx-fee
::   =/  action=request:btc-rpc  [op amount=*@t]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list [s+'']~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-sign-message  ^-  tang
::   =/  op  %sign-message
::   =/  action=request:btc-rpc  [op address=*@t message=*@t]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~[s+'' s+'']]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-sign-raw-transaction-with-wallet  ^-  tang
::   =/  prev-txs   %-  some  %-  limo
::     :~  txid=*@t
::         vout=*@ud
::         script-pub-key=*@t
::         redeem-script=*@t
::         witness-script=*@t
::         amount=*@t
::      ==
::   =/  op  %sign-raw-transaction-with-wallet
::   =/  action=request:btc-rpc
::     :*  op
::         *@t
::         ~
::         `%'ALL'
::     ==
:: :: :*  ['txid' s+a.txid]
:: ::     ['vout' n+(scot %ud a.vout)]
:: ::     ['scriptPubKey' s+a.script-pub-key]
:: ::     ['redeem-Script' s+a.redeem-script]
:: ::     ['witnessScript' s+a.witness-script]
:: ::     ['amount' n+(scot %ta a.amount)]
:: :: ==
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~[s+'' s+'ALL']]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-unload-wallet  ^-  tang
::   =/  op  %unload-wallet
::   =/  action=request:btc-rpc
::     [op wallet-name=*(unit @t)]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: :: ++  test-wallet-create-fundedpsbt  ^-  tang
:: ::   =/  op  %wallet-create-fundedpsbt
:: ::   =/  inputs  %-  limo
:: ::   :*  txid=*@t
:: ::       vout=*@ud
:: ::       sequence=*@ud
:: ::   ==
:: ::   =/  action=request:btc-rpc
:: ::     :*  op
:: ::         $=  inputs  %-  list
:: ::         =/  action=request:btc-rpc
:: ::         :*  txid=*@t
:: ::             vout=*@ud
:: ::             sequence=*@ud
:: ::         ==
:: ::         ::  FIXME:
:: ::         ::  list of addressess and JUST one "data" key?
:: ::         ::
:: ::         outputs=(list (pair @t ?(@t @ud)))
:: ::         locktime=*(unit @ud)
:: ::         $=  options  %-  unit
:: ::         =/  action=request:btc-rpc  :*  change-address=*(unit @t)
:: ::             change-position=*(unit @ud)
:: ::             change-type=*(unit ?(%legacy %p2sh-segwit %bech32))
:: ::             include-watching=*(unit ?)
:: ::             lock-unspents=*(unit ?)
:: ::             fee-rate=*(unit @t)
:: ::             subtract-fee-from-outputs=*(unit (list @ud))
:: ::             replaceable=*(unit ?)
:: ::             conf-target=*(unit @t)
:: ::             =estimate-mode
:: ::         ==
:: ::         bip32derivs=*(unit ?)
:: ::     ==
:: :: ::     :~  a+inputs.req
:: :: ::         a+outputs.req
:: :: ::         n+(scot %ud locktime.req)
:: :: ::         (feob options.req)
:: :: ::         :: ?~  options.req  ~
:: :: ::         :: o+(~(gas by *(map @t json)) u.options.req)
:: :: ::         (ferm bip32derivs.req %b)
:: :: ::     ==
:: :: ::   ::
:: ::   %+  expect-eq
:: ::     !>  [op (method:btc-rpc:lib op) %list ~]
:: ::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-wallet-lock  ^-  tang
::   =/  op  %wallet-lock
::   =/  action=request:btc-rpc  [op ~]
::    %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-wallet-passphrase  ^-  tang
::   =/  op  %wallet-passphrase
::   =/  action=request:btc-rpc
::     [op passphrase=*@t timeout=*@ud]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~[s+'' n+(scot %ud *@ud)]]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-wallet-passphrase-change  ^-  tang
::   =/  op  %wallet-passphrase-change
::   =/  action=request:btc-rpc
::     :+  op
::     old-passphrase=*(unit @t)  new-passphrase=*(unit @t)
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-wallet-process-psbt  ^-  tang
::   =/  op  %wallet-process-psbt
::   =/  action=request:btc-rpc
::     :*  op
::         psbt=*@t
::         sign=*(unit ?)
::         sig-hash-type=`%'ALL'
::         bip32derivs=*(unit ?)
::     ==
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~[s+'' s+'ALL']]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::  ZMQ
:: ::
:: ++  test-get-zmq-notifications  ^-  tang
::     =/  op  %get-zmq-notifications
::     =/  action=request:btc-rpc  [op ~]
::     %+  expect-eq
::       !>  [op (method:btc-rpc:lib op) %list ~]
::       !>  (request-to-rpc:btc-rpc:lib action)
::
::  Utils
::
++  http-client-call
  |=  $:  http-client-gate=_http-client-gate
          now=@da
          scry=sley
          body=request:rpc:jstd
      ==
  ^-  (quip move:http-client-gate _http-client-gate)
  ::
  =/  http-client-core
    (http-client-gate our=~nul now=now eny=`@uvJ`0xdead.beef scry=scry)
  ::
  =/  req=request:http
    :*  %'POST'
        endpoint.app-state
        headers.app-state
        %-  some
          %-  as-octt:mimes:html
          (en-json:html (request-to-json:rpc:jstd body))
    ==
  =/  call-args=[=duct type=* wrapped-task=(hobo task:able:iris)]
    :*  duct=~[/~2000.1.1]  ~
        %request
        req
        *outbound-config:iris
    ==
  =^  moves  http-client-gate  (call:http-client-core call-args)
  ::
  [moves http-client-gate]
--

:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='158']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=158
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"abort-rescan"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='159']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=159
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"backup-wallet"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='154']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=154
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"bump-fee"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='111']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=111
::           q
::         \/'{"result":null,"error":{"code":-4,"message":"Wallet test-create-wal\/
::           let already exists."},"id":"create-wallet"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='158']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=158
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"dump-privkey"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='157']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=157
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"dump-wallet"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='160']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=160
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"encrypt-wallet"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='168']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=168
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"get-addresses-by-label"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='162']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=162
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"get-address-info"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='165']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=165
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"abandon-transaction"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='157']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=157
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"get-balance"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='161']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=161
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"get-new-address"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='168']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=168
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"get-raw-change-address"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='169']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=169
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"get-received-by-address"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='167']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=167
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"get-received-by-label"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='161']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=161
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"get-transaction"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='169']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=169
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"get-unconfirmed-balance"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='161']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=161
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"get-wallet-info"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='160']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=160
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"import-address"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='158']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=158
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"import-multi"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='160']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=160
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"import-privkey"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='165']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=165
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"import-pruned-funds"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='159']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=159
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"import-pubkey"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='159']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=159
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"import-wallet"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='161']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=161
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"key-pool-refill"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='168']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=168
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"list-address-groupings"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='157']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=157
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"list-labels"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='163']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=163
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"list-lock-unspent"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='170']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=170
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"list-received-by-address"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='168']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=168
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"list-received-by-label"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='162']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=162
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"lists-in-ceblock"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='163']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=163
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"list-transactions"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='158']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=158
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"list-unspent"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=200
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='70']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=70
::           q
::         \/'{"result":["","test-create-wallet"],"error":null,"id":"list-wallets\/
::           "}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='161']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=161
::           q
::         \/'{"result":null,"error":{"code":-4,"message":"Wallet file verificati\/
::           on failed: Error loading wallet . Duplicate -wallet filename specifi
::           ed."},"id":"load-wallet"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='158']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=158
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"lock-unspent"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='165']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=165
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"remove-pruned-funds"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='163']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=163
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"rescan-blockchain"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='155']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=155
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"send-many"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='161']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=161
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"send-to-address"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='157']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=157
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"set-hd-seed"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='155']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=155
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"set-label"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='156']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=156
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"set-tx-fee"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='158']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=158
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"sign-message"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='178']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=178
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"sign-raw-transaction-with-wallet"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='108']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=108
::           q
::         \/'{"result":null,"error":{"code":-1,"message":"JSON value is not a st\/
::           ring as expected"},"id":"unload-wallet"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='157']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=157
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"wallet-lock"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='163']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=163
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"wallet-passphrase"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='170']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=170
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"wallet-passphrase-change"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=500
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='165']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=165
::           q
::         \/'{"result":null,"error":{"code":-19,"message":"Wallet file not speci\/
::           fied (must request wallet RPC through /wallet/<filename> uri-path)."
::           },"id":"wallet-process-psbt"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=404
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='98']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=98
::           q
::         \/'{"result":null,"error":{"code":-32601,"message":"Method not found"}\/
::           ,"id":"get-zmq-notifications"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
:: [ %response
::   %finished
::     response-header
::   [ status-code=200
::       headers
::     ~[
::       [key='content-type' value='application/json']
::       [key='date' value='Thu, 17 Oct 2019 07:39:17 GMT']
::       [key='content-length' value='151']
::     ]
::   ]
::     full-file
::   [ ~
::     [ type='application/json'
::         data
::       [ p=151
::           q
::         \/'{"result":{"wallets":[{"name":"test-wallet-2"},{"name":""},{"name":\/
::           "test-wallet"},{"name":"test-create-wallet"}]},"error":null,"id":"li
::           st-wallet-dir"}\0a'
::         \/                                                                    \/
::       ]
::     ]
::   ]
:: ]
