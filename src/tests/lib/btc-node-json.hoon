/-  *btc-node-hook
/+  *test, lib=btc-node-json
::

::
/=  app  /:  /===/app/btc-node-hook
             /!noun/
::
:: =,  btc-rpc
::
|%
::  Others
::
++  test-get-block-count  ^-  tang
  =/  op  %get-block-count
  =/  action=request:btc-rpc  [op ~]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-get-blockchain-info  ^-  tang
  =/  op  %get-blockchain-info
  =/  action=request:btc-rpc  [op ~]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
::  Wallet
::
++  test-abandon-transaction  ^-  tang
  =/  op  %abandon-transaction
  =/  action=request:btc-rpc  [op 'XXXX']
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [s+'XXXX']~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-abort-rescan  ^-  tang
  =/  op  %abort-rescan
  =/  action=request:btc-rpc  [op ~]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
:: ++  test-add-multisig-address  ^-  tang
::   =/  op  %add-multisig-address
::   =/  action=request:btc-rpc  [op ~]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-backup-wallet  ^-  tang
  =/  op  %backup-wallet
  =/  action=request:btc-rpc  [op 'XXXX']
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [s+'XXXX']~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-bump-fee  ^-  tang
  =/  op  %bump-fee
  ;:  weld
    =/  action=request:btc-rpc  [op 'XXXX' ~]
    %+  expect-eq
      !>  [op (method:btc-rpc:lib op) %list ~[s+'XXXX' ~]]
      !>  (request-to-rpc:btc-rpc:lib action)
  ::
    =/  action=request:btc-rpc
      [op 'XXXX' `[`'23' `'23' `& `%'ECONOMICAL']]
    %+  expect-eq
      !>  :^  op   (method:btc-rpc:lib op)  %list
          :~  s+'XXXX'
              ^-  json
              :-  %o  %-  ~(gas by *(map @t json))
              ^-  (list (pair @t json))
              :~  ['confTarget' s+'23']
                  ['totalFee' s+'23']
                  ['replaceable' b+&]
                  ['estimate_mode' s+'ECONOMICAL']
          ==  ==
      !>  (request-to-rpc:btc-rpc:lib action)
  ==
::
::  Creates and loads a new wallet.
::
++  test-create-wallet  ^-  tang
  =/  op  %create-wallet
  =/  action=request:btc-rpc
    [op name='test-create-wallet' disable-private-keys=`| blank=`|]
    %+  expect-eq
      !>  :^  op   (method:btc-rpc:lib op)  %list
          ~[s+'test-create-wallet' b+| b+|]
      !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-dump-privkey  ^-  tang
  =/  op  %dump-privkey
  =/  action=request:btc-rpc  [op address=*@t]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [s+'']~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-dump-wallet  ^-  tang
  =/  op  %dump-wallet
  =/  action=request:btc-rpc  [op filename=*@t]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [s+'']~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-encrypt-wallet  ^-  tang
  =/  op  %encrypt-wallet
  =/  action=request:btc-rpc  [op passphrase=*@t]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [s+'']~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-get-addresses-by-label  ^-  tang
  =/  op  %get-addresses-by-label
  =/  action=request:btc-rpc  [op label=*@t]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [s+'']~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-get-address-info  ^-  tang
  =/  op  %get-address-info
  =/  action=request:btc-rpc  [op address=*@t]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [s+'']~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-get-balance  ^-  tang
  =/  op  %get-balance
  =/  action=request:btc-rpc
    [op dummy=*(unit @t) minconf=*(unit @ud) include-watch-only=*(unit ?)]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-get-new-address  ^-  tang
  =/  op  %get-new-address
  =/  action=request:btc-rpc
    [op label=*(unit @t) address-type=*(unit @t)]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-get-raw-change-address  ^-  tang
  =/  op  %get-raw-change-address
  =/  action=request:btc-rpc
    [op address-type=*(unit @t)]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-get-received-by-address  ^-  tang
  =/  op  %get-received-by-address
  =/  action=request:btc-rpc
    [op address=*@t minconf=*@ud]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~[s+'' s+'']]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-get-received-by-label  ^-  tang
  =/  op  %get-received-by-label
  =/  action=request:btc-rpc  [op *@t ~]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~[s+'']]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-get-transaction  ^-  tang
  =/  op  %get-transaction
  =/  action  [op *@t *(unit ?)]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~[s+'']]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-get-unconfirmed-balance  ^-  tang
  =/  op  %get-unconfirmed-balance
  =/  action=request:btc-rpc  [op ~]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-get-wallet-info  ^-  tang
  =/  op  %get-wallet-info
  =/  action=request:btc-rpc  [op ~]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-import-address  ^-  tang
  =/  action=request:btc-rpc
    [%import-address address=*@t label=*(unit @t) rescan=*(unit ?) p2sh=*(unit ?)]
  %+  expect-eq
    !>  &
    !>  |
::
++  test-import-multi  ^-  tang
  =/  action=request:btc-rpc  [%import-multi requests=~ options=~]
    :: :+  %import-multi
    :: :~  desc=*@t
    ::     script-pub-key=*@t
    ::     timestamp=*?(@da %'now')
    ::     redeem-script=*@t
    ::     witness-script=*@t
    ::     pubkeys=*(unit (list @t))
    ::     keys=*(unit (list @t))
    ::     range=*?(@ [@ @])
    ::     internal=*?
    ::     watchonly=*?
    ::     label=*@t
    ::     keypool=*?
    :: ==
  %+  expect-eq
    !>  &
    !>  |
::
++  test-import-privkey  ^-  tang
  =/  action=request:btc-rpc
    [%import-privkey privkey=*@t label=*(unit @t) rescan=*(unit ?)]
  %+  expect-eq
    !>  &
    !>  |
++  test-import-pruned-funds  ^-  tang
  =/  action=request:btc-rpc
    [%import-pruned-funds raw-transaction=*@t tx-out-proof=*@t]
  %+  expect-eq
    !>  &
    !>  |
::
++  test-import-pubkey  ^-  tang
  =/  action=request:btc-rpc
    [%import-pubkey pubkey=*@t label=*(unit @t) rescan=*(unit ?)]
  %+  expect-eq
    !>  &
    !>  |
::
++  test-import-wallet  ^-  tang
  =/  action=request:btc-rpc  [%import-wallet filename=*@t]
::     ~[s+filename.req]
::   ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-key-pool-refill  ^-  tang
  =/  action=request:btc-rpc  [%key-pool-refill new-size=*(unit @ud)]
::     ~[(feud new-size.req)]
::   ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-list-address-groupings  ^-  tang
  =/  op  %list-address-groupings
  =/  action=request:btc-rpc  [op ~]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-list-labels  ^-  tang

  =/  action=request:btc-rpc  [%list-labels purpose=*(unit @t)]

::     ~[(ferm purpose.req %s)]
::   ::
  %+  expect-eq
    !>  &
    !>  |
++  test-list-lock-unspent  ^-  tang
  =/  op  %list-lock-unspent
  =/  action=request:btc-rpc  [op ~]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-list-received-by-address  ^-  tang
  =/  op  %list-received-by-address
  =/  action=request:btc-rpc
    :*  op
        minconf=*(unit @ud)
        include-empty=*(unit ?)
        include-watch-only=*(unit ?)
        address-filter=*(unit @t)
    ==
::     :~  (feud minconf.req)
::         (ferm include-empty.req %b)
::         (ferm include-watch-only.req %b)
::         (ferm address-filter.req %s)
::     ==
  %+  expect-eq
    !>  &
    !>  |
++  test-list-received-by-label  ^-  tang
  =/  op  %list-received-by-label
  =/  action=request:btc-rpc
    :*  op
        minconf=*(unit @ud)
        include-empty=*(unit ?)
        include-watch-only=*(unit ?)
    ==
::     :~  (feud minconf.req)
::         (ferm include-empty.req %b)
::         (ferm include-watch-only.req %b)
::     ==
  %+  expect-eq
    !>  &
    !>  |
::
++  test-lists-in-ceblock  ^-  tang
  =/  op  %lists-in-ceblock
  =/  action=request:btc-rpc
    :*  op
        blockhash=*(unit @t)
        target-confirmations=*(unit @ud)
        include-watch-only=*(unit ?)
        include-removed=*(unit ?)
    ==
::     :~  (ferm blockhash.req %s)
::         (feud target-confirmations.req)
::         (ferm include-watch-only.req %b)
::         (ferm include-removed.req %b)
::     ==
  %+  expect-eq
    !>  &
    !>  |
::
++  test-list-transactions  ^-  tang
  =/  op  %list-transactions
  =/  action=request:btc-rpc
    :*  op
        label=*(unit @t)
        count=*(unit @ud)
        skip=*(unit @ud)
        include-watch-only=*(unit ?)
    ==
::     :~  (ferm label.req %s)
::         (feud count.req)
::         (feud skip.req)
::         (ferm include-watch-only.req %b)
::     ==
  %+  expect-eq
    !>  &
    !>  |
::
++  test-list-unspent  ^-  tang
  =/  query-options  %-  some
  :*  minimum-amount=*(unit @t)
      maximum-amount=*(unit @t)
      maximum-count=*(unit @t)
      minimum-sum-amount=*(unit @t)
  ==
  =/  op  %list-unspent
  =/  action=request:btc-rpc
    :*  op
        minconf=*(unit @t)
        maxconf=*(unit @ud)
        addresses=*(unit (list @t))
        include-unsafe=*(unit ?)
        query-options=query-options
    ==
::     :~  (ferm minconf.req %s)
::         (feud maxconf.req)
::         (ferm addresses.req %a)
::         (ferm include-unsafe.req %b)
::         (feob query-options.req)
::         :: ?~  query-options  ~
::         :: o+(~(gas by *(map @t json)) u.query-options.req)
::     ==
  %+  expect-eq
    !>  &
    !>  |
::
++  test-list-wallet-dir  ^-  tang
    =/  op  %list-wallet-dir
    =/  action=request:btc-rpc  [op ~]
    %+  expect-eq
      !>  [op (method:btc-rpc:lib op) %list ~]
      !>  (request-to-rpc:btc-rpc:lib action)
  ::
++  test-list-wallets     ^-  tang
    =/  op  %list-wallets
    =/  action=request:btc-rpc  [op ~]
    %+  expect-eq
      !>  [op (method:btc-rpc:lib op) %list ~]
      !>  (request-to-rpc:btc-rpc:lib action)
  ::
++  test-load-wallet      ^-  tang
  =/  action=request:btc-rpc  [%load-wallet filename=*@t]
::     ~[s+filename.req]
::   ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-lock-unspent  ^-  tang
  =/  action=request:btc-rpc
    [%lock-unspent unlock=*? transactions=*(unit (list [txid=@t vout=@]))]

::     :~  b+unlock.req
::         ?~  transactions.req  ~
::         o+(~(gas by *(map @t json)) u.transactions.req)
::     ==
::   ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-remove-pruned-funds  ^-  tang
  =/  action=request:btc-rpc  [%remove-pruned-funds txid=*@t]

::     ~[s+txid.req]
::   ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-rescan-blockchain  ^-  tang
  =/  action=request:btc-rpc
    [%rescan-blockchain start-height=*(unit @ud) stop-height=*(unit @ud)]

::     :~  (feud start-height.req)
::         (feud stop-height.req)
::     ==
::   ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-send-many  ^-  tang
  =/  op  %send-many
  =/  action=request:btc-rpc
    :*  op
        dummy=%''
        amounts=~
        minconf=*(unit @ud)
        comment=*(unit @t)
        subtract-fee-from=*(unit (list address))
        conf-target=*(unit @ud)
        estimate-mode=*(unit @t)
    ==
::     :~  s+dummy.req
::         (feob (some amounts.req))
::         (feud minconf.req)
::         (ferm comment.req %t)
::         (feob subtract-fee-from.req)
::         :: ?~  subtract-fee-from.req  ~
::         :: o+(~(gas by *(map @t json)) u.subtract-fee-from.req)
::         (feud conf-target.req)
::         (ferm estimate-mode.req %s)
::     ==
::   ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-send-to-address  ^-  tang
  =/  op  %send-to-address
  =/  action=request:btc-rpc
    :*  op
        address=*@t
        amount=*@t
        comment=*(unit @t)
        comment-to=*(unit @t)
        subtract-fee-from=*(unit (list address))
        replaceable=*(unit ?)
        conf-target=*(unit @ud)
        estimate-mode=*(unit @t)
    ==
::     :~  s+address.req
::         s+amount.req
::         (ferm comment.req %s)
::         (ferm comment-to.req %s)
::         (feob subtract-fee-from.req)
::         :: ?~  subtract-fee-from.req  ~
::         :: o+(~(gas by *(map @t json)) u.subtract-fee-from.req)
::         (ferm replaceable.req %b)
::         (feud conf-target.req)
::         (ferm estimate-mode.req %s)
::     ==
::   ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-set-hd-seed   ^-  tang
    =/  op  %set-hd-seed
    =/  action=request:btc-rpc  [op ~]
    %+  expect-eq
      !>  [op (method:btc-rpc:lib op) %list ~]
      !>  (request-to-rpc:btc-rpc:lib action)
  ::
++  test-set-label     ^-  tang
  =/  action=request:btc-rpc  [%set-label address=*@t label=*@t]
::     :~  s+address.req
::         s+label.req
::     ==
::   ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-set-tx-fee    ^-  tang
  =/  action=request:btc-rpc  [%set-tx-fee amount=*@t]
::     ~[s+amount.req]
::   ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-sign-message  ^-  tang
  =/  action=request:btc-rpc  [%sign-message address=*@t message=*@t]
::     :~  s+address.req
::         s+message.req
::     ==
::   ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-sign-raw-transaction-with-wallet  ^-  tang
  =/  prev-txs   %-  limo
    :~  txid=*@t
        vout=*@ud
        script-pub-key=*@t
        redeem-script=*@t
        witness-script=*@t
        amount=*?(@ud @t)
     ==
  =/  op  %sign-raw-transaction-with-wallet
  =/  action=request:btc-rpc
    :*  op
        *@ux
        ~
        `%'ALL'
    ==
::     :~  s+hex-string.req
::         (feob prev-txs.req)
::         :: ?~  prev-txs.req  ~
::         :: o+(~(gas by *(map @t json)) u.prev-txs.req)
::     ==
::   ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-unload-wallet  ^-  tang
    =/  action=request:btc-rpc
      [%unload-wallet wallet-name=*(unit @t)]
::     ~[s+wallet-name.req]
::   ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-wallet-create-fundedpsbt  ^-  tang
  :: =/  action=request:btc-rpc
  ::   :*  %wallet-create-fundedpsbt
  ::       $=  inputs  %-  list
  ::       =/  action=request:btc-rpc  :*  txid=*@t
  ::           vout=*@ud
  ::           sequence=*@ud
  ::       ==
  ::       ::  FIXME:
  ::       ::  list of addressess and JUST one "data" key?
  ::       ::
  ::       outputs=(list (pair @t ?(@t @ud)))
  ::       locktime=*(unit @ud)
  ::       $=  options  %-  unit
  ::       =/  action=request:btc-rpc  :*  change-address=*(unit @t)
  ::           change-position=*(unit @ud)
  ::           change-type=*(unit ?(%legacy %p2sh-segwit %bech32))
  ::           include-watching=*(unit ?)
  ::           lock-unspents=*(unit ?)
  ::           fee-rate=*(unit @t)
  ::           subtract-fee-from-outputs=*(unit (list @ud))
  ::           replaceable=*(unit ?)
  ::           conf-target=*(unit @t)
  ::           =estimate-mode
  ::       ==
  ::       bip32derivs=*(unit ?)
  ::   ==
::     :~  a+inputs.req
::         a+outputs.req
::         n+(scot %ud locktime.req)
::         (feob options.req)
::         :: ?~  options.req  ~
::         :: o+(~(gas by *(map @t json)) u.options.req)
::         (ferm bip32derivs.req %b)
::     ==
::   ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-wallet-lock  ^-  tang
  =/  op  %wallet-lock
  =/  action=request:btc-rpc  [op ~]
   %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-wallet-passphrase  ^-  tang
  =/  action=request:btc-rpc
    [%wallet-passphrase passphrase=*@t timeout=*@ud]

::     ~[s+passphrase.req s+timeout.req]
::   ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-wallet-passphrase-change  ^-  tang
  =/  action=request:btc-rpc
    [%wallet-passphrase-change old-passphrase=*(unit @t) new-passphrase=*(unit @t)]

::     :~  (ferm old-passphrase.req %s)
::         (feud new-passphrase.req)
::     ==
::   ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-wallet-process-psbt  ^-  tang
  =/  op  %wallet-process-psbt
  =/  action=request:btc-rpc
    :*  op
        psbt=*@t
        sign=*(unit ?)
        sig-hash-type=`%'ALL'
        bip32derivs=*(unit ?)
    ==
::     :~  s+psbt.req
::         (ferm sign.req %b)
::         (ferm sig-hash-type.req %s)
::     ==
:: ::  ZMQ
:: ::
  %+  expect-eq
    !>  &
    !>  |
::
++  test-get-zmq-notifications  ^-  tang
    =/  op  %get-zmq-notifications
    =/  action=request:btc-rpc  [op ~]
    %+  expect-eq
      !>  [op (method:btc-rpc:lib op) %list ~]
      !>  (request-to-rpc:btc-rpc:lib action)
  ::
--
