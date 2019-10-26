/-  *btc-node-hook
/+  *test, lib=btc-node-json
::
=/  addr     '1GdK9UzpHBzqzX2A9JFP3Di4weBwqgmoQA'
=/  en-addr=@uc  (to-base58:btc-rpc:lib addr)
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
      !>  [op (method:btc-rpc:lib op) %list [s+'XXXX']~]
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
  =/  action=request:btc-rpc  [op en-addr]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [s+addr]~]
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
  =/  action=request:btc-rpc  [op en-addr]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [s+addr]~]
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
    [op en-addr minconf=*@ud]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~[s+addr n+(scot %ud *@ud)]]
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
  =/  op  %import-address
  =/  action=request:btc-rpc
    [op en-addr label=*(unit @t) rescan=*(unit ?) p2sh=*(unit ?)]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [s+addr]~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-import-multi  ^-  tang
  =/  op  %import-multi
  =/  action=request:btc-rpc  [op requests=~ options=~]
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
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-import-privkey  ^-  tang
  =/  op  %import-privkey
  =/  action=request:btc-rpc
    [op privkey=*@t label=*(unit @t) rescan=*(unit ?)]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [s+'']~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-import-pruned-funds  ^-  tang
  =/  op  %import-pruned-funds
  =/  action=request:btc-rpc
    [op raw-transaction=*@t tx-out-proof=*@t]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~[s+'' s+'']]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-import-pubkey  ^-  tang
  =/  op  %import-pubkey
  =/  action=request:btc-rpc
    [op pubkey=*@t label=*(unit @t) rescan=*(unit ?)]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [s+'']~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-import-wallet  ^-  tang
  =/  op  %import-wallet
  =/  action=request:btc-rpc  [op filename=*@t]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [s+'']~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-key-pool-refill  ^-  tang
  =/  op  %key-pool-refill
  =/  action=request:btc-rpc  [op new-size=*(unit @ud)]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-list-address-groupings  ^-  tang
  =/  op  %list-address-groupings
  =/  action=request:btc-rpc  [op ~]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-list-labels  ^-  tang
  =/  op  %list-labels
  =/  action=request:btc-rpc  [op purpose=*(unit @t)]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
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
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-list-received-by-label  ^-  tang
  =/  op  %list-received-by-label
  =/  action=request:btc-rpc
    :*  op
        minconf=*(unit @ud)
        include-empty=*(unit ?)
        include-watch-only=*(unit ?)
    ==
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
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
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
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
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-list-unspent  ^-  tang
  =/  query-options  %-  some
  :*  minimum-amount=*(unit @t)  ::  n+(scot %ta minimun-amount)
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
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
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
  =/  op  %load-wallet
  =/  action=request:btc-rpc  [op filename=*@t]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [s+'']~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-lock-unspent  ^-  tang
  =/  op  %lock-unspent
  =/  action=request:btc-rpc
    [op unlock=*? transactions=*(unit (list [txid=@t vout=@ud]))]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [b+&]~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-remove-pruned-funds  ^-  tang
  =/  op  %remove-pruned-funds
  =/  action=request:btc-rpc  [op txid=*@t]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [s+'']~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-rescan-blockchain  ^-  tang
  =/  op  %rescan-blockchain
  =/  action=request:btc-rpc
    [op start-height=*(unit @ud) stop-height=*(unit @ud)]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-send-many  ^-  tang
  =/  op  %send-many
  =/  action=request:btc-rpc
    :*  op
        dummy=%''
        amounts=~
        minconf=*(unit @ud)
        comment=*(unit @t)
        subtract-fee-from=*(unit (list @t))
        :: subtract-fee-from=*(unit (list address))
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
    !>  [op (method:btc-rpc:lib op) %list [s+'']~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-send-to-address  ^-  tang
  =/  op  %send-to-address
  =/  action=request:btc-rpc
    :*  op
        en-addr
        amount=*@t
        comment=*(unit @t)
        comment-to=*(unit @t)
        subtract-fee-from=*(unit (list @t))
        :: subtract-fee-from=*(unit (list address))
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
    !>  [op (method:btc-rpc:lib op) %list ~[s+addr s+'']]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-set-hd-seed   ^-  tang
    =/  op  %set-hd-seed
    =/  action=request:btc-rpc  [op ~]
    %+  expect-eq
      !>  [op (method:btc-rpc:lib op) %list ~]
      !>  (request-to-rpc:btc-rpc:lib action)
  ::
++  test-set-label     ^-  tang
  =/  op  %set-label
  =/  action=request:btc-rpc  [op en-addr label=*@t]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~[s+addr s+'']]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-set-tx-fee    ^-  tang
  =/  op  %set-tx-fee
  =/  action=request:btc-rpc  [op amount=*@t]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list [s+'']~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-sign-message  ^-  tang
  =/  op  %sign-message
  =/  action=request:btc-rpc  [op en-addr message=*@t]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~[s+addr s+'']]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-sign-raw-transaction-with-wallet  ^-  tang
  =/  prev-txs   %-  some  %-  limo
    :~  txid=*@t
        vout=*@ud
        script-pub-key=*@t
        redeem-script=*@t
        witness-script=*@t
        amount=*@t
     ==
  =/  op  %sign-raw-transaction-with-wallet
  =/  action=request:btc-rpc
    :*  op
        *@t
        ~
        `%'ALL'
    ==
  :: :*  ['txid' s+a.txid]
  ::     ['vout' n+(scot %ud a.vout)]
  ::     ['scriptPubKey' s+a.script-pub-key]
  ::     ['redeemScript' s+a.redeem-script]
  ::     ['witnessScript' s+a.witness-script]
  ::     ['amount' n+(scot %ta a.amount)]
  :: ==
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~[s+'' s+'ALL']]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-unload-wallet  ^-  tang
  =/  op  %unload-wallet
  =/  action=request:btc-rpc
    [op wallet-name=*(unit @t)]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
:: ++  test-wallet-create-fundedpsbt  ^-  tang
::   =/  op  %wallet-create-fundedpsbt
::   =/  inputs  %-  limo
::   :*  txid=*@t
::       vout=*@ud
::       sequence=*@ud
::   ==
::   =/  action=request:btc-rpc
::     :*  op
::         $=  inputs  %-  list
::         =/  action=request:btc-rpc
::         :*  txid=*@t
::             vout=*@ud
::             sequence=*@ud
::         ==
::         ::  FIXME:
::         ::  list of addressess and JUST one "data" key?
::         ::
::         outputs=(list (pair @t ?(@t @ud)))
::         locktime=*(unit @ud)
::         $=  options  %-  unit
::         =/  action=request:btc-rpc  :*  change-address=*(unit @t)
::             change-position=*(unit @ud)
::             change-type=*(unit ?(%legacy %p2sh-segwit %bech32))
::             include-watching=*(unit ?)
::             lock-unspents=*(unit ?)
::             fee-rate=*(unit @t)
::             subtract-fee-from-outputs=*(unit (list @ud))
::             replaceable=*(unit ?)
::             conf-target=*(unit @t)
::             =estimate-mode
::         ==
::         bip32derivs=*(unit ?)
::     ==
:: ::     :~  a+inputs.req
:: ::         a+outputs.req
:: ::         n+(scot %ud locktime.req)
:: ::         (feob options.req)
:: ::         :: ?~  options.req  ~
:: ::         :: o+(~(gas by *(map @t json)) u.options.req)
:: ::         (ferm bip32derivs.req %b)
:: ::     ==
:: ::   ::
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-wallet-lock  ^-  tang
  =/  op  %wallet-lock
  =/  action=request:btc-rpc  [op ~]
   %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-wallet-passphrase  ^-  tang
  =/  op  %wallet-passphrase
  =/  action=request:btc-rpc
    [op passphrase=*@t timeout=*@ud]
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~[s+'' n+(scot %ud *@ud)]]
    !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-wallet-passphrase-change  ^-  tang
  =/  op  %wallet-passphrase-change
  =/  action=request:btc-rpc
    :+  op
    old-passphrase=*(unit @t)  new-passphrase=*(unit @t)
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
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
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~[s+'' s+'ALL']]
    !>  (request-to-rpc:btc-rpc:lib action)
::  ZMQ
::
++  test-get-zmq-notifications  ^-  tang
    =/  op  %get-zmq-notifications
    =/  action=request:btc-rpc  [op ~]
    %+  expect-eq
      !>  [op (method:btc-rpc:lib op) %list ~]
      !>  (request-to-rpc:btc-rpc:lib action)
::
--
