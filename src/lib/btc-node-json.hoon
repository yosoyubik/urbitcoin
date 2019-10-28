/-  *btc-node-hook
=,  format
|%
++  btc-rpc
  =,  ^btc-rpc
  ::  Utility core
  ::
  =+  |%
      ::  Ideally +fall would have worked here, but we need to supply
      ::  the type of json (%s, %b...) only when unit is non empty so
      ::  this is like a reverse +bond (applied to the non-null case)
      ::  or a +bif that doesn't return a +unit
      ::
      ++  ferm  |*([a=(unit) t=term] ?~(a ~ t^u.a))
      ::
      ::  We want to make sure that numbers are numbers (@ud) but JSON
      ::  defines numbers as @ta, so we need to do a re-parse
      ::
      ++  feud  |*(a=(unit) ?~(a ~ n+(scot %ud u.a)))
      ::
      ++  feta  |*(a=(unit) ?~(a ~ n+(scot %ta u.a)))
      ::  %method:
      ::  Removes 'hep' (-) from a %tas producing the RPC
      ::   method to use in a call
      ::
      ::  (e.g. %add-multisig-address -> 'addmultisigaddress')
      ::
      ++  method
        |=  t=@t
        ^-  @t
        %+  scan  (scow %tas t)
          ((slug |=(a=[@ @t] (cat 3 a))) (star hep) alp)
      ::
      ++  bip125
        ::  This would have been more elegant:
        ::  ['bip125-replaceable' (cu term so)]
        ::  but a term is not of type ?(%yes %no %unknown)
        ::  so a manual convertion seems the only(?) way.
        ::
        |=  t=@t
        ^-  ?(%yes %no %unknown)
        ?:  =(t 'yes')
          %yes
        ?:  =(t 'no')
          %no
        ?:  =(t 'unknown')  !!
        %unknown
      ::
      ++  purpose
        |=  t=@t
        ^-  ?(%send %receive)
        ?:  =(t 'send')
          %send
        ?.  =(t 'receive')  !!
        %receive
      ::
      ++  category
        |=  t=@t
        ^-  ?(%send %receive %generate %immature %orphan)
        ?:  =(t 'send')
          %send
        ?:  =(t 'receive')
          %receive
        ?:  =(t 'generate')
          %generate
        ?:  =(t 'immature')
          %immature
        ?.  =(t 'orphan')  !!
        %orphan
      ::  %groups
      ::
      ::  Used in %list-address-groupings
      ::
      ++  groups
        |=  l=(list @t)
        :_  ~
        ::  TODO: This could(?) be done without lark syntax
        ::  It replaces the parsed list with a  list of
        ::  triplet of two @t and a unit
        ::
        =/  addr=@ux  (rash -.l fim:ag)
        :*  `@uc`addr  `@t`+<.l
            ?:  ?=([@t @t ~] l)    ~
            ?.  ?=([@t @t @t ~] l)  !!
            (some `@t`+>-.l)
        ==
      ::
      ::  Base-58 parser
      ::    We could have used this base-58 parser from %zuse, that produces
      ::    a raw atom.
      ::
      ::  But it seems that it has some issues,
      ::
      ::          ++  base-58
      ::            =-  (bass 58 (plus -))
      ::            ;~  pose
      ::               (cook |=(a=@ (sub a 56)) (shim 'A' 'H'))
      ::               (cook |=(a=@ (sub a 57)) (shim 'J' 'N'))
      ::               (cook |=(a=@ (sub a 58)) (shim 'P' 'Z'))
      ::               (cook |=(a=@ (sub a 64)) (shim 'a' 'k'))
      ::               (cook |=(a=@ (sub a 65)) (shim 'm' 'z'))
      ::               (cook |=(a=@ (sub a 49)) (shim '1' '9'))
      ::            ==
      ::
      ::  compared to +fim:ag, with the extra cast as seen bellow,
      ::    because it returns @ux:
      ::
      ::        =-  (cu - (su fim:ag))
      ::        |=(a=@ux `@uc`a)
      ::
      ::  Validates base58check encoded addresess
      ::  e.g:
      ::  '3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy'
      ::  is
      ::  0c3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy
      ::
      ++  to-base58
        |=  c=@t
        `@uc`(rash c fim:ag)
      ::
      ++  base58-to-cord
        |=  b=@uc
        ^-  @t
        ::  Removes leading 0c
        ::
        (rsh 4 1 (scot %uc b))
      ::
      ++  hex-to-cord
        |=  h=@ux
        ^-  @t
        ::  Removes leading 0x
        ::
        =-  (rsh 4 1 -)
        ::  Removes .
        ::
        %+  scan  (scow %ux h)
          ((slug |=(a=[@ @t] (cat 3 a))) (star dot) alp)
      ::
      ++  to-hex
        |=  c=@t
        ::  Parse hexadecimal to atom
        ::
        =-  `@ux`(rash - hex)
        ::  Group by 4-size block
        ::
        =-  (rsh 4 1 -)
        ::  Add leading 00
        ::
        (lsh 4 1 c)
      ::
      ++  ux-to-base
        |=(h=@ux `@uc`h)
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
    ?+    -.req  ~|([%unsupported-request -.req] !!)
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
      ~[s+(hex-to-cord txid.req)]
    ::
        %abort-rescan
      ~
    ::
        %add-multisig-address
      :~  n+(scot %ud n-required.req)
          :-  %a
          %+  turn  keys.req
            |=  a=@uc
            s+(base58-to-cord a)
          (ferm label.req %s)
          s+address-type.req
      ==
    ::
        %backup-wallet
      ~[s+destination.req]
    ::
        %bump-fee
      :~  s+(hex-to-cord txid.req)
          ?~  options.req  ~
          =*  opts  u.options.req
          %-  pairs:enjs
            ::  Excludes ~ elements
            ::
            =-  (skip - |=([@t a=json] =(a ~)))
            ^-  (list (pair @t json))
            :~  ['confTarget' (ferm conf-target.opts %s)]
                ['totalFee' (ferm total-fee.opts %s)]
                ['replaceable' (ferm replaceable.opts %b)]
                ['estimate_mode' (ferm estimate-mode.opts %s)]
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
      ~[s+(base58-to-cord address.req)]
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
      ~[s+(base58-to-cord address.req)]
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
      ~[s+(base58-to-cord address.req) n+(scot %ud minconf.req)]
    ::
        %get-received-by-label
      ~[s+label.req (feud minconf.req)]
    ::
        %get-transaction
      ~[s+(hex-to-cord txid.req) (ferm include-watch-only.req %b)]
    ::
        %get-unconfirmed-balance
      ~
    ::
        %get-wallet-info
      ~
    ::
        %import-address
      :~  s+(base58-to-cord address.req)
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
            %-  pairs:enjs
              ::  Exclude nulls
              ::
              =-  (skip - |=([@t a=json] =(a ~)))
              ^-  (list (pair @t json))
              :~  ['desc' s+desc.r]
                ::
                  :-  'scriptPubKey'
                  =*  scri  script-pubkey.r
                  ?-   -.scri
                      %script
                    ^-  json
                    [%s s.scri]
                    ::
                      %address
                    %-  pairs:enjs
                      ['address' s+(base58-to-cord a.script-pubkey.r)]~
                  ==
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
          %-  pairs:enjs
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
      :~  ?~  blockhash.req  ~
          s+(hex-to-cord u.blockhash.req)
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
          =-  ?~(- ~ (pairs:enjs -))
          ^-  (list (pair @t json))
          ::  Excludes ~ elements
          ::
          =-  (skip - |=([@t a=json] =(a ~)))
          ^-  (list (pair @t json))
          :~  ['minimumAmount' (feta minimum-amount.opts)]
              ['maximumAmount' (feta maximum-amount.opts)]
              ['minimumCount' (feta maximum-count.opts)]
              ['minimumSumAmount' (feta minimum-sum-amount.opts)]
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
            |=  [t=@ux v=@ud]
            =-  ?~(- ~ (pairs:enjs -))
            ^-  (list (pair @t json))
            ~[['txid' s+(hex-to-cord t)] ['vout' n+(scot %ud v)]]
      ==
    ::
        %remove-pruned-funds
      ~[s+(hex-to-cord txid.req)]
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
            |=  [addr=@uc amount=@t]
            ^-  json
            %-  pairs:enjs
              [(base58-to-cord addr) n+(scot %ta amount)]~
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
      :~  s+(base58-to-cord address.req)
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
      :~  s+(base58-to-cord address.req)
          s+label.req
      ==
    ::
        %set-tx-fee
      ~[s+amount.req]
    ::
        %sign-message
      :~  s+(base58-to-cord address.req)
          s+message.req
      ==
    ::
        %sign-raw-transaction-with-wallet
      :~  s+(hex-to-cord hex-string.req)
          ?~   prev-txs.req  ~
          =*  txs  u.prev-txs.req
          :-  %a
          %+  turn  ^-  (list tx-raw)  txs
            |=  a=tx-raw
            %-  pairs:enjs
              :~  ['txid' s+(hex-to-cord txid.a)]
                  ['vout' n+(scot %ud vout.a)]
                  ['scriptPubKey' s+(hex-to-cord script-pubkey.a)]
                  ['redeemScript' s+(hex-to-cord redeem-script.a)]
                  ['witnessScript' s+(hex-to-cord witness-script.a)]
                  ['amount' n+(scot %tas amount.a)]
              ==
        ::
          (ferm sig-hash-type.req %s)
      ==
    ::
        %unload-wallet
      ~[(ferm wallet-name.req %s)]
    ::
        %wallet-create-fundedpsbt
      :~  :-  %a
          %+  turn  inputs.req
            |=  [txid=@ux vout=@ud sequence=@ud]
            ^-  json
            %-  pairs:enjs
              :~  ['txid' s+(hex-to-cord txid)]
                  ['vout' n+(scot %ud vout)]
                  ['sequence' n+(scot %ud sequence)]
              ==
        ::
          =*  out  outputs.req
          :-  %a
          %+  weld
            :_  ~
            %-  pairs:enjs
              [-.data.out s+(scot %ux +.data.out)]~
            %+  turn  addresses.out
              |=  [=address amount=@t]
              ^-  json
              %-  pairs:enjs
                :~  ['address' s+(base58-to-cord address)]
                    ['amount' s+amount]
                ==
        ::
          (feud locktime.req)
        ::
          ?~  options.req  ~
          =*  opts  u.options.req
          =-  (pairs:enjs -)
          =-  (skip - |=([@t a=json] =(a ~)))
          ^-  (list (pair @t json))
          :~  :-  'changeAddress'
              ?~  change-address.opts  ~
              s+(base58-to-cord u.change-address.opts)
              ['changePosition' (feud change-position.opts)]
              ['change-type' (ferm change-type.opts %s)]
              ['includeWatching' (ferm include-watching.opts %b)]
              ['lockUnspents' (ferm lock-unspents.opts %b)]
              ['feeRate' (ferm fee-rate.opts %s)]
              :-  'subtractFeeFromOutputs'
              ?~  subtract-fee-from-outputs.opts  ~
              a+(turn u.subtract-fee-from-outputs.opts numb:enjs)
              ['replaceable' (ferm replaceable.opts %b)]
              ['conf-target' (feud conf-target.opts)]
              ['estimate-mode' (ferm estimate-mode.opts %s)]
          ==
          (ferm bip32derivs.req %b)
      ==
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
    ?+    id.res  ~|  [%unsupported-response id.res]  !!
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
    ::  Wallet
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
      :~  :-  'address'
          (cu ux-to-base (su fim:ag))
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
      :~  ['txid' (cu to-hex so)]
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
      ::  Transforms the keys encoded as @ux to @uc
      ::
      =-  %+  turn  -
        |*  [k=@ux v=*]
        [`@uc`k v]
      =-  ~(tap by -)
      %.  res.res
      =-  (op fim:ag -)
      (ot ['purpose' (cu purpose so)]~)
    ::
        %get-address-info
      :-  id.res
      %.  res.res
      =-  (ou -)
      :~  =-  ['address' (un -)]
          (cu ux-to-base (su fim:ag))
          ['scriptPubKey' (un (cu to-hex so))]
          ['ismine' (un bo)]
          ['iswatchonly' (un bo)]
          ['solvable' (un bo)]
          ['desc' (uf ~ (mu so))]
          ['isscript' (un bo)]
          ['ischange' (un bo)]
          ['iswitness' (un bo)]
          ['witness_version' (uf ~ (mu so))]
          ['witness_program' (uf ~ (mu (cu to-hex so)))]
          ['script' (uf ~ (mu so))]
          ['hex' (uf ~ (mu (cu to-hex so)))]
          ['pubkeys' (uf ~ (mu (ar (cu to-hex so))))]
          ['sigsrequired' (uf ~ (mu ni))]
          ['pubkey' (uf ~ (mu (cu to-hex so)))]
          =-  ['embedded' (uf ~ (mu -))]
          =-  (ou -)
          :~  ['scriptPubKey' (un (cu to-hex so))]
              ['solvable' (un bo)]
              ['desc' (uf ~ (mu so))]
              ['isscript' (un bo)]
              ['ischange' (un bo)]
              ['iswitness' (un bo)]
              ['witness_version' (uf ~ (mu so))]
              ['witness_program' (uf ~ (mu (cu to-hex so)))]
              ['script' (uf ~ (mu (cu to-hex so)))]
              ['hex' (uf ~ (mu (cu to-hex so)))]
              ['pubkeys' (uf ~ (mu (ar (cu to-hex so))))]
              ['sigsrequired' (uf ~ (mu ni))]
              ['pubkey' (uf ~ (mu (cu to-hex so)))]
              ['iscompressed' (uf ~ (mu bo))]
              ['label' (uf ~ (mu so))]
              ['hdmasterfingerprint' (uf ~ (mu (cu to-hex so)))]
              =-  ['labels' (un -)]
              =-  (ar (ot -))
              :~  ['name' so]
                  ['purpose' (cu purpose so)]
              ==
          ==
          ['iscompressed' (uf ~ (mu bo))]
          ['label' (uf ~ (mu so))]
          ['timestamp' (uf ~ (mu so))]
          ['hdkeypath' (uf ~ (mu so))]
          ['hdseedid' (uf ~ (mu (cu to-hex so)))]
          ['hdmasterfingerprint' (uf ~ (mu (cu to-hex so)))]
          =-  ['labels' (un -)]
          =-  (ar (ot -))
          :~  ['name' so]
              ['purpose' (cu purpose so)]
          ==
      ==
      ::
        %get-balance
      :-  id.res
      (so res.res)
    ::
        %get-new-address
      :-  id.res
      ::  FIXME: there should be a better way for this(?)
      ::  hex -> @ -> @uc (base58check)
      ::
      :: ^-  @uc  ^-  @
      %.  res.res
      :: (su fim:ag)
      (cu ux-to-base (su fim:ag))
    ::
        %get-raw-change-address
      :-  id.res
      :: (so res.res)
      %.  res.res
      (cu ux-to-base (su fim:ag))
    ::
        %get-received-by-address
      :-  id.res
      (so res.res)
    ::
        %get-received-by-label
      :-  id.res
      (so res.res)
    ::
        %get-transaction
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['amount' so]
          ['fee' so]
          ['confirmations' ni]
          ['blockhash' (cu to-hex so)]
          ['blockindex' ni]
          ['blocktime' so]
          ['txid' (cu to-hex so)]
          ['time' so]
          ['timereceived' so]
          ['bip125-replaceable' (cu bip125 so)]
          =-  ['details' (ar (ot -))]
          :~  :-  'address'
              (cu ux-to-base (su fim:ag))
              ['category' (cu category so)]
              ['amount' so]
              ['label' so]
              ['vout' ni]
              ['fee' so]
              ['abandoned' bo]
          ==
          ['hex' (cu to-hex so)]
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
      =-  (ar -)
      (cu groups (ar so))
    ::
        %list-labels
      :-  id.res
      %.  res.res
      (ar so)
    ::
        %list-lock-unspent
      :-  id.res
      %.  res.res
      =-  (ar -)
      (ot ~[['txid' (cu to-hex so)] ['vout' ni]])
    ::
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
          =-  ['address' (un -)]
          (cu ux-to-base (su fim:ag))
          ['amount' (un so)]
          ['confirmations' (un ni)]
          ['label' (un so)]
          ['txids' (un (ar (cu to-hex so)))]
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
        :~  :-  'address'
            (cu ux-to-base (su fim:ag))
            ['category' (cu category so)]
            ['amount' so]
            ['label' so]
            ['vout' ni]
            ['fee' so]
            ['confirmations' ni]
            ['blockhash' (cu to-hex so)]
            ['blockindex' ni]
            ['blocktime' ni]
            ['txid' (cu to-hex so)]
            ['time' ni]
            ['timereceived' ni]
            ['bip125-replaceable' (cu bip125 so)]
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
          ['lastblock' (un (cu to-hex so))]
      ==
    ::
        %list-transactions
      :-  id.res
      %.  res.res
      =-  (ar (ot -))
      :~  :-  'address'
          (cu ux-to-base (su fim:ag))
          ['category' (cu category so)]
          ['amount' so]
          ['label' so]
          ['vout' ni]
          ['fee' so]
          ['confirmations' ni]
          ['trusted' bo]
          ['blockhash' (cu to-hex so)]
          ['blockindex' ni]
          ['blocktime' so]
          ['txid' (cu to-hex so)]
          ['time' so]
          ['timereceived' so]
          ['comment' so]
          ['bip125-replaceable' (cu bip125 so)]
          ['abandoned' bo]
      ==
    ::
        %list-unspent
      :-  id.res
      %.  res.res
      =-  (ar (ou -))
      :~  ['txid' (un (cu to-hex so))]
          ['vout' (un so)]
          =-  ['address' (un -)]
          (cu ux-to-base (su fim:ag))
          ['label' (un so)]
          ['scriptPubKey' (un (cu to-hex so))]
          ['amount' (un so)]
          ['confirmations' (un ni)]
          ['redeemScript' (un (cu to-hex so))]
          ['witnessScript' (un (cu to-hex so))]
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
      :-  id.res
      %.  res.res
      (cu to-hex so)
    ::
        %send-to-address
      :-  id.res
      %.  res.res
      (cu to-hex so)
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
    ::
        %sign-raw-transaction-with-wallet
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['hex' (cu to-hex so)]
          ['complete' bo]
          :-  'errors'
          =-  (ar (ot -))
          :~  ['txid' (cu to-hex so)]
              ['vout' ni]
              ['scriptSig' (cu to-hex so)]
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
         :-  'address'
         (cu ux-to-base (su fim:ag))
         ['hwm' so]
     ==
    ::
    ==
  --
--
