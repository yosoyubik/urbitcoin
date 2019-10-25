/-  *btc-node-hook
=,  format
|%
++  btc-rpc
  =,  ^btc-rpc
  ::  Utility core
  ::
  =+  |%
      ::  FIXME: so... most of these things seem to be in +dejs.. replace!
      ::
      ::  Ideally +fall would have worked here, but we need to supply
      ::  the type of json (%s, %b...) only when unit is non empty so
      ::  this is like a reverse +bond (applied to the non-null case)
      ::  or a +bif that doesn't return a +unit
      ::
      ++  ferm  |*([a=(unit) t=term] ?~(a ~ t^u.a))
      ::
      ::  We want to make sure that numbers are numbers (@ud) but JSON
      ::  defines numbers as @ta, so we need to do a convertion.
      ::
      ++  feud  |*(a=(unit) ?~(a ~ n+(scot %ud u.a)))
      ::
      ::  %method: Removes 'hep' (-) from a %tas producing
      ::  the RPC method to use in a call
      ::
      ::  (e.g. %add-multisig-address -> 'addmultisigaddress')
      ::
      ++  method
        |=  t=@t
        ^-  @t
        %+  scan  (scow %tas t)
          ((slug |=(a=[@ @t] (cat 3 a))) (star hep) alp)
      ::
      ::  json reparse that produces ~ when a key is undefined or
      ::  unit of the value
      ::
      :: ++  un-dejs
      ::   =>  |%  ++  grub  *
      ::           ++  fist  $-((unit json) grub)
      ::       --
      ::   |%
      ::   ++  ot
      ::     |*  wer=(pole [cord fist])
      ::     |=  jon=json
      ::     ?>  ?=([%o *] jon)
      ::     ((ot-raw wer) p.jon)
      ::   ::
      ::   ++  ot-raw
      ::     |*  wer=(pole [cord fist])
      ::     |=  jom=(map @t json)
      ::     ?-    wer
      ::         [[key=@t *] t=*]
      ::       =>  .(wer [[* wit] *]=wer)
      ::       =/  val=(unit json)  (~(get by jom) key.wer)
      ::       :: =/  ten  ?~(val ~ (wit.wer u.val))
      ::       :: =/  ten  (wit.wer u.val)
      ::       =/  ten  (wit.wer val)
      ::       :: ~&  [key.wer val ten]
      ::       ?~(t.wer ten [ten ((ot-raw t.wer) jom)])
      ::     ==
        ::
        :: ++  um
        ::   |*  wit=fist
        ::   |=  jon=(unit json)
        ::   ?~(jon ~ (wit u.jon))
        ::  This gates need to be redefined as wet, since otherwise
        ::  cast the type of the json to ~ in cases like &, or ''
        ::
        :: ++  so  |*(jon=json ?>(?=([%s *] jon) p.jon))
        :: ++  bo  |*(jon=json ?>(?=([%b *] jon) p.jon))
        :: ++  no  |*(jon=json ?>(?=([%n *] jon) p.jon))
        :: --
      ::
      ::  Base-58 parser
      ::
      ++  base-58
        =-  (bass 58 (plus -))
        ;~  pose
          (cook |=(a=@ (sub a 56)) (shim 'A' 'H'))
          (cook |=(a=@ (sub a 57)) (shim 'J' 'N'))
          (cook |=(a=@ (sub a 58)) (shim 'P' 'Z'))
          (cook |=(a=@ (sub a 64)) (shim 'a' 'k'))
          (cook |=(a=@ (sub a 65)) (shim 'm' 'z'))
          (cook |=(a=@ (sub a 49)) (shim '1' '9'))
        ==
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
    ^-  (list json)
    ?+   -.req  ~|([%unsupported-request -.req] !!)
    ::
        %generate
      :-  (numb blocks.req)
      ?~  max-tries.req
      ~
      [(numb u.max-tries.req) ~]
    ::
        %get-block-count
      ~
    ::
        %get-blockchain-info
      ~
    ::
    ::  Wallet
    ::
        %abandon-transaction
      ~[s+txid.req]
    ::
        %abort-rescan
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
        %backup-wallet
      ~[s+destination.req]
    ::
        %bump-fee
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
        %create-wallet
      :~  s+name.req
          (ferm disable-private-keys.req %b)
          (ferm blank.req %b)
      ==
    ::
        %dump-privkey
      ~[s+address.req]
    ::
        %dump-wallet
      ~[s+filename.req]
    ::
        %encrypt-wallet
      ~[s+passphrase.req]
    ::
        %get-addresses-by-label
      ~[s+label.req]
    ::
        %get-address-info
      ~[s+address.req]
    ::
        %get-balance

      :~  (ferm dummy.req %s)
          (feud minconf.req)
          (ferm include-watch-only.req %b)
      ==
    ::
        %get-new-address
      :~  (ferm label.req %s)
          (ferm address-type.req %s)
      ==
    ::
        %get-raw-change-address
      ~[(ferm address-type.req %s)]
    ::
        %get-received-by-address
      ~[s+address.req n+(scot %ud minconf.req)]
    ::
        %get-received-by-label
      ~[s+label.req (feud minconf.req)]
    ::
        %get-transaction
      ~[s+txid.req (ferm include-watch-only.req %b)]
    ::
        %get-unconfirmed-balance
      ~
    ::
        %get-wallet-info
      ~
    ::
        %import-address
      :~  s+address.req
          (ferm label.req %s)
          (ferm rescan.req %b)
          (ferm p2sh.req %b)
      ==
    ::
        %import-multi
      :~  ?~  requests.req  ~
          =*  reqs  requests.req
          :-  %a
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
                ['scriptPubKey' s+script-pubkey.r]
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
        %import-privkey
      :~  s+privkey.req
          (ferm label.req %s)
          (ferm rescan.req %b)
      ==
    ::
        %import-pruned-funds
      :~  s+raw-transaction.req
          s+tx-out-proof.req
      ==
    ::
        %import-pubkey
      :~  s+pubkey.req
          (ferm label.req %s)
          (ferm rescan.req %b)
      ==
    ::
        %import-wallet
      ~[s+filename.req]
    ::
        %key-pool-refill
      ~[(feud new-size.req)]
    ::
        %list-address-groupings
      ~
    ::
        %list-labels
      ~[(ferm purpose.req %s)]
    ::
        %list-lock-unspent
      ~
    ::
        %list-received-by-address
      :~  (feud minconf.req)
          (ferm include-empty.req %b)
          (ferm include-watch-only.req %b)
          (ferm address-filter.req %s)
      ==
    ::
        %list-received-by-label
      :~  (feud minconf.req)
          (ferm include-empty.req %b)
          (ferm include-watch-only.req %b)
      ==
    ::
        %lists-in-ceblock
      :~  (ferm blockhash.req %s)
          (feud target-confirmations.req)
          (ferm include-watch-only.req %b)
          (ferm include-removed.req %b)
      ==
    ::
        %list-transactions
      :~  (ferm label.req %s)
          (feud count.req)
          (feud skip.req)
          (ferm include-watch-only.req %b)
      ==
    ::
        %list-unspent
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
        %list-wallet-dir
      ~
    ::
        %list-wallets
      ~
    ::
        %load-wallet
      ~[s+filename.req]
    ::
        %lock-unspent
      :~  b+unlock.req
          =-  ?~(- ~ %a^-)
          ?~  transactions.req  ~
          =*  opts  u.transactions.req

          %+  turn   opts
            |=  [t=@t v=@ud]
            =-  ?~(- ~ o+(~(gas by *(map @t json)) -))
            ^-  (list (pair @t json))
            ~[['txid' s+t] ['vout' n+(scot %ud v)]]
      ==
    ::
        %remove-pruned-funds
      ~[s+txid.req]
    ::
        %rescan-blockchain
      :~  (feud start-height.req)
          (feud stop-height.req)
      ==
    ::
        %send-many
      :~  s+dummy.req
       ::
          ?~  amounts.req  ~
          :-  %a
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
        %send-to-address
      :~  s+address.req
          s+amount.req
          (ferm comment.req %s)
          (ferm comment-to.req %s)
          ?~  subtract-fee-from.req  ~
          =*  addrs  u.subtract-fee-from.req
          a+(turn addrs |=(a=@t s+a))
          (ferm replaceable.req %b)
          (feud conf-target.req)
          (ferm estimate-mode.req %s)
      ==
    ::
        %set-hd-seed
      ~
    ::
        %set-label
      :~  s+address.req
          s+label.req
      ==
    ::
        %set-tx-fee
      ~[s+amount.req]
    ::
        %sign-message
      :~  s+address.req
          s+message.req
      ==
    ::
        %sign-raw-transaction-with-wallet
      :~  s+hex-string.req
          ?~   prev-txs.req  ~
          =*  txs  u.prev-txs.req
          :-  %a
          %+  turn  ^-  (list tx-raw)  txs
            |=  a=tx-raw
              %-  pairs:enjs:format
              ^-  (list (pair @t json))
              :~  ['txid' s+txid.a]
                  ['vout' n+(scot %ud vout.a)]
                  ['scriptPubKey' s+script-pubkey.a]
                  ['redeemScript' s+redeem-script.a]
                  ['witnessScript' s+witness-script.a]
                  ['amount' n+(scot %tas amount.a)]
              ==
        ::
          (ferm sig-hash-type.req %s)
      ==
    ::
        %unload-wallet
      ~[(ferm wallet-name.req %s)]
    ::
      ::   %wallet-create-fundedpsbt
      :: :~  a+inputs.req
      ::     a+outputs.req
      ::     n+(scot %ud locktime.req)
      ::     (feob options.req)
      ::     :: ?~  options.req  ~
      ::     :: o+(~(gas by *(map @t json)) u.options.req)
      ::     (ferm bip32derivs.req %b)
      :: ==
    ::
        %wallet-lock
      ~
    ::
        %wallet-passphrase
      ~[s+passphrase.req n+(scot %ud timeout.req)]
    ::
        %wallet-passphrase-change
      :~  (ferm old-passphrase.req %s)
          (feud new-passphrase.req)
      ==
    ::
        %wallet-process-psbt
      :~  s+psbt.req
          (ferm sign.req %b)
          (ferm sig-hash-type.req %s)
          (ferm bip32derivs.req %b)
      ==
    ::
    :: ZMQ
    ::
        %get-zmq-notifications
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
      ~|  [%unsupported-response id.res]  !!
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
   ::  WALLET
   ::
        %abandon-transaction
      [id.res ~]
      ::
        %abort-rescan
      [id.res ~]
      ::
        %add-multisig-address
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['address' so]
          ['redeemScript' so]
      ==
      ::
        %backup-wallet
      [id.res ~]
      ::
        %bump-fee
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['txid' so]
          ['origfee' no]
          ['fee' no]
          ['errors' (ar so)]
      ==
      ::
        %create-wallet
      :-  id.res
      %.  res.res
      (ot ~[name+so warning+so])
      ::
        %dump-privkey
      [id.res (so res.res)]
      ::
        %dump-wallet
      :-  id.res
      %.  res.res
      (ot [filename+so]~)
      ::
        %encrypt-wallet
      [id.res ~]
      ::
        %get-addresses-by-label
      :-  id.res
      =-  ~(tap by -)
      %.  res.res
      =-  (op base-58 -)
      =-  (ot ['purpose' (cu - so)]~)
        |=  t=@t
        ^-  ?(%send %receive)
        ?:  =(t 'send')  %send
        ?:  =(t 'receive')  %receive
        !!
      ::
        %get-address-info
      :-  id.res
      %.  res.res
      =-  (ou -)
      :~  ['address' (un so)]
          ['scriptPubKey' (un so)]
          ['ismine' (un bo)]
          ['iswatchonly' (un bo)]
          ['solvable' (un bo)]
          ['desc' (uf ~ (mu so))]
          ['isscript' (un bo)]
          ['ischange' (un bo)]
          ['iswitness' (un bo)]
          ['witness_version' (uf ~ (mu so))]
          ['witness_program' (uf ~ (mu so))]
          ['script' (uf ~ (mu so))]
          ['hex' (uf ~ (mu so))]
          ['pubkeys' (uf ~ (mu (ar so)))]
          ['sigsrequired' (uf ~ (mu ni))]
          ['pubkey' (uf ~ (mu so))]
          =-  ['embedded' (uf ~ (mu -))]
          =-  (ou -)
          :~  ['scriptPubKey' (un so)]
              ['solvable' (un bo)]
              ['desc' (uf ~ (mu so))]
              ['isscript' (un bo)]
              ['ischange' (un bo)]
              ['iswitness' (un bo)]
              ['witness_version' (uf ~ (mu so))]
              ['witness_program' (uf ~ (mu so))]
              ['script' (uf ~ (mu so))]
              ['hex' (uf ~ (mu so))]
              ['pubkeys' (uf ~ (mu (ar so)))]
              ['sigsrequired' (uf ~ (mu ni))]
              ['pubkey' (uf ~ (mu so))]
              ['iscompressed' (uf ~ (mu bo))]
              ['label' (uf ~ (mu so))]
              ['hdmasterfingerprint' (uf ~ (mu so))]
              =-  ['labels' (un -)]
              =-  (ar (ot -))
              :~  ['name' so]
                  =-  ['purpose' (cu - so)]
                  |=  t=@t
                  ^-  ?(%send %receive)
                  ?:  =(t 'send')  %send
                  ?:  =(t 'receive')  %receive
                  !!
              ==
          ==
          ['iscompressed' (uf ~ (mu bo))]
          ['label' (uf ~ (mu so))]
          ['timestamp' (uf ~ (mu so))]
          ['hdkeypath' (uf ~ (mu so))]
          ['hdseedid' (uf ~ (mu so))]
          ['hdmasterfingerprint' (uf ~ (mu so))]
          =-  ['labels' (un -)]
          =-  (ar (ot -))
          :~  ['name' so]
              =-  ['purpose' (cu - so)]
              |=  t=@t
              ^-  ?(%send %receive)
              ?:  =(t 'send')  %send
              ?:  =(t 'receive')  %receive
              !!
          ==
      ==
      ::
        %get-balance
      [id.res (so res.res)]
      ::
        %get-new-address
      [id.res (so res.res)]
      ::
        %get-raw-change-address
      [id.res (so res.res)]
      ::
        %get-received-by-address
      [id.res (so res.res)]
      ::
        %get-received-by-label
      [id.res (so res.res)]
      ::
        %get-transaction
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['amount' so]
          ['fee' so]
          ['confirmations' ni]
          ['blockhash' so]
          ['blockindex' ni]
          ['blocktime' so]
          ['txid' so]
          ['time' so]
          ['timereceived' so]
          :-  'bip125-replaceable'  =-  (cu - so)
              ::  This would have been more elegant:
              ::  ['bip125-replaceable' (cu term so)]
              ::  but a term is not of type ?(%yes %no %unknown)
              ::  so a manual convertion seems the only(?) way.
              ::
              |=  t=@t
              ^-  ?(%yes %no %unknown)
              ?:  =(t 'yes')  %yes
              ?:  =(t 'no')  %no
              ?:  =(t 'unknown')  %unknown
              !!
          =-  ['details' (ar (ot -))]
          :~  ['address' so]
              :-  'category'  =-  (cu - so)
                  ::  see 'bip125-replaceable'
                  ::
                  |=  t=@t
                  ^-  ?(%send %receive %generate %immature %orphan)
                  ?:  =(t 'send')  %send
                  ?:  =(t 'receive')  %receive
                  ?:  =(t 'generate')  %generate
                  ?:  =(t 'immature')  %immature
                  ?:  =(t 'orphan')  %orphan
                  !!
              ['amount' so]
              ['label' so]
              ['vout' ni]
              ['fee' so]
              ['abandoned' bo]
          ==
          ['hex' so]
      ==
      ::
        %list-wallets
      :-  id.res
      %.  res.res
      (ar so)
      ::
        %get-unconfirmed-balance
      [id.res (so res.res)]
      ::
        %get-wallet-info
      :-  id.res
      %.  res.res
      =-  (ou -)
      :~  ['walletname' (un so)]
          ['walletversion' (un so)]
          ['balance' (un so)]
          ['unconfirmed_balance' (un so)]
          ['immature_balance' (un so)]
          ['txcount' (un so)]
          ['keypoololdest' (un so)]
          ['keypoolsize' (un so)]
          ['keypool_size_hd_internal' (un so)]
          ['unlocked_until' (un so)]
          ['paytxfee' (un so)]
          ['hdseedid' (uf ~ (mu so))]
          ['private_keys_enabled' (un bo)]
      ==
      ::
        %import-address
      [id.res ~]
      ::
        %import-multi
      :-  id.res
      %.  res.res
      =-  (ar (ou -))
      :~  ['success' (un bo)]
          =-  ['warnings' (uf ~ -)]
          (mu (ar so))
          =-  ['errors' -]
          =-  (uf ~ (mu -))
          (ot ~[['error' so] ['message' so]])
      ==
      ::
        %import-privkey
      [id.res ~]
      ::
        %import-pruned-funds
      [id.res ~]
      ::
        %import-pubkey
      [id.res ~]
      ::
        %import-wallet
      [id.res ~]
      ::
        %key-pool-refill
      [id.res ~]
      ::
        %list-address-groupings
      :-  id.res
      %.  res.res
      =-  (ar (cu - (ar so)))
        |=  l=(list @t)
        :_  ~
        ::  This could(?) be done without lark syntax
        ::  it replaces the parsed list with a  list of
        ::  triplet of two @t and a unit
        ::
        :*  `@t`-.l   `@t`+<.l
            ?:  ?=([@t @t ~] l)    ~
            ?.  ?=([@t @t @t ~] l)  !!
            (some `@t`+>-.l)
        ==
      ::
        %list-labels
      :-  id.res
      %.  res.res
      (ar so)
      :: ::
        %list-lock-unspent
      :-  id.res
      %.  res.res
      =-  (ar -)
      (ot ~[['txid' so] ['vout' ni]])
      :: ::
        %list-received-by-address
      :-  id.res
      %.  res.res
      =-  (ar (ou -))
      :~  :-  'involvesWatchonly'
          =-  (uf ~ -)
          =-  (cu - (mu bo))
            |=  b=(unit ?)
            ?~  b  ~
            ?>(=(u.b &) (some %&))
          ['address' (un so)]
          ['amount' (un so)]
          ['confirmations' (un ni)]
          ['label' (un so)]
          ['txids' (un (ar so))]
      ==
      ::
        %list-received-by-label
      :-  id.res
      %.  res.res
      =-  (ar (ou -))
      :~  :-  'involvesWatchonly'
          =-  (uf ~ (cu - (mu bo)))
          |=  b=(unit ?)
          ?~  b  ~
          ?>(=(u.b &) (some %&))
          ['amount' (un so)]
          ['confirmations' (un ni)]
          ['label' (un so)]
      ==
      ::
        %lists-in-ceblock
      =/  tx-response
        :~  ['address' so]
            :-  'category'
            =-  (cu - so)
              |=  t=@t
              ^-  ?(%send %receive %generate %immature %orphan)
              ?:  =(t 'send')  %send
              ?:  =(t 'receive')  %receive
              ?:  =(t 'generate')  %generate
              ?:  =(t 'immature')  %immature
              ?:  =(t 'orphan')  %orphan
              !!
            ['amount' so]
            ['label' so]
            ['vout' ni]
            ['fee' so]
            ['confirmations' ni]
            ['blockhash' so]
            ['blockindex' ni]
            ['blocktime' ni]
            ['txid' so]
            ['time' ni]
            ['timereceived' ni]
            :-  'bip125-replaceable'
            =-  (cu - so)
              |=  t=@t
              ^-  ?(%yes %no %unknown)
              ?:  =(t 'yes')  %yes
              ?:  =(t 'no')  %no
              ?:  =(t 'unknown')  %unknown
              !!
            ['abandoned' bo]
            ['comment' so]
            ['label' so]
            ['to' so]
        ==
      :-  id.res
      %.  res.res
      =-  (ou -)
      :~  =-  ['transactions' (un -)]
          (ar (ot tx-response))
          ::
          =-  ['removed' (un (mu -))]
          (ar (ot tx-response))
          ::
          ['lastblock' (un so)]
      ==
      ::
        %list-transactions
      :-  id.res
      %.  res.res
      =-  (ar (ot -))
      :~  ['address' so]
          :-  'category'
          =-  (cu - so)
            |=  t=@t
            ^-  ?(%send %receive %generate %immature %orphan)
            ?:  =(t 'send')  %send
            ?:  =(t 'receive')  %receive
            ?:  =(t 'generate')  %generate
            ?:  =(t 'immature')  %immature
            ?:  =(t 'orphan')  %orphan
            !!
          ['amount' so]
          ['label' so]
          ['vout' ni]
          ['fee' so]
          ['confirmations' ni]
          ['trusted' bo]
          ['blockhash' so]
          ['blockindex' ni]
          ['blocktime' so]
          ['txid' so]
          ['time' so]
          ['timereceived' so]
          ['comment' so]
          :-  'bip125-replaceable'
          =-  (cu - so)
            |=  t=@t
            ^-  ?(%yes %no %unknown)
            ?:  =(t 'yes')  %yes
            ?:  =(t 'no')  %no
            ?:  =(t 'unknown')  %unknown
            !!
          ['abandoned' bo]
      ==
      ::
        %list-unspent
      :-  id.res
      %.  res.res
      =-  (ar (ou -))
      :~  ['txid' (un so)]
          ['vout' (un so)]
          ['address' (un so)]
          ['label' (un so)]
          ['scriptPubKey' (un so)]
          ['amount' (un so)]
          ['confirmations' (un ni)]
          ['redeemScript' (un so)]
          ['witnessScript' (un so)]
          ['spendable' (un bo)]
          ['solvable' (un bo)]
          ['desc' (uf ~ (mu so))]
          ['safe' (un bo)]
      ==
    ::
        %list-wallet-dir
      :-  id.res
      %.  res.res
      =-  (ot -)
      =-  ['wallets' -]~
      (ar (ot [name+so]~))
    ::
        %list-wallets
      :-  id.res
      %.  res.res
      (ar so)
    ::
        %load-wallet
      :-  id.res
      %.  res.res
      (ot ~[name+so warning+so])
    ::
        %lock-unspent
      [id.res (bo res.res)]
    ::
        %remove-pruned-funds
      [id.res ~]
    ::
        %rescan-blockchain
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['start_height' ni]
          ['stop_height' ni]
      ==
    ::
        %send-many
      [id.res (so res.res)]
    ::
        %send-to-address
      [id.res (so res.res)]
    ::
        %set-hd-seed
      [id.res ~]
    ::
        %set-label
      [id.res ~]
    ::
        %set-tx-fee
      [id.res (bo res.res)]
    ::
        %sign-message
      [id.res (so res.res)]
    :: ::
        %sign-raw-transaction-with-wallet
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['hex' so]
          ['complete' bo]
          :-  'errors'
          =-  (ar (ot -))
          :~  ['txid' so]
              ['vout' ni]
              ['scriptSig' so]
              ['sequence' ni]
              ['error' so]
      ==  ==
    ::
        %unload-wallet
      [id.res ~]
    ::
        %wallet-create-fundedpsbt
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['psbt' so]
          ['fee' so]
          ['changepos' so]
      ==
    ::
        %wallet-lock
      [id.res ~]
    ::
        %wallet-passphrase
      [id.res ~]
    ::
        %wallet-passphrase-change
      [id.res ~]
    ::
        %wallet-process-psbt
        :-  id.res
        %.  res.res
        =-  (ot -)
        :~  ['psbt' so]
            ['complete' bo]
        ==
    ::
    ::  %zmq
    ::
       %get-zmq-notifications
     :-  id.res
     %.  res.res
     =-  (ar (ot -))
     :~  ['type' so]
         ['address' so]
         ['hwm' so]
     ==
    ::
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

    ==
  --
--
