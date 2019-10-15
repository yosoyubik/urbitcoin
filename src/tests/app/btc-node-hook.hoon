/-  *btc-node-hook
/+  *test, lib=btc-node-json
::
:: =,  btc-rpc
::
/=  app  /:  /===/app/btc-node-hook
             /!noun/
::
|%
::  Others
::
++  test-get-blockchain-info  ^-  tang
  =/  op  %get-blockchain-info
  =/  action=btc-node-hook-action:lib  [op ~]

  :: ~&  moves
  %+  expect-eq
    !>  &
    !>  |
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
  ~&  call
  %+  expect-eq
    !>  &
    !>  |
  :: :~  ^-  json  s+txid.req
  ::     ^-  json
  ::     ?~  options.req  ~
  ::     =*  opts  u.options.req
  ::     :-  %o  %-  ~(gas by *(map @t json))
  ::     ^-  (list (pair @t json))
  ::     =-  (murn - same)
  ::     ^-  (list (unit (pair @t json)))
  ::     :~  ?~  conf-target.opts  ~
  ::         :: ^-  (pair @t json)
  ::         `['confTarget' s+u.conf-target.opts]
  ::       ::
  ::         ?~  total-fee.opts  ~
  ::         :: ^-  (pair @t json)
  ::         `['totalFee' s+u.total-fee.opts]
  ::       ::
  ::         ?~  replaceable.opts  ~
  ::         :: ^-  (pair @t json)
  ::         `['replaceable' b+u.replaceable.opts]
  ::       ::
  ::         ?~  estimate-mode.opts  ~
  ::         :: ^-  (pair @t json)
  ::         `['estimate_mode' s+u.estimate-mode.opts]
  ::     ==
  ::     :: ^-  json  ::(feob options.req)
  ::     :: ?~  options.req  ~
  ::     :: =*  opts  u.options.req
  ::     :: :-  %o
  ::     :: %-  limo
  ::     ::   :~
  ::     ::
  ::     :: (~(gas by *(map) (limo opts^~))
  ::     :: (at:dejs-soft
  :: ==
::
  ::  Creates and loads a new wallet.
  ::
::       %create-wallet  ^-  tang
::     :~  ^-  json  s+name.req
::         ^-  json  (ferm disable-private-keys.req %b)
::         ^-  json  (ferm blank.req %b)
::     ==
::   ::
::       %dump-privkey  ^-  tang
::     ~[s+address.req]
::   ::
::       %dump-wallet  ^-  tang
::     ~[s+filename.req]
::   ::
::       %encrypt-wallet  ^-  tang
::     ~[s+passphrase.req]
::   ::
::       %get-addresses-by-label  ^-  tang
::     ~[s+label.req]
::   ::
::       %get-address-info  ^-  tang
::     ~[s+address.req]
::   ::
::       %get-balance  ^-  tang
::     :~  ^-  json  (ferm dummy.req %s)
::         ^-  json  (feud minconf.req)
::         ^-  json  (ferm include-watchonly.req %b)
::     ==
::   ::
::       %get-new-address  ^-  tang
::     :~  (ferm label.req %s)
::         (ferm address-type.req %s)
::     ==
::   ::
::       %get-raw-change-address  ^-  tang
::     ~[(ferm address-type.req %s)]
::   ::
::       %get-received-by-address  ^-  tang
::     ~[s+address.req n+(scot %ud minconf.req)]
::   ::
::       %get-received-by-label  ^-  tang
::     ~
::   ::
::       %get-transaction  ^-  tang
::     ~
::   ::
::       %get-unconfirmed-balance  ^-  tang
::     ~
::   ::
::       ::  FIXME: add rest of parameters
::       ::
::     ::   %get-wallet-info  ^-  tang
::     :: ~
::   ::
::       %import-address  ^-  tang
::     :~  s+address.req
::         (ferm label.req %s)
::         (ferm rescan.req %b)
::         (ferm p2sh.req %b)
::     ==
::   ::
::       %import-multi
::     :~  l+requests.req
::         (feob options.req)
::     ==
::   ::
::       %import-privkey  ^-  tang
::     :~  s+privkey.req
::         (ferm label.req %s)
::         (ferm rescan.req %b)
::     ==
::   ::
::       %import-pruned-funds  ^-  tang
::     :~  s+raw-transaction.req
::         s+tx-out-proof.req
::     ==
::   ::
::       %import-pubkey  ^-  tang
::     :~  s+pubkey.req
::         (ferm label.req %s)
::         (ferm rescan.req %b)
::     ==
::   ::
::       %import-wallet
::     ~[s+filename.req]
::   ::
::       %key-pool-refill  ^-  tang
::     ~[(feud new-size.req)]
::   ::
::       %list-address-groupings  ^-  tang
::     ~
::   ::
::       %list-labels  ^-  tang
::     ~[(ferm purpose.req %s)]
::   ::
::       %list-lock-unspent  ^-  tang
::     ~
::   ::
::       %list-received-by-address  ^-  tang
::     :~  (feud minconf.req)
::         (ferm include-empty.req %b)
::         (ferm include-watchonly.req %b)
::         (ferm address-filter.req %s)
::     ==
::       %list-received-by-label  ^-  tang
::     :~  (feud minconf.req)
::         (ferm include-empty.req %b)
::         (ferm include-watchonly.req %b)
::     ==
::       %lists-in-ceblock  ^-  tang
::     :~  (ferm blockhash.req %s)
::         (feud target-confirmations.req)
::         (ferm include-watchonly.req %b)
::         (ferm include-removed.req %b)
::     ==
::       %list-transactions  ^-  tang
::     :~  (ferm label.req %s)
::         (feud count.req)
::         (feud skip.req)
::         (ferm include-watchonly.req %b)
::     ==
::       %list-unspent
::     :~  (ferm minconf.req %s)
::         (feud maxconf.req)
::         (ferm addresses.req %a)
::         (ferm include-unsafe.req %b)
::         (feob query-options.req)
::         :: ?~  query-options  ~
::         :: o+(~(gas by *(map @t json)) u.query-options.req)
::     ==
::       %list-wallet-dir  ^-  tang
::     ~
::   ::
::       %list-wallets     ^-  tang
::     ~
::   ::
::       %load-wallet      ^-  tang
::     ~[s+filename.req]
::   ::
::       %lock-unspent     ^-  tang
::     :~  b+unlock.req
::         ?~  transactions.req  ~
::         o+(~(gas by *(map @t json)) u.transactions.req)
::     ==
::   ::
::       %remove-pruned-funds  ^-  tang
::     ~[s+txid.req]
::   ::
::       %rescan-blockchain    ^-  tang
::     :~  (feud start-height.req)
::         (feud stop-height.req)
::     ==
::   ::
::       %send-many  ^-  tang
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
::       %send-to-address  ^-  tang
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
::       %set-hd-seed   ^-  tang
::     ~
::   ::
::       %set-label     ^-  tang
::     :~  s+address.req
::         s+label.req
::     ==
::   ::
::       %set-tx-fee    ^-  tang
::     ~[s+amount.req]
::   ::
::       %sign-message  ^-  tang
::     :~  s+address.req
::         s+message.req
::     ==
::   ::
::       %sign-raw-transaction-with-wallet  ^-  tang
::     :~  s+hex-string.req
::         (feob prev-txs.req)
::         :: ?~  prev-txs.req  ~
::         :: o+(~(gas by *(map @t json)) u.prev-txs.req)
::     ==
::   ::
::       %unload-wallet  ^-  tang
::     ~[s+wallet-name.req]
::   ::
::       %wallet-create-fundedpsbt  ^-  tang
::     :~  a+inputs.req
::         a+outputs.req
::         n+(scot %ud locktime.req)
::         (feob options.req)
::         :: ?~  options.req  ~
::         :: o+(~(gas by *(map @t json)) u.options.req)
::         (ferm bip32derivs.req %b)
::     ==
::   ::
::       %wallet-lock  ^-  tang
::     ~
::   ::
::       %wallet-passphrase  ^-  tang
::     ~[s+passphrase.req s+timeout.req]
::   ::
::       %wallet-passphrase-change  ^-  tang
::     :~  (ferm old-passphrase.req %s)
::         (feud new-passphrase.req)
::     ==
::   ::
::       %wallet-process-psbt  ^-  tang
::     :~  s+psbt.req
::         (ferm sign.req %b)
::         (ferm sig-hash-type.req %s)
::     ==
:: ::  ZMQ
:: ::
::       %get-zmq-notifications  ^-  tang
--
