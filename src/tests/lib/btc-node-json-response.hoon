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
:: ++  test-get-block-count  ^-  tang
::   =/  op  %get-block-count
::   =/  action=request:btc-rpc  [op ~]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
:: ++  test-get-blockchain-info  ^-  tang
::   =/  op  %get-blockchain-info
::   =/  action=request:btc-rpc  [op ~]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
::
::  Wallet
::
++  test-abandon-transaction  ^-  tang
  =/  op  %abandon-transaction
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
::
++  test-abort-rescan  ^-  tang
  =/  op  %abort-rescan
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
::
:: ++  test-add-multisig-address  ^-  tang
::   =/  op  %add-multisig-address
::   =/  action=request:btc-rpc  [op ~]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)

++  test-backup-wallet  ^-  tang
  =/  op  %backup-wallet
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
::
++  test-bump-fee  ^-  tang
  =/  op  %bump-fee
  =/  expected-res=response:btc-rpc
    [op txid='23' orig-fee='23' fee='23' errors=['23']~]
  ::  e.g:
  ::    {
  ::      "txid":    "value",   (string)
  ::      "origfee":  n,         (numeric)
  ::      "fee":      n,         (numeric)
  ::      "errors":  [ str... ] (json array of strings)
  ::    }
  =/  result=response:rpc:jstd
    :+  %result  id=op
    ^-  json
    :-  %o  %-  ~(gas by *(map @t json))
    ^-  (list (pair @t json))
    :~  ['txid' s+'23']
        ['origfee' n+~.23]
        ['fee' n+~.23]
        ['errors' a+[s+'23']~]
    ==
  %+  expect-eq
    !>  expected-res
    !>  (parse-response:btc-rpc:lib result)
::
++  test-create-wallet  ^-  tang
  =/  op  %create-wallet
  =/  expected-res=response:btc-rpc
    [op name='23' warning='']
  ::  e.g:
  ::    {
  ::      "name":    <wallet_name>,  (string)
  ::      "warning":  <warning>,     (string)
  ::    }
  =/  result=response:rpc:jstd
    :+  %result  id=op
    ^-  json
    :-  %o  %-  ~(gas by *(map @t json))
    ^-  (list (pair @t json))
    :~  ['name' s+'23']
        ['warning' s+'']
    ==
  %+  expect-eq
    !>  expected-res
    !>  (parse-response:btc-rpc:lib result)
::
++  test-dump-privkey  ^-  tang
  =/  op  %dump-privkey
  =/  result=response:rpc:jstd  [%result id=op s+'23']
  %+  expect-eq
    !>  [op '23']
    !>  (parse-response:btc-rpc:lib result)
::
++  test-dump-wallet  ^-  tang
  =/  op  %dump-wallet
  =/  expected-res=response:btc-rpc
    [op filename='23']
  ::  e.g:
  ::    {
  ::      "name":    <wallet_name>,  (string)
  ::      "warning":  <warning>,     (string)
  ::    }
  =/  result=response:rpc:jstd
    :+  %result  id=op
    ^-  json
    :-  %o  %-  ~(gas by *(map @t json))
    ^-  (list (pair @t json))
    ['filename' s+'23']~
  %+  expect-eq
    !>  expected-res
    !>  (parse-response:btc-rpc:lib result)
::
++  test-encrypt-wallet  ^-  tang
  =/  op  %encrypt-wallet
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
::
:: ++  test-get-addresses-by-label  ^-  tang
::   =/  op  %get-addresses-by-label
::   =/  addr  '1GdK9UzpHBzqzX2A9JFP3Di4weBwqgmoQA'
::   =/  expected-res=response:btc-rpc
::   [op [addr 'send']~]
::   ::  e.g:
::   ::   { (json object with addresses as keys)
::   ::     "address": { (json object with information about address)
::   ::       "purpose": "string" (string)  Purpose of address ("send" for sending address, "receive" for receiving address)
::   ::     },...
::   ::   }
::   =/  result=response:rpc:jstd
::     :+  %result  id=op
::     ^-  json
::     :-  %o  %-  ~(gas by *(map @t json))
::     ^-  (list (pair @t json))
::     :~  :-  addr
::         :-  %o  %-  ~(gas by *(map @t json))
::         ^-  (list (pair @t json))
::         ['purpose' s+'send']~
::     ==
::   %+  expect-eq
::     !>  expected-res
::     !>  (parse-response:btc-rpc:lib result)
::
:: ++  test-get-address-info  ^-  tang
::   =/  op  %get-address-info
::   =/  action=request:btc-rpc  [op address=*@t]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list [s+'']~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
++  test-get-balance  ^-  tang
  =/  op  %get-balance
  =/  result=response:rpc:jstd  [%result id=op s+'23']
  %+  expect-eq
    !>  [op '23']
    !>  (parse-response:btc-rpc:lib result)
