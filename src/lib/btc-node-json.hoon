/-  *btc-node-hook
=,  format
|%
++  btc-rpc
  =,  ^btc-rpc
  ::  Utility core
  ::
  =+  |%
      ::  FIXME: so... most of these things are in +dejs-soft... replace!
      ::
      ::  Ideally +fall would have worked here, but we need to supply
      ::  the type of json (%s, %b...) only when unit is non empty so
      ::  this is like a reverse +bond (applied to the non-null case)
      ::  or a +bif that doesn't return a +unit
      ::
      ++  ferm  |*([a=(unit) t=term] ?~(a ~ t^u.a))
      ::++  ferp  |*(a=(unit (pair)) ?~(a ~ [-.u.a t^u.a]))
      ::  We want to make sure that numbers are numbers (@ud) but JSON
      ::  defines numbers as @ta, so we need to do a convertion.
      ::
      ++  feud  |*(a=(unit) ?~(a ~ n+(scot %ud u.a)))
      ::
      ::  Convertion from tuples to json object
      ::
      :: ++  feob
      ::   |*  a=(unit (list (pair)))
      ::   ?~  a  ~
      ::   o+(~(gas by *(map)) u.a)
      ::  From tuple to list
      ::
      :: ++  tuli
      ::   |=  opts=^
      ::   ?:  |(?=(@ -.opts) ?=(@ +.opts))
      ::     [opts ~]
      ::   [-.opts $(opts +.opts)]
      ::
      ::  Removes 'hep' (-) from a %tas
      ::  e.g. %add-multisig-address -> 'addmultisigaddress'
      ::
      ++  method
        |=  t=@t
        ^-  @t
        %+  scan  (scow %tas t)
          ((slug |=(a=[@ @t] (cat 3 a))) (star hep) alp)
      --
  |%
  ++  request-to-rpc
    =,  enjs:format
    |=  req=request
    ^-  request:rpc:jstd
    :^  -.req  (method -.req)  %list
    ::  Remove null parameters
    ::
    =-  (skip - |=(a=json =(~ a)))
    :: =-  (murn - same)
    ?+   -.req  ~|([%unsupported-request -.req] !!)
    ::
        %generate   ^-  (list json)
      :-  (numb blocks.req)
      ?~  max-tries.req
      ~
      [(numb u.max-tries.req) ~]
    ::
        %get-block-count  ^-  (list json)
      ~
    ::
        %get-blockchain-info  ^-  (list json)
      ~
    ::
    ::  Wallet
    ::
        %abandon-transaction  ^-  (list json)
      ~[s+txid.req]
    ::
        %abort-rescan  ^-  (list json)
      ~
    ::
      ::  FIXME
      ::   %add-multisig-address
      :: :~  s+name.req
      ::     n+n-required.req
      ::     ::  TODO: parse list of @ux
      ::     :: keys.req=(list @ux)
      ::     (ferm label.req %s)
      ::     (ferm address-type.req %s)
      :: ==
    ::
        %backup-wallet  ^-  (list json)
      ~[s+destination.req]
    ::
        %bump-fee  ^-  (list json)
      :~  s+txid.req
          ?~  options.req  ~
          =*  opts  u.options.req
          :-  %o  %-  ~(gas by *(map @t json))
          ^-  (list (pair @t json))
          ::  Excludes ~ elements
          ::
          =-  (murn - same)
          ^-  (list (unit (pair @t json)))
          :~  ?~  conf-target.opts  ~
              `['confTarget' s+u.conf-target.opts]
            ::
              ?~  total-fee.opts  ~
              `['totalFee' s+u.total-fee.opts]
            ::
              ?~  replaceable.opts  ~
              `['replaceable' b+u.replaceable.opts]
            ::
              ?~  estimate-mode.opts  ~
              `['estimate_mode' s+u.estimate-mode.opts]
          ==
      ==
    ::
        %create-wallet  ^-  (list json)
      :~  s+name.req
          (ferm disable-private-keys.req %b)
          (ferm blank.req %b)
      ==
    ::
        %dump-privkey  ^-  (list json)
      ~[s+address.req]
    ::
        %dump-wallet  ^-  (list json)
      ~[s+filename.req]
    ::
        %encrypt-wallet  ^-  (list json)
      ~[s+passphrase.req]
    ::
        %get-addresses-by-label  ^-  (list json)
      ~[s+label.req]
    ::
        %get-address-info  ^-  (list json)
      ~[s+address.req]
    ::
        %get-balance  ^-  (list json)
      ^-  (list json)
      :~  (ferm dummy.req %s)
          (feud minconf.req)
          (ferm include-watch-only.req %b)
      ==
    ::
        %get-new-address  ^-  (list json)
      :~  (ferm label.req %s)
          (ferm address-type.req %s)
      ==
    ::
        %get-raw-change-address  ^-  (list json)
      ~[(ferm address-type.req %s)]
    ::
        %get-received-by-address  ^-  (list json)
      ~[s+address.req n+(scot %ud minconf.req)]
    ::
        %get-received-by-label  ^-  (list json)
      ~[s+label.req (feud minconf.req)]
    ::
        %get-transaction  ^-  (list json)
      ~[s+txid.req (ferm include-watch-only.req %b)]
  ::   ::
        %get-unconfirmed-balance  ^-  (list json)
      ~
    ::
        %get-wallet-info  ^-  (list json)
      ~
    ::
        %import-address  ^-  (list json)
      :~  s+address.req
          (ferm label.req %s)
          (ferm rescan.req %b)
          (ferm p2sh.req %b)
      ==
    ::
        %import-multi   ^-  (list json)
      :~  ?~  requests.req  ~
          =*  reqs  requests.req
          :-  %a  ^-  (list json)
          %+  turn  reqs
            |=  r=import-request
            :-  %o  %-  ~(gas by *(map @t json))
            ^-  (list (pair @t json))
            ::  Exclude nulls
            ::
            =-  (skip - |=([@t a=json] =(a ~)))
            ^-  (list (pair @t json))
            :~  ['desc' s+desc.r]
              ::
                ['scriptPubKey' s+script-pub-key.r]
              ::
                :-  'timestamp'
                ?:  ?=(%now timestamp.r)
                  s+timestamp.r
                s+(scot %da timestamp.r)
              ::
                ['redeemScript' s+redeem-script.r]
              ::
                ['witnessScript' s+witness-script.r]
              ::
                :-  'pubkeys'
                ?~  pub-keys.r  ~
                :-  %a
                %+  turn   ^-((list @t) u.pub-keys.r)
                  |=(a=@t s+a)
              ::
                :-  'keys'
                ?~  keys.r  ~
                a+(turn u.keys.r |=(a=@t s+a))
              ::
                :-  'range'
                =+  range.r
                ?@  -
                  n+(scot %ud -)
                a+~[n+(scot %ud -<) n+(scot %ud ->)]
              ::
                ['internal' b+internal.r]
              ::
                ['watchonly' b+watchonly.r]
              ::
                ['label' s+label.r]
              ::
                ['keypool' b+keypool.r]
              ::
            ==
          ?~  options.req  ~
          :-  %o  %-  ~(gas by *(map @t json))
          ^-  (list (pair @t json))
          ['rescan' b+u.options.req]~
      ==
    ::
        %import-privkey  ^-  (list json)
      :~  s+privkey.req
          (ferm label.req %s)
          (ferm rescan.req %b)
      ==
    ::
        %import-pruned-funds  ^-  (list json)
      :~  s+raw-transaction.req
          s+tx-out-proof.req
      ==
    ::
        %import-pubkey  ^-  (list json)
      :~  s+pubkey.req
          (ferm label.req %s)
          (ferm rescan.req %b)
      ==
    ::
        %import-wallet  ^-  (list json)
      ~[s+filename.req]
    ::
        %key-pool-refill  ^-  (list json)
      ~[(feud new-size.req)]
    ::
        %list-address-groupings  ^-  (list json)
      ~
  ::   ::
        %list-labels  ^-  (list json)
      ~[(ferm purpose.req %s)]
    ::
        %list-lock-unspent  ^-  (list json)
      ~
    ::
        %list-received-by-address  ^-  (list json)
      :~  (feud minconf.req)
          (ferm include-empty.req %b)
          (ferm include-watch-only.req %b)
          (ferm address-filter.req %s)
      ==
    ::
        %list-received-by-label  ^-  (list json)
      :~  (feud minconf.req)
          (ferm include-empty.req %b)
          (ferm include-watch-only.req %b)
      ==
    ::
        %lists-in-ceblock  ^-  (list json)
      :~  (ferm blockhash.req %s)
          (feud target-confirmations.req)
          (ferm include-watch-only.req %b)
          (ferm include-removed.req %b)
      ==
    ::
        %list-transactions  ^-  (list json)
      :~  (ferm label.req %s)
          (feud count.req)
          (feud skip.req)
          (ferm include-watch-only.req %b)
      ==
    ::
        %list-unspent  ^-  (list json)
      :~  (ferm minconf.req %s)
        ::
          (feud maxconf.req)
        ::
          :: (ferm addresses.req %a)
          ?~  addresses.req  ~
          =*  addrs  u.addresses.req
          a+(turn addrs |=(a=@t s+a))
        ::
          (ferm include-unsafe.req %b)
        ::
          ?~  query-options.req  ~
          =*  opts  u.query-options.req
          ::  Remove null parameters
          ::
          =-  ?~(- ~ o+(~(gas by *(map @t json)) -))
          :: :-  %o  %-  ~(gas by *(map @t json))
          ^-  (list (pair @t json))
          ::  Excludes ~ elements
          ::
          =-  (murn - same)
          ^-  (list (unit (pair @t json)))
          :~  ?~  minimum-amount.opts  ~
              `['minimumAmount' n+(scot %ta u.minimum-amount.opts)]
            ::
              ?~  maximum-amount.opts  ~
              `['maximumAmount' n+(scot %ta u.maximum-amount.opts)]
            ::
              ?~  maximum-count.opts  ~
              `['minimumCount' n+(scot %ta u.maximum-count.opts)]
            ::
              ?~  minimum-sum-amount.opts  ~
              `['minimumSumAmount' n+(scot %ta u.minimum-sum-amount.opts)]
          ==
      ==
    ::
        %list-wallet-dir  ^-  (list json)
      ~
    ::
        %list-wallets     ^-  (list json)
      ~
    ::
        %load-wallet      ^-  (list json)
      ~[s+filename.req]
    ::
        %lock-unspent     ^-  (list json)
      :~  b+unlock.req
          =-  ?~(- ~ %a^-)
          ?~  transactions.req  ~
          =*  opts  u.transactions.req
          ^-  (list json)
          %+  turn   opts
            |=  [t=@t v=@ud]
            =-  ?~(- ~ o+(~(gas by *(map @t json)) -))
            :: :-  %o  %-  ~(gas by *(map @t json))
            ^-  (list (pair @t json))
            ~[['txid' s+t] ['vout' n+(scot %ud v)]]
      ==
    ::
        %remove-pruned-funds  ^-  (list json)
      ~[s+txid.req]
    ::
        %rescan-blockchain    ^-  (list json)
      :~  (feud start-height.req)
          (feud stop-height.req)
      ==
    ::
        %send-many  ^-  (list json)
      :~  s+dummy.req
       ::
          ?~  amounts.req  ~
          :-  %a
          ^-  (list json)
          %+  turn  amounts.req
            |=  [addr=@t amount=@t]
            ^-  json
            :-  %o  %-  ~(gas by *(map @t json))
            ^-  (list (pair @t json))
            [addr n+(scot %ta amount)]~
        ::
          (feud minconf.req)
        ::
          (ferm comment.req %s)
        ::
          ?~  subtract-fee-from.req  ~
          =*  addrs  u.subtract-fee-from.req
          a+(turn addrs |=(a=@t s+a))
        ::
          (feud conf-target.req)
        ::
          (ferm estimate-mode.req %s)
      ==
    ::
        %send-to-address  ^-  (list json)
      :~  s+address.req
          s+amount.req
          (ferm comment.req %s)
          (ferm comment-to.req %s)
          ?~  subtract-fee-from.req  ~
          =*  addrs  u.subtract-fee-from.req
          (ferm replaceable.req %b)
          (feud conf-target.req)
          (ferm estimate-mode.req %s)
      ==
    ::
        %set-hd-seed   ^-  (list json)
      ~
    ::
        %set-label     ^-  (list json)
      :~  s+address.req
          s+label.req
      ==
    ::
        %set-tx-fee    ^-  (list json)
      ~[s+amount.req]
    ::
        %sign-message  ^-  (list json)
      :~  s+address.req
          s+message.req
      ==
    ::
        %sign-raw-transaction-with-wallet  ^-  (list json)
      :~  ^-  json  s+hex-string.req
        ::
          ^-  json  ?~   prev-txs.req  ~
          =*  txs  u.prev-txs.req
          :-  %a
          ^-  (list json)
          %+  turn  txs
            |=  a=tx
              :-  %o  %-  ~(gas by *(map @t json))
              ^-  (list (pair @t json))
              :~  ['txid' s+txid.a]
                  ['vout' n+(scot %ud vout.a)]
                  ['scriptPubKey' s+script-pub-key.a]
                  ['redeem-Script' s+redeem-script.a]
                  ['witnessScript' s+witness-script.a]
                  ['amount' n+(scot %ta amount.a)]
              ==
        ::
          (ferm sig-hash-type.req %s)
      ==
    ::
        %unload-wallet  ^-  (list json)
      ~[(ferm wallet-name.req %s)]
    ::
      ::   %wallet-create-fundedpsbt  ^-  (list json)
      :: :~  a+inputs.req
      ::     a+outputs.req
      ::     n+(scot %ud locktime.req)
      ::     (feob options.req)
      ::     :: ?~  options.req  ~
      ::     :: o+(~(gas by *(map @t json)) u.options.req)
      ::     (ferm bip32derivs.req %b)
      :: ==
    ::
        %wallet-lock  ^-  (list json)
      ~
    ::
        %wallet-passphrase  ^-  (list json)
      ~[s+passphrase.req n+(scot %ud timeout.req)]
    ::
        %wallet-passphrase-change  ^-  (list json)
      :~  (ferm old-passphrase.req %s)
          (feud new-passphrase.req)
      ==
    ::
        %wallet-process-psbt  ^-  (list json)
      :~  s+psbt.req
          (ferm sign.req %b)
          (ferm sig-hash-type.req %s)
          (ferm bip32derivs.req %b)
      ==
  ::  ZMQ
  ::
        %get-zmq-notifications  ^-  (list json)
      ~
    ==
  ::
  ++  parse-response
    =,  dejs:format
    |=  res=response:rpc:jstd
    ^-  response
    ~|  -.res
    ::  only deals with successful requests
    ::  ignores (%error, %fails and %batch)
    ::
    ?>  ?=(%result -.res)
    ?+  id.res
      ~|  [%unsupported-response id.res]
      !!
    ::  %wallet
    ::
        %generate
      :-  id.res
      %.  res.res
      (ar (su hex))
    ::
        %get-block-count
      :-  id.res
      (ni res.res)
    ::
        %list-wallets
      :-  id.res
      %.  res.res
      (ar so)
    ::
        %create-wallet
      :-  id.res
      %.  res.res
      (ot name+so warning+so ~)
    ::  %zmq
    ::
       :: %get-zmq-notifications
    ==
  --
--