::
++  test-get-new-address  ^-  tang
  =/  op  %get-new-address
  =/  result=response:rpc:jstd  [%result id=op s+'23']
  %+  expect-eq
    !>  [op '23']
    !>  (parse-response:btc-rpc:lib result)
::
++  test-get-raw-change-address  ^-  tang
  =/  op  %get-raw-change-address
  =/  result=response:rpc:jstd  [%result id=op s+'23']
  %+  expect-eq
    !>  [op '23']
    !>  (parse-response:btc-rpc:lib result)
::
++  test-get-received-by-address  ^-  tang
  =/  op  %get-received-by-address
  =/  result=response:rpc:jstd  [%result id=op s+'23']
  %+  expect-eq
    !>  [op '23']
    !>  (parse-response:btc-rpc:lib result)
::
++  test-get-received-by-label  ^-  tang
  =/  op  %get-received-by-label
  =/  result=response:rpc:jstd  [%result id=op s+'23']
  %+  expect-eq
    !>  [op '23']
    !>  (parse-response:btc-rpc:lib result)
::
:: ++  test-get-transaction  ^-  tang
::   =/  op  %get-transaction
::   =/  action  [op *@t *(unit ?)]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~[s+'']]
::     !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-get-unconfirmed-balance  ^-  tang
  =/  op  %get-unconfirmed-balance
  =/  result=response:rpc:jstd  [%result id=op s+'99']
  %+  expect-eq
    !>  [op '99']
    !>  (parse-response:btc-rpc:lib result)
::
:: ++  test-get-wallet-info  ^-  tang
::   =/  op  %get-wallet-info
::   =/  action=request:btc-rpc  [op ~]
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~]
::     !>  (request-to-rpc:btc-rpc:lib action)
:: ::
++  test-import-address  ^-  tang
  =/  op  %import-address
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
::
:: ++  test-import-multi  ^-  tang
::   =/  op  %import-multi
::   =/  result=response:rpc:jstd  [%result id=op ~]
::   %+  expect-eq
::     !>  [op ~]
::     !>  (parse-response:btc-rpc:lib result)
::
++  test-import-privkey  ^-  tang
  =/  op  %import-privkey
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
::
++  test-import-pruned-funds  ^-  tang
  =/  op  %import-pruned-funds
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
::
++  test-import-pubkey  ^-  tang
  =/  op  %import-pubkey
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
::
++  test-import-wallet  ^-  tang
  =/  op  %import-wallet
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
::
++  test-key-pool-refill  ^-  tang
  =/  op  %key-pool-refill
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
::
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
++  test-list-wallet-dir  ^-  tang
    =/  op  %list-wallet-dir
    =/  expected-res=response:btc-rpc
      [op [name='test-wallet']~]
    ::  e.g:
    ::    {  "wallets":
    ::       [  {"name":"test-wallet"}
    ::          ...
    ::       ]
    ::    }
    =/  result=response:rpc:jstd
      :+  %result  id=op
      ^-  json
      :-  %o  %-  ~(gas by *(map @t json))
      ^-  (list (pair @t json))
      :~  :-  'wallets'
          :-  %a  ^-  (list json)
          :~  o+(molt ['name' s+'test-wallet']~)
      ==  ==
    %+  expect-eq
      !>  expected-res
      !>  (parse-response:btc-rpc:lib result)
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
  =/  expected-res=response:btc-rpc
    [op name='23' warning='']
  ::  e.g:
  ::    {
  ::      "name":    <wallet_name>,  (string)
  ::      "warning":  <warning>,     (string)
  ::    }
  =/  result=response:rpc:jstd
    :+  %result  id=op
    ^-  json
    :-  %o  %-  ~(gas by *(map @t json))
    ^-  (list (pair @t json))
    :~  ['name' s+'23']
        ['warning' s+'']
    ==
  %+  expect-eq
    !>  expected-res
    !>  (parse-response:btc-rpc:lib result)
::
++  test-lock-unspent  ^-  tang
  =/  op  %lock-unspent
  =/  expected-res=response:btc-rpc  [op &]
  =/  result=response:rpc:jstd  [%result id=op b+&]
  %+  expect-eq
    !>  expected-res
    !>  (parse-response:btc-rpc:lib result)
::
++  test-remove-pruned-funds  ^-  tang
  =/  op  %remove-pruned-funds
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
::
++  test-rescan-blockchain  ^-  tang
  =/  op  %rescan-blockchain
  =/  expected-res=response:btc-rpc
    [op start-height=20 stop-height=30]
  ::  e.g:
  ::    {
  ::      "name":    <wallet_name>,  (string)
  ::      "warning":  <warning>,     (string)
  ::    }
  =/  result=response:rpc:jstd
    :+  %result  id=op
    ^-  json
    :-  %o  %-  ~(gas by *(map @t json))
    ^-  (list (pair @t json))
    :~  ['start_height' n+~.20]
        ['stop_height' n+~.30]
    ==
  %+  expect-eq
    !>  expected-res
    !>  (parse-response:btc-rpc:lib result)
::
++  test-send-many  ^-  tang
  =/  op  %send-many
  =/  result=response:rpc:jstd  [%result id=op s+'99']
  %+  expect-eq
    !>  [op '99']
    !>  (parse-response:btc-rpc:lib result)
::
++  test-send-to-address  ^-  tang
  =/  op  %send-to-address
  =/  result=response:rpc:jstd  [%result id=op s+'99']
  %+  expect-eq
    !>  [op '99']
    !>  (parse-response:btc-rpc:lib result)
::
++  test-set-hd-seed  ^-  tang
  =/  op  %set-hd-seed
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
::
++  test-set-label  ^-  tang
  =/  op  %set-label
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
::
++  test-set-tx-fee    ^-  tang
  =/  op  %set-tx-fee
  =/  result=response:rpc:jstd  [%result id=op b+&]
  %+  expect-eq
    !>  [op &]
    !>  (parse-response:btc-rpc:lib result)
::
++  test-sign-message  ^-  tang
  =/  op  %sign-message
  =/  result=response:rpc:jstd  [%result id=op s+'99']
  %+  expect-eq
    !>  [op '99']
    !>  (parse-response:btc-rpc:lib result)
::
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
::   :: :*  ['txid' s+a.txid]
::   ::     ['vout' n+(scot %ud a.vout)]
::   ::     ['scriptPubKey' s+a.script-pub-key]
::   ::     ['redeem-Script' s+a.redeem-script]
::   ::     ['witnessScript' s+a.witness-script]
::   ::     ['amount' n+(scot %ta a.amount)]
::   :: ==
::   %+  expect-eq
::     !>  [op (method:btc-rpc:lib op) %list ~[s+'' s+'ALL']]
::     !>  (request-to-rpc:btc-rpc:lib action)
::
++  test-unload-wallet  ^-  tang
  =/  op  %unload-wallet
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
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
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
::
++  test-wallet-passphrase  ^-  tang
  =/  op  %wallet-passphrase
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
::
++  test-wallet-passphrase-change  ^-  tang
  =/  op  %wallet-passphrase-change
  =/  result=response:rpc:jstd  [%result id=op ~]
  %+  expect-eq
    !>  [op ~]
    !>  (parse-response:btc-rpc:lib result)
::
++  test-wallet-process-psbt  ^-  tang
  =/  op  %wallet-process-psbt
  =/  expected-res=response:btc-rpc
    [op psbt='99' complete=&]
  ::  e.g:
  :: {
  ::   "psbt" : "value",          (string) The base64-encoded
  ::   "complete" : true|false,   (boolean)
  :: }
  =/  result=response:rpc:jstd
    :+  %result  id=op
    ^-  json
    :-  %o  %-  ~(gas by *(map @t json))
    ^-  (list (pair @t json))
    :~  ['psbt' s+'99']
        ['complete' b+&]
    ==
  %+  expect-eq
    !>  expected-res
    !>  (parse-response:btc-rpc:lib result)
::
:: ::  ZMQ
:: ::
:: ++  test-get-zmq-notifications  ^-  tang
::     =/  op  %get-zmq-notifications
::     =/  action=request:btc-rpc  [op ~]
::     %+  expect-eq
::       !>  [op (method:btc-rpc:lib op) %list ~]
::       !>  (request-to-rpc:btc-rpc:lib action)
::
--
