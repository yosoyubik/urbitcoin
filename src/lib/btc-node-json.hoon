/-  *btc-node-hook
/+  base64
=,  format
=>  ::  Helper gates used for parsing or for avoiding
    ::  repetition or common idioms
    ::
    |%
    ::  Checks the unit for null and returns a json e.g. [%s @ta]
    ::
    ++  ferm  |*([a=(unit) t=term] ?~(a ~ t^u.a))
    ::  %feud:
    ::  We want to make sure that numbers are @ud but JSON
    ::  defines numbers as @ta, so we need to do a re-parse
    ::
    ++  feud  |=(a=(unit @u) ?~(a ~ (numb:enjs u.a)))
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
    ++  groups
      |=  l=(list @t)
      ^-  (list [@uc @t (unit @t)])
      ?>  ?=([@t @t *] l)
      :_  ~
      :*  `@uc`(rash i.l fim:ag)
          i.t.l
          ?~  t.t.l  ~
          (some i.t.t.l)
      ==
    ::
    ++  to-base58  |=(c=@t `@uc`(rash c fim:ag))
    ::
    ++  base58-to-cord
      |=  b=@uc
      ^-  @t
      ::  Removes leading 0c
      ::
      (rsh 3 2 (scot %uc b))
    ::
    ++  hex-to-cord
      |=  h=@ux
      ^-  @t
      ::  Removes leading 0x
      ::
      =-  (rsh 3 2 -)
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
      =-  (rsh 3 2 -)
      ::  Add leading 00
      ::
      (lsh 3 2 c)
    ::
    ++  ux-to-base  |=(h=@ux `@uc`h)
    --
|%
++  btc-rpc
  =,  ^btc-rpc
  ::  Utility core
  ::
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
    ::  Blockchain
    ::
        %get-best-block-hash
      ~
    ::
        %get-block
      ~[s+(hex-to-cord blockhash.req) (feud verbosity.req)]
      ::
        %get-blockchain-info
      ~
    ::
        %get-block-count
      ~
    ::
        %get-block-hash
      ~[(numb height.req)]
    ::
        %get-block-header
      ~[s+(hex-to-cord blockhash.req) (ferm verbose.req %b)]
    ::
        %get-block-stats
      :~  =*  h  hash-or-height.req
          ?-  -.h
            %num  (numb +.h)
            %hex  s+(hex-to-cord +.h)
          ==
          ?~  stats.req  ~
          a+(turn u.stats.req |=(a=@t s+a))
      ==
    ::
        %get-chain-tips
      ~
    ::
        %get-chain-tx-stats
      :~  (feud n-blocks.req)
          ?~  blockhash.req  ~
          s+(hex-to-cord u.blockhash.req)
      ==
    ::
        %get-difficulty
      ~
    ::
        %get-mempool-ancestors
      ~[s+(hex-to-cord txid.req) (ferm verbose.req %b)]
    ::
        %get-mempool-descendants
      ~[s+(hex-to-cord txid.req) (ferm verbose.req %b)]
    ::
        %get-mempool-entry
      ~[s+(hex-to-cord txid.req)]
    ::
        %get-mempool-info
      ~
    ::
        %get-raw-mempool
      ~[(ferm verbose.req %b)]
    ::
        %get-tx-out
      :~  s+(hex-to-cord txid.req)
          (numb n.req)
          (ferm include-mempool.req %b)
      ==
    ::
        %get-tx-out-proof
      :~  :-  %a
          %+  turn  tx-ids.req
            |=  a=@ux
            s+(hex-to-cord a)
        ::
          ?~  blockhash.req  ~
          s+(hex-to-cord u.blockhash.req)
      ==
    ::
        %get-tx-outset-info
      ~
    ::
        %precious-block
      ~[s+(hex-to-cord blockhash.req)]
    ::
        %prune-blockchain
      ~[(numb height.req)]
    ::
        %save-mempool
      ~
    ::
        %scan-tx-outset
      :~  s+action.req
          :-  %a
          %+  turn  scan-objects.req
            |=  s-o=scan-object
            ^-  json
            ?@  s-o
              s+s-o
            ::  FIXME: too verbose?
            ::
            ?>  ?=([@t (unit ?(@ud [@ud @ud]))] s-o)
            %-  pairs
              :~  ['desc' s+desc.object.s-o]
                  :-  'range'
                  ^-  json
                  ?~  range.object.s-o  ~
                  =*  r  u.range.object.s-o
                  ?@  r
                    (numb r)
                  a+~[(numb -.r) (numb +.r)]
      ==      ==
      ::     %+  weld
      ::       ~[s+descriptor.s-o]
      ::     ::
      ::       %+  turn  metadata.s-o
      ::         |=  [desc=@t =range]
      ::         ^-  json
      ::         %-  pairs
      ::           :~  ['desc' s+desc]
      ::               ?~  range  ~
      ::               ?@  range
      ::                 (numb range)
      ::               a+~[(numb -.range) (numb +.range)]
      :: ==        ==
    ::
        %verify-chain
      ~[(feud check-level.req) (feud n-blocks.req)]
    ::
        %verify-tx-out-proof
      ~[s+proof.req]
    ::  Generating
    ::
        %generate
      :-  (numb blocks.req)
      ?~  max-tries.req
        ~
      [(numb u.max-tries.req) ~]
    ::  Raw Transactions
    ::
        %analyze-psbt
      :_  ~
      :-  %s
      ?^  (de:base64 psbt.req)
        psbt.req
      (en:base64 (as-octs:mimes:html psbt.req))
    ::
        %combine-psbt
      :_  ~
      :-  %a
      %+  turn   txs.req
        |=  a=@t
        :-  %s
        ?^  (de:base64 a)
          a
        (en:base64 (as-octs:mimes:html a))
    ::
        %combine-raw-transaction
      ~[a+(turn txs.req |=(a=@ux s+(hex-to-cord a)))]
    ::
        %convert-to-psbt
      :~  s+(hex-to-cord hex-string.req)
          (ferm permit-sig-data.req %b)
          (ferm is-witness.req %b)
      ==
    ::
        %create-psbt
      :~  :-  %a
          %+  turn  inputs.req
            |=  a=input
            ^-  json
            %-  pairs  ^-  (list (pair @t json))
              :~  ['txid' s+(hex-to-cord txid.a)]
                  ['vout' (numb vout.a)]
                  ['sequence' (numb sequence.a)]
              ==
        ::
          =*  out  outputs.req
          :-  %a
          %+  weld
            :_  ~
            %-  pairs
              [-.data.out s+(hex-to-cord +.data.out)]~
            %+  turn  addresses.out
              |=  [=address amount=@t]
              ^-  json
              %-  pairs
                :~  ['address' s+(base58-to-cord address)]
                    ['amount' n+amount]
                ==
        ::
          (feud locktime.req)
        ::
          (ferm replaceable.req %b)
      ==
    ::
        %create-raw-transaction
      :~  :-  %a  ^-  (list json)
          %+  turn  inputs.req
            |=  a=input
            %-  pairs  ^-  (list (pair @t json))
              :~  ['txid' s+(hex-to-cord txid.a)]
                  ['vout' (numb vout.a)]
                  ['sequence' (numb sequence.a)]
              ==
        ::
          =*  out  outputs.req
          :-  %a
          %+  weld
            :_  ~
            %-  pairs
              [-.data.out s+(hex-to-cord +.data.out)]~
          ::
            %+  turn  addresses.out
              |=  [=address amount=@t]
              ^-  json
              %-  pairs
                :~  ['address' s+(base58-to-cord address)]
                    ['amount' n+amount]
                ==
        ::
          (feud locktime.req)
        ::
          (ferm replaceable.req %b)
      ==
    ::
        %decode-psbt
      :_  ~
      :-  %s
      ?^  (de:base64 psbt.req)
        psbt.req
      (en:base64 (as-octs:mimes:html psbt.req))
    ::
        %decode-raw-transaction
      :~  s+(hex-to-cord hex-string.req)
          (ferm is-witness.req %b)
      ==
    ::
        %decode-script
      ~[s+(hex-to-cord hex-string.req)]
    ::
        %finalize-psbt
      :~  :-  %s
          ?^  (de:base64 psbt.req)
            psbt.req
          (en:base64 (as-octs:mimes:html psbt.req))
        ::
          (ferm extract.req %b)
      ==
    ::
        %fund-raw-transaction
      :~  s+(hex-to-cord hex-string.req)
        ::
        ?~  options.req  ~
        =*  opts  u.options.req
        %-  pairs
          ::  Excludes ~ elements
          ::
          =-  (skip - |=([@t a=json] =(a ~)))
          ^-  (list (pair @t json))
          :~  :-  'changeAddress'
              ?~  change-address.opts  ~
              s+(base58-to-cord u.change-address.opts)
              ['changePosition' (feud change-position.opts)]
              ['change_type' (ferm change-type.opts %s)]
              ['includeWatching' (ferm include-watching.opts %b)]
              ['lockUnspents' (ferm lock-unspents.opts %b)]
              ['feeRate' (ferm fee-rate.opts %s)]
              :-  'subtractFeeFromOutputs'
              ?~  subtract-fee-from-outputs.opts  ~
              :-  %a  ^-  (list json)
              (turn u.subtract-fee-from-outputs.opts numb)
              ['replaceable' (ferm replaceable.opts %b)]
              ['conf_target' (feud conf-target.opts)]
              ['estimate_mode' (ferm estimate-mode.opts %s)]
          ==
        ::
          (ferm is-witness.req %b)
      ==
    ::
        %get-raw-transaction
      :~  s+(hex-to-cord txid.req)
          (ferm verbose.req %b)
          ?~  blockhash.req  ~
          s+(hex-to-cord u.blockhash.req)
      ==
    ::
        %join-psbts
      ~[a+(turn txs.req |=(a=@t s+a))]
    ::
        %send-raw-transaction
      :~  s+(hex-to-cord hex-string.req)
          (ferm allow-high-fees.req %b)
      ==
    ::
        %sign-raw-transaction-with-key
      :~  s+(hex-to-cord hex-string.req)
        ::
          :-  %a  ^-  (list json)
          %+  turn   priv-keys.req
            |=  a=@t
            :-  %s
            ?^  (de:base64 a)
              a
            (en:base64 (as-octs:mimes:html a))
        ::
          ?~  prev-txs.req  ~
          =*  txs  u.prev-txs.req
          :-  %a  ^-  (list json)
          %+  turn  txs
            |=  a=prev-tx
            %-  pairs  ^-  (list (pair @t json))
              :~  ['txid' s+(hex-to-cord txid.a)]
                  ['vout' (numb vout.a)]
                  ['scriptPubKey' s+(hex-to-cord script-pubkey.a)]
                  ['redeemScript' s+(hex-to-cord redeem-script.a)]
                  ['witnessScript' s+(hex-to-cord witness-script.a)]
                  ['amount' n+amount.a]
              ==
        ::
          (ferm sig-hash-type.req %s)
      ==
    ::
        %test-mempool-accept
      :~  :-  %a  ^-  (list json)
          %+  turn  raw-txs.req
            |=(a=@ux s+(hex-to-cord a))
        ::
          (ferm allow-high-fees.req %b)
      ==
    ::
        %utxo-update-psbt
      :_  ~
      :-  %s
      ?^  (de:base64 psbt.req)
        psbt.req
      (en:base64 (as-octs:mimes:html psbt.req))
    ::
    ::  Util
    ::
        %create-multi-sig
      :~  (numb n-required.req)
        ::
          :-  %a
          %+  turn  keys.req
            |=(a=@ux s+(hex-to-cord a))
        ::
          (ferm address-type.req %s)
      ==
    ::
        %derive-addresses
      :~  s+descriptor.req
          ?~  range.req  ~
          =*  range  u.range.req
          ?@  range
            (numb range)
          a+~[(numb -.range) (numb +.range)]
      ==
    ::
        %estimate-smart-fee
      :~  (numb conf-target.req)
          (ferm estimate-mode.req %s)
      ==
    ::
        %get-descriptor-info
      ~[s+descriptor.req]
    ::
        %sign-message-with-privkey
      ~[s+privkey.req s+message.req]
    ::
        %validate-address
      ~[s+(base58-to-cord address.req)]
    ::
        %verify-message
      :~  s+(base58-to-cord address.req)
          s+signature.req
          s+message.req
      ==
    ::  Wallet
    ::
        %abandon-transaction
      ~[s+(hex-to-cord txid.req)]
    ::
        %abort-rescan
      ~
    ::
        %add-multisig-address
      :~  (numb n-required.req)
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
          %-  pairs
            ::  Excludes ~ elements
            ::
            =-  (skip - |=([@t a=json] =(a ~)))
            ^-  (list (pair @t json))
            :~  ['confTarget' (ferm conf-target.opts %s)]
                ['totalFee' (ferm total-fee.opts %n)]
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
      ~[s+(base58-to-cord address.req) (numb minconf.req)]
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
            %-  pairs
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
                    [%s s.scri]
                  ::
                      %address
                    %-  pairs
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
                  ?~  pubkeys.r  ~
                  :-  %a
                  %+  turn   ^-((list @t) u.pubkeys.r)
                    |=(a=@t s+a)
                ::
                  :-  'keys'
                  ?~  keys.r  ~
                  a+(turn u.keys.r |=(a=@t s+a))
                ::
                  :-  'range'
                  =+  range.r
                  ?@  -
                    (numb -)
                  a+~[(numb -<) (numb ->)]
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
          %-  pairs
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
      :~  s+(hex-to-cord pubkey.req)
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
      ?~  +.req  ~
      :~  (feud minconf.req)
          (ferm include-empty.req %b)
          (ferm include-watch-only.req %b)
          (ferm address-filter.req %s)
      ==
    ::
        %list-received-by-label
      ?~  +.req  ~
      :~  (feud minconf.req)
          (ferm include-empty.req %b)
          (ferm include-watch-only.req %b)
      ==
    ::
        %lists-in-ceblock
      ?~  +.req  ~
      :~  ?~  blockhash.req  ~
          s+(hex-to-cord u.blockhash.req)
          (feud target-confirmations.req)
          (ferm include-watch-only.req %b)
          (ferm include-removed.req %b)
      ==
    ::
        %list-transactions
      ?~  +.req  ~
      :~  (ferm label.req %s)
          (feud count.req)
          (feud skip.req)
          (ferm include-watch-only.req %b)
      ==
    ::
        %list-unspent
      ?~  +.req  ~
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
          =-  ?~(- ~ (pairs -))
          ^-  (list (pair @t json))
          ::  Excludes ~ elements
          ::
          =-  (skip - |=([@t a=json] =(a ~)))
          ^-  (list (pair @t json))
          :~  ['minimumAmount' (ferm minimum-amount.opts %n)]
              ['maximumAmount' (ferm maximum-amount.opts %n)]
              ['minimumCount' (ferm maximum-count.opts %n)]
              ['minimumSumAmount' (ferm minimum-sum-amount.opts %n)]
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
            =-  ?~(- ~ (pairs -))
            ^-  (list (pair @t json))
            ~[['txid' s+(hex-to-cord t)] ['vout' (numb v)]]
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
            %-  pairs
              [(base58-to-cord addr) n+amount]~
        ::
          (feud minconf.req)
        ::
          (ferm comment.req %s)
        ::
          ?~  subtract-fee-from.req  ~
          =*  addrs  u.subtract-fee-from.req
          a+(turn addrs |=(a=address s+(base58-to-cord a)))
        ::
          (feud conf-target.req)
        ::
          (ferm estimate-mode.req %s)
      ==
    ::
        %send-to-address
      :~  s+(base58-to-cord address.req)
          n+amount.req
          (ferm comment.req %s)
          (ferm comment-to.req %s)
          (ferm subtract-fee-from-amount.req %b)
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
          %+  turn  ^-  (list prev-tx)  txs
            |=  a=prev-tx
            %-  pairs
              :~  ['txid' s+(hex-to-cord txid.a)]
                  ['vout' (numb vout.a)]
                  ['scriptPubKey' s+(hex-to-cord script-pubkey.a)]
                  ['redeemScript' s+(hex-to-cord redeem-script.a)]
                  ['witnessScript' s+(hex-to-cord witness-script.a)]
                  ['amount' n+amount.a]
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
            |=  a=input
            ^-  json
            %-  pairs
              :~  ['txid' s+(hex-to-cord txid.a)]
                  ['vout' (numb vout.a)]
                  ['sequence' (numb sequence.a)]
              ==
        ::
          =*  out  outputs.req
          :-  %a
          %+  weld
            :_  ~
            %-  pairs
              [-.data.out s+(hex-to-cord +.data.out)]~
            %+  turn  addresses.out
              |=  [=address amount=@t]
              ^-  json
              %-  pairs
                :~  ['address' s+(base58-to-cord address)]
                    ['amount' n+amount]
                ==
        ::
          (feud locktime.req)
        ::
          ?~  options.req  ~
          =*  opts  u.options.req
          =-  (pairs -)
          =-  (skip - |=([@t a=json] =(a ~)))
          ^-  (list (pair @t json))
          :~  :-  'changeAddress'
              ?~  change-address.opts  ~
              s+(base58-to-cord u.change-address.opts)
              ['changePosition' (feud change-position.opts)]
              ['change-type' (ferm change-type.opts %s)]
              ['includeWatching' (ferm include-watching.opts %b)]
              ['lockUnspents' (ferm lock-unspents.opts %b)]
              ['feeRate' (ferm fee-rate.opts %n)]
              :-  'subtractFeeFromOutputs'
              ?~  subtract-fee-from-outputs.opts  ~
              a+(turn u.subtract-fee-from-outputs.opts numb)
              ['replaceable' (ferm replaceable.opts %b)]
              ['conf-target' (feud conf-target.opts)]
              ['estimate-mode' (ferm estimate-mode.opts %s)]
          ==
          (ferm bip32-derivs.req %b)
      ==
    ::
        %wallet-lock
      ~
    ::
        %wallet-passphrase
      ~[s+passphrase.req (numb timeout.req)]
    ::
        %wallet-passphrase-change
      :~  (ferm old-passphrase.req %s)
          (ferm new-passphrase.req %s)
      ==
    ::
        %wallet-process-psbt
      :~  :-  %s
          ?^  (de:base64 psbt.req)
            psbt.req
          (en:base64 (as-octs:mimes:html psbt.req))
          (ferm sign.req %b)
          (ferm sig-hash-type.req %s)
          (ferm bip32-derivs.req %b)
      ==
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
    ?+    id.res  ~|([%unsupported-response id.res] !!)
    ::  Blockchain
    ::
        %get-best-block-hash
      [id.res ((cu to-hex so) res.res)]
    ::
        %get-block
      :-  id.res
      %.  res.res
      ?+  -.res.res  ~|([%non-valid-format -.res.res] !!)
            %s
          (cu to-hex so)
        ::
            %o
          =-  (ot -)
          :~  ['hash' (cu to-hex so)]
              ['confirmations' ni]
              ['size' ni]
              ['strippedsize' ni]
              ['weight' ni]
              ['height' ni]
              ['version' so]
              ['versionHex' (cu to-hex so)]
              ['merkleroot' (cu to-hex so)]
              =-  ['tx' (ar -)]
              |=  =json
              %.  json
              ?:  =(%s -.json)  (cu to-hex so)
              ?.  =(%o -.json)  !!
              =-  (ot -)
              :~  ['in_active_chain' bo]
                  ['hex' (cu to-hex so)]
                  ['txid' (cu to-hex so)]
                  ['hash' (cu to-hex so)]
                  ['size' ni]
                  ['vsize' ni]
                  ['weight' ni]
                  ['version' no]
                  ['locktime' ni]
                  =-  ['vin' (ar (ot -))]
                  :~  ['txid' (cu to-hex so)]
                      ['vout' ni]
                      =-  ['scriptSig' (ot -)]
                      :~  ['asm' so]
                          ['hex' (cu to-hex so)]
                      ==
                      ['txinwitness' (ar (cu to-hex so))]
                      ['sequence' ni]
                  ==
                  =-  ['vout' (ar (ot -))]
                  :~  ['value' no]
                      ['n' ni]
                      =-  ['scriptPubKey' (ot -)]
                      :~  ['asm' so]
                          ['hex' (cu to-hex so)]
                          ['req-sigs' ni]
                          ['type' so]
                          ['addresses' (ar (cu ux-to-base (su fim:ag)))]
                  ==  ==
                  ['blockhash' (cu to-hex so)]
                  ['confirmations' ni]
                  ['blocktime' ni]
                  ['time' ni]
              ==
              ['time' ni]
              ['mediantime' ni]
              ['nonce' ni]
              ['bits' (cu to-hex so)]
              ['difficulty' so]
              ['chainwork' (cu to-hex so)]
              ['nTx' ni]
              ['previousblockhash' (cu to-hex so)]
              ['nextblockhash' (cu to-hex so)]
      ==  ==
    ::
        %get-blockchain-info
      :-  id.res
      %.  res.res
      =-  (ou -)
      :~  ['chain' (un (cu network-name so))]
          ['blocks' (un ni)]
          ['headers' (un ni)]
          ['bestblockhash' (un (cu to-hex so))]
          ['difficulty' (un so)]
          ['mediantime' (un ni)]
          ['verificationprogress' (un ni)]
          ['initialblockdownload' (un bo)]
          ['chainwork' (un (cu to-hex so))]
          ['size_on_disk' (un ni)]
          ['pruned' (un bo)]
          ['pruneheight' (uf ~ (mu ni))]
          ['automatic_pruning' (uf ~ (mu bo))]
          ['prune_target_size' (uf ~ (mu ni))]
          =-  ['softforks' (un (ar (ot -)))]
          :~  ['id' so]
              ['version' so]
              ['reject' (ot ['status' bo]~)]
          ==
          =-  ['bip9_softforks' (un (om (ou -)))]
          :~  ['status' (un (cu soft-fork-status so))]
              ['bit' (uf ~ (mu ni))]
              =-  ['start-time' (un (cu - no))]
              |=  a=@t
              ^-  ?(@ud %'-1')
              ?:  =(a '-1')
                %'-1'
              (rash a dem)
              ['timeout' (un ni)]
              ['since' (un ni)]
              =-  ['statistics' (uf ~ (mu (ot -)))]
              :~  ['period' ni]
                  ['threshold' ni]
                  ['elapsed' ni]
                  ['count' ni]
                  ['possible' bo]
          ==  ==
          ['warnings' (un (ar so))]
      ==
    ::
        %get-block-count
      [id.res (ni res.res)]
    ::
        %get-block-hash
      [id.res ((cu to-hex so) res.res)]
    ::
        %get-block-header
      :-  id.res
      ?:  =(%s -.res.res)
        ((cu to-hex so) res.res)
      ?.  =(%o -.res.res)  !!
      %.  res.res
      =-  (ot -)
      :~  ['hash' (cu to-hex so)]
          ['confirmations' ni]
          ['height' ni]
          ['version' so]
          ['versionHex' (cu to-hex so)]
          ['merkleroot' (cu to-hex so)]
          ['time' ni]
          ['mediantime' ni]
          ['nonce' ni]
          ['bits' (cu to-hex so)]
          ['difficulty' so]
          ['chainwork' (cu to-hex so)]
          ['nTx' ni]
          ['previousblockhash' (cu to-hex so)]
          ['nextblockhash' (cu to-hex so)]
      ==
    ::
        %get-block-stats
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['avgfee' no]
          ['avgfeerate' ni]
          ['avgtxsize' ni]
          ['blockhash' (cu to-hex so)]
          =-  ['feerate_percentiles' (cu - (ar no))]
          |=  p=(list @t)
          ?>  ?=([@t @t @t @t @t *] p)
          :: |-  ^-  ^
          :: ?>  ?=([@t @t *] p)
          :: ?~  t.t.p
          ::    [i.p i.t.p]
          :: [i.p $(p t.p)]
          ::  FIXME: extremely verbose
          ::
          :*  i.p
              i.t.p
              i.t.t.p
              i.t.t.t.p
              i.t.t.t.t.p
          ==
          ['height' ni]
          ['ins' ni]
          ['maxfee' no]
          ['maxfeerate' no]
          ['maxtxsize' ni]
          ['medianfee' no]
          ['mediantime' ni]
          ['mediantxsize' ni]
          ['minfee' no]
          ['minfeerate' no]
          ['mintxsize' ni]
          ['outs' ni]
          ['subsidy' no]
          ['swtotal_size' ni]
          ['swtotal_weight' ni]
          ['swtxs' ni]
          ['time' ni]
          ['total_out' no]
          ['total_size' ni]
          ['total_weight' no]
          ['totalfee' no]
          ['txs' ni]
          ['utxo_increase' ni]
          ['utxo_size_inc' ni]
      ==
    ::
        %get-chain-tips
      :-  id.res
      %.  res.res
      =-  (ar (ot -))
      :~  ['height' ni]
          ['hash' (cu to-hex so)]
          ['branchlen' ni]
          ['status' (cu chain-status so)]
      ==
    ::
        %get-chain-tx-stats
      :-  id.res
      %.  res.res
      =-  (ou -)
      :~  ['time' (un ni)]
          ['txcount' (un ni)]
          ['window_final_block_hash' (un (cu to-hex so))]
          ['window_block_count' (un ni)]
          ['window_tx_count' (uf ~ (mu ni))]
          ['window_interval' (uf ~ (mu ni))]
          ['txrate' (uf ~ (mu ni))]
      ==
    ::
        %get-difficulty
      [id.res (ni res.res)]
    ::
        %get-mempool-ancestors
      :-  id.res
      ?:  =(%a -.res.res)
        %.  res.res
        =-  (ar -)
        (cu to-hex so)
      ?.  =(%o -.res.res)  !!
      ::  The parsing rule +hex used in +om
      ::  will give a raw atom so we reparse
      ::  the keys to get a @ux
      ::
      =-  (turn ~(tap by -) |*([a=@ b=*] [`@ux`a b]))
      %.  res.res
      =-  (op hex (ot -))
      :~  ['size' ni]
          ['fee' no]
          ['modifiedfee' no]
          ['time' ni]
          ['height' ni]
          ['descendantcount' ni]
          ['descendantsize' ni]
          ['descendantfees' so]
          ['ancestorcount' ni]
          ['ancestorsize' ni]
          ['ancestorfees' so]
          ['wtxid' (cu to-hex so)]
          =-  ['fees' (ot -)]
          :~  ['base' so]
              ['modified' so]
              ['ancestor' so]
              ['descendant' so]
          ==
          ['depends' (ar (cu to-hex so))]
          ['spentby' (ar (cu to-hex so))]
          ['bip125-replaceable' bo]
      ==
    ::
        %get-mempool-descendants
      :-  id.res
      ?:  =(%a -.res.res)
        %.  res.res
        =-  (ar -)
        (cu to-hex so)
      ?.  =(%o -.res.res)  !!
      ::  The parsing rule +hex used in +om
      ::  will give a raw atom so we reparse
      ::  the keys to get a @ux
      ::
      =-  (turn ~(tap by -) |*([a=@ b=*] [`@ux`a b]))
      %.  res.res
      =-  (op hex (ot -))
      :~  ['size' ni]
          ['fee' no]
          ['modifiedfee' no]
          ['time' ni]
          ['height' ni]
          ['descendantcount' ni]
          ['descendantsize' ni]
          ['descendantfees' so]
          ['ancestorcount' ni]
          ['ancestorsize' ni]
          ['ancestorfees' so]
          ['wtxid' (cu to-hex so)]
          =-  ['fees' (ot -)]
          :~  ['base' so]
              ['modified' so]
              ['ancestor' so]
              ['descendant' so]
          ==
          ['depends' (ar (cu to-hex so))]
          ['spentby' (ar (cu to-hex so))]
          ['bip125-replaceable' bo]
      ==
    ::
        %get-mempool-entry
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['size' ni]
          ['fee' no]
          ['modifiedfee' no]
          ['time' ni]
          ['height' ni]
          ['descendantcount' ni]
          ['descendantsize' ni]
          ['descendantfees' so]
          ['ancestorcount' ni]
          ['ancestorsize' ni]
          ['ancestorfees' so]
          ['wtxid' (cu to-hex so)]
          =-  ['fees' (ot -)]
          :~  ['base' so]
              ['modified' so]
              ['ancestor' so]
              ['descendant' so]
          ==
          ['depends' (ar (cu to-hex so))]
          ['spentby' (ar (cu to-hex so))]
          ['bip125-replaceable' bo]
      ==
    ::
        %get-mempool-info
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['size' ni]
          ['bytes' ni]
          ['usage' ni]
          ['maxmempool' ni]
          ['mempoolminfee' no]
          ['minrelaytxfee' no]
      ==
    ::
        %get-raw-mempool
      :-  id.res
      ?:  =(%a -.res.res)
        %.  res.res
        =-  (ar -)
        (cu to-hex so)
      ?.  =(%o -.res.res)  !!
      ::  The parsing rule +hex used in +om
      ::  will give a raw atom so we reparse
      ::  the keys to get a @ux
      ::
      =-  (turn ~(tap by -) |*([a=@ b=*] [`@ux`a b]))
      %.  res.res
      =-  (op hex (ot -))
      :~  ['size' ni]
          ['fee' no]
          ['modifiedfee' no]
          ['time' ni]
          ['height' ni]
          ['descendantcount' ni]
          ['descendantsize' ni]
          ['descendantfees' so]
          ['ancestorcount' ni]
          ['ancestorsize' ni]
          ['ancestorfees' so]
          ['wtxid' (cu to-hex so)]
          =-  ['fees' (ot -)]
          :~  ['base' so]
              ['modified' so]
              ['ancestor' so]
              ['descendant' so]
          ==
          ['depends' (ar (cu to-hex so))]
          ['spentby' (ar (cu to-hex so))]
          ['bip125-replaceable' bo]
      ==
    ::
      ::   %get-tx-out
      :: :-  id.res
      :: %.  res.res
      :: =-  (ot -)
      :: :~  ['bestblock' (cu to-hex so)]
      ::     ['confirmations' ni]
      ::     ['value' so]
      ::     =-  ['scriptPubKey' (ot -)]
      ::     :~  ['asm' so]
      ::         ['hex' (cu to-hex so)]
      ::         ['reqSigs' ni]
      ::         ['type' so]
      ::         ['addresses' (ar (cu ux-to-base (su fim:ag)))]
      ::     ==
      ::     ['coinbase' bo]
      :: ==
    ::
        %get-tx-out-proof
      [id.res ((cu to-hex so) res.res)]
    ::
        %get-tx-outset-info
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['height' ni]
          ['bestblock' (cu to-hex so)]
          ['transactions' ni]
          ['txouts' ni]
          ['bogosize' ni]
          ['hash_serialized_2' (cu to-hex so)]
          ['disk_size' ni]
          ['total_amount' so]
      ==
    ::
        %precious-block
      [id.res ~]
    ::
        %prune-blockchain
      [id.res (ni res.res)]
    ::
        %save-mempool
      [id.res ~]
    ::
        %scan-tx-outset
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  =-  ['unspents' (ar (ot -))]
          :~  ['txid' (cu to-hex so)]
              ['vout' ni]
              ['scriptPubKey' (cu to-hex so)]
              ['desc' so]
              ['amount' so]
              ['height' ni]
          ==
          ['total_amount' so]
      ==
    ::
        %verify-chain
      [id.res (bo res.res)]
    ::
        %verify-tx-out-proof
      :-  id.res
      %.  res.res
      (ar (cu to-hex so))
    ::  Generating
    ::
        %generate
      :-  id.res
      %.  res.res
      (ar (cu to-hex so))
    ::  Raw Transactions
    ::
        %analyze-psbt
      :-  id.res
      %.  res.res
      =-  (ou -)
      :~   =-  ['inputs' (un (ar (ou -)))]
          :~  ['has_utxo' (un bo)]
              ['is_final' (un bo)]
              =-  ['missing' (uf ~ (mu (ar (ou -))))]
              :~  ['pubkeys' (uf ~ (mu (ar (cu to-hex so))))]
                  ['signatures' (uf ~ (mu (ar (cu to-hex so))))]
                  ['redeemscript' (uf ~ (mu (cu to-hex so)))]
                  ['witnessscript' (uf ~ (mu (cu to-hex so)))]
              ==
              ['next' (uf ~ (mu so))]
          ==
          ['estimated_vsize' (uf ~ (mu so))]
          ['estimated_feerate' (uf ~ (mu so))]
          ['fee' (uf ~ (mu so))]
          ['next' (un so)]
      ==
    ::
        %combine-psbt
      [id.res (so res.res)]
    ::
        %combine-raw-transaction
      [id.res ((cu to-hex so) res.res)]
    ::
        %convert-to-psbt
      [id.res (so res.res)]
    ::
        %create-psbt
      [id.res (so res.res)]
    ::
        %create-raw-transaction
      [id.res ((cu to-hex so) res.res)]
    ::
        %decode-psbt
      :-  id.res
      %.  res.res
      =-  (ou -)
      :~  =-  ['tx' (un (ot -))]
          :~  ['txid' (cu to-hex so)]
              ['hash' (cu to-hex so)]
              ['size' ni]
              ['vsize' ni]
              ['weight' ni]
              ['version' ni]
              ['locktime' ni]
              =-  ['vin' (ar (ot -))]
              :~  ['txid' (cu to-hex so)]
                  ['vout' ni]
                  =-  ['scriptSig' (ot -)]
                  :~  ['asm' so]
                      ['hex' (cu to-hex so)]
                  ==
                  ['txinwitness' (ar (cu to-hex so))]
                  ['sequence' ni]
              ==
              =-  ['vout' (ar (ot -))]
              :~  ['value' so]
                  ['n' ni]
                  =-  ['scriptPubKey' (ot -)]
                  :~  ['asm' so]
                      ['hex' (cu to-hex so)]
                      ['reqSigs' ni]
                      ['type' so]
                      ['addresses' (ar (cu ux-to-base (su fim:ag)))]
          ==  ==  ==
          ['unknown' (un (om so))]
          =-  ['inputs' (un (ar (ou -)))]
          :~  =-  ['non_witness_utxo' (uf ~ (mu (ot -)))]
              :~  ['amount' so]
                  =-  ['scriptPubKey' (ot -)]
                  :~  ['asm' so]
                      ['hex' (cu to-hex so)]
                      ['type' so]
                      ['address' (cu ux-to-base (su fim:ag))]
              ==  ==
            ::
              =-  ['witness_utxo' (uf ~ (mu (ot -)))]
              :~  ['amount' so]
                  =-  ['scriptPubKey' (ot -)]
                  :~  ['asm' so]
                      ['hex' (cu to-hex so)]
                      ['type' so]
                      ['address' (cu ux-to-base (su fim:ag))]
              ==  ==
            ::
              =-  ['partial_signatures' (uf ~ (mu -))]
              :: %-  molt
              ::   =-  %+  turn   ~(tap by -)
              ::     |=([a=@ b=@ux] [`@ux`a b])
                (op hex (cu to-hex so))
            ::
              =-  ['sighash' (uf ~ (mu -))]
              (cu sig-hash so)
            ::
              =-  ['redeem_script' (uf ~ (mu (ot -)))]
              :~  ['asm' so]
                  ['hex' (cu to-hex so)]
                  ['type' so]
              ==
            ::
              =-  ['witness_script' (uf ~ (mu (ot -)))]
              :~  ['asm' so]
                  ['hex' (cu to-hex so)]
                  ['type' so]
              ==
            ::
              :: =-  ['bip32_derivs' (uf ~ (mu -))]
              :: :: =-  %-  molt
              :: ::   (turn ~(tap by -) |*([a=@ b=*] [`@ux`a b]))
              :: =-  (op hex (ot -))
              :: :~  ['master_fingerprint' so]
              ::     ['path' so]
              :: ==
              =-  ['bip32_derivs' (uf ~ (mu -))]
              =-  (op hex (ot -))
              :~  ['master_fingerprint' so]
                  ['path' so]
              ==
            ::
              =-  ['final_scriptsig' (uf ~ (mu (ot -)))]
              :~  ['asm' so]
                  ['hex' (cu to-hex so)]
              ==
            ::
              =-  ['final_scriptwitness' (uf ~ (mu -))]
              (ar (cu to-hex so))
            ::
              ['unknown' (un (om so))]
          ==
          =-  ['outputs' (un (ar (ou -)))]
          :~  =-  ['redeem_script' (uf ~ (mu (ot -)))]
              :~  ['asm' so]
                  ['hex' (cu to-hex so)]
                  ['type' so]
              ==
            ::
              =-  ['witness_script' (uf ~ (mu (ot -)))]
              :~  ['asm' so]
                  ['hex' (cu to-hex so)]
                  ['type' so]
              ==
            ::
              =-  ['bip32_derivs' (uf ~ (mu -))]
              =-  (op hex (ot -))
              :~  ['master_fingerprint' so]
                  ['path' so]
              ==
            ::
              ['unknown' (un (om so))]
          ==
          ['fee' (uf ~ (mu so))]
      ==
    ::
        %decode-raw-transaction
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['txid' (cu to-hex so)]
          ['hash' (cu to-hex so)]
          ['size' ni]
          ['vsize' ni]
          ['weight' ni]
          ['version' ni]
          ['locktime' ni]
          =-  ['vin' (ar (ot -))]
          :~  ['txid' (cu to-hex so)]
              ['vout' ni]
              =-  ['scriptSig' (ot -)]
              :~  ['asm' so]
                  ['hex' (cu to-hex so)]
              ==
              ['txinwitness' (ar (cu to-hex so))]
              ['sequence' ni]
          ==
          =-  ['vout' (ar (ot -))]
          :~  ['value' so]
              ['n' ni]
              =-  ['scriptPubKey' (ot -)]
              :~  ['asm' so]
                  ['hex' (cu to-hex so)]
                  ['reqSigs' ni]
                  ['type' so]
                  ['addresses' (ar (cu ux-to-base (su fim:ag)))]
      ==  ==  ==
    ::
        %decode-script
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['asm' so]
          ['hex' (cu to-hex so)]
          ['type' so]
          ['reqSigs' ni]
          ['addresses' (ar (cu ux-to-base (su fim:ag)))]
          ['p2sh' (cu ux-to-base (su fim:ag))]
      ==
    ::
        %finalize-psbt
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  =-  ['psbt' (cu - so)]
          |=(a=@t ?>(?=(de:base64 a) a))
          ['hex' (cu to-hex so)]
          ['complete' bo]
      ==
    ::
        %fund-raw-transaction
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['hex' (cu to-hex so)]
          ['fee' no]
          =-  ['changepos' (cu - no)]
          |=  a=@t
          ^-  ?(@ud %'-1')
          ?:  =(a '-1')
            %'-1'
          (rash a dem)
      ==
    ::
        %get-raw-transaction
      :-  id.res
      %.  res.res
      ?:  =(%s -.res.res)
        (cu to-hex so)
      ?.  =(%o -.res.res)  !!
      =-  (ot -)
      :~  ['in_active_chain' bo]
          ['hex' (cu to-hex so)]
          ['txid' (cu to-hex so)]
          ['hash' (cu to-hex so)]
          ['size' ni]
          ['vsize' ni]
          ['weight' ni]
          ['version' no]
          ['locktime' ni]
          =-  ['vin' (ar (ot -))]
          :~  ['txid' (cu to-hex so)]
              ['vout' ni]
              =-  ['scriptSig' (ot -)]
              :~  ['asm' so]
                  ['hex' (cu to-hex so)]
              ==
              ['txinwitness' (ar (cu to-hex so))]
              ['sequence' ni]
          ==
          =-  ['vout' (ar (ot -))]
          :~  ['value' no]
              ['n' ni]
              =-  ['scriptPubKey' (ot -)]
              :~  ['asm' so]
                  ['hex' (cu to-hex so)]
                  ['req-sigs' ni]
                  ['type' so]
                  ['addresses' (ar (cu ux-to-base (su fim:ag)))]
          ==  ==
          ['blockhash' (cu to-hex so)]
          ['confirmations' ni]
          ['blocktime' ni]
          ['time' ni]
      ==
    ::
        %join-psbts
      :-  id.res
      %.  res.res
      =-  (cu - so)
      |=(a=@t ?>(?=(de:base64 a) a))
    ::
        %send-raw-transaction
      [id.res ((cu to-hex so) res.res)]
    ::
        %sign-raw-transaction-with-key
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['hex' (cu to-hex so)]
          ['complete' bo]
          =-  ['errors' (ar (ot -))]
          :~  ['txid' (cu to-hex so)]
              ['vout' ni]
              ['scriptSig' (cu to-hex so)]
              ['sequence' ni]
              ['error' so]
      ==  ==
    ::
        %test-mempool-accept
      :-  id.res
      %.  res.res
      =-  (ar (ou -))
      :~  ['txid' (un (cu to-hex so))]
          ['allowed' (un bo)]
          ['reject-reason' (uf ~ (mu so))]
      ==
    ::
        %utxo-update-psbt
      :-  id.res
      %.  res.res
      =-  (cu - so)
      |=(a=@t ?>(?=(de:base64 a) a))
    ::  Util
    ::
        %create-multi-sig
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  :-  'address'
          (cu ux-to-base (su fim:ag))
          ['redeemScript' so]
      ==
    ::
        %derive-addresses
      :-  id.res
      %.  res.res
      (ar (cu ux-to-base (su fim:ag)))
    ::
        %estimate-smart-fee
      :-  id.res
      %.  res.res
      =-  (ou -)
      :~  ['feerate' (un so)]
          ['errors' (uf ~ (mu (ar so)))]
          ['blocks' (un ni)]
      ==
    ::
        %get-descriptor-info
      :-  id.res
      %.  res.res
      =-  (ot -)
      :~  ['descriptor' so]
          ['isrange' bo]
          ['issolvable' bo]
          ['hasprivatekeys' bo]
      ==
    ::
        %sign-message-with-privkey
      :-  id.res
      (so res.res)
    ::
        %validate-address
      :-  id.res
      %.  res.res
      =-  (ou -)
      :~  ['isvalid' (un bo)]
          ['address' (un (cu ux-to-base (su fim:ag)))]
          ['scriptPubKey' (un (cu to-hex so))]
          ['isscript' (un bo)]
          ['iswitness' (un bo)]
          ['witness_version' (uf ~ (mu so))]
          ['witness_program' (uf ~ (mu (cu to-hex so)))]
      ==
    ::
        %verify-message
      :-  id.res
      (bo res.res)
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
      =-  (turn ~(tap by -) |*([k=@ux v=*] [`@uc`k v]))
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
      (no res.res)
    ::
        %get-new-address
      :-  id.res
      %.  res.res
      (cu ux-to-base (su fim:ag))
    ::
        %get-raw-change-address
      :-  id.res
      %.  res.res
      (cu ux-to-base (su fim:ag))
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
      :~  ['amount' no]
          ['fee' no]
          ['confirmations' ni]
          ['blockhash' (cu to-hex so)]
          ['blockindex' ni]
          ['blocktime' ni]
          ['txid' (cu to-hex so)]
          ['time' ni]
          ['timereceived' ni]
          ['bip125-replaceable' (cu bip125-replaceable so)]
          =-  ['details' (ar (ot -))]
          :~  :-  'address'
              (cu ux-to-base (su fim:ag))
              ['category' (cu category so)]
              ['amount' no]
              ['label' so]
              ['vout' ni]
              ['fee' no]
              ['abandoned' bo]
          ==
          ['hex' (cu to-hex so)]
      ==
    ::
        %list-wallets
      [id.res ((ar so) res.res)]
    ::
        %get-unconfirmed-balance
      [id.res (so res.res)]
    ::
        %get-wallet-info
      :-  id.res
      %.  res.res
      =-  (ou -)
      :~  ['walletname' (un so)]
          ['walletversion' (un ni)]
          ['balance' (un no)]
          ['unconfirmed_balance' (un no)]
          ['immature_balance' (un no)]
          ['txcount' (un ni)]
          ['keypoololdest' (un ni)]
          ['keypoolsize' (un ni)]
          ['keypool_size_hd_internal' (uf ~ (mu ni))]
          ['unlocked_until' (uf ~ (mu ni))]
          ['paytxfee' (un no)]
          ['hdseedid' (uf ~ (mu (cu to-hex so)))]
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
      [id.res ((ar so) res.res)]
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
          ['amount' (un no)]
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
          ['amount' (un no)]
          ['confirmations' (un ni)]
          ['label' (un so)]
      ==
    ::
        %lists-in-ceblock
      :-  id.res
      =/  tx-in-block
        :~  :-  'address'
            (cu ux-to-base (su fim:ag))
            ['category' (cu category so)]
            ['amount' no]
            ['label' so]
            ['vout' ni]
            ['fee' no]
            ['confirmations' ni]
            ['blockhash' (cu to-hex so)]
            ['blockindex' ni]
            ['blocktime' ni]
            ['txid' (cu to-hex so)]
            ['time' ni]
            ['timereceived' ni]
            ['bip125-replaceable' (cu bip125-replaceable so)]
            ['abandoned' bo]
            ['comment' so]
            ['label' so]
            ['to' so]
        ==
      %.  res.res
      =-  (ou -)
      :~  =-  ['transactions' (un -)]
          (ar (ot tx-in-block))
          ::
          =-  ['removed' (un (mu -))]
          (ar (ot tx-in-block))
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
          ['amount' no]
          ['label' so]
          ['vout' ni]
          ['fee' no]
          ['confirmations' ni]
          ['trusted' bo]
          ['blockhash' (cu to-hex so)]
          ['blockindex' ni]
          ['blocktime' ni]
          ['txid' (cu to-hex so)]
          ['time' ni]
          ['timereceived' ni]
          ['comment' so]
          ['bip125-replaceable' (cu bip125-replaceable so)]
          ['abandoned' bo]
      ==
    ::
        %list-unspent
      :-  id.res
      %.  res.res
      =-  (ar (ou -))
      :~  ['txid' (un (cu to-hex so))]
          ['vout' (un ni)]
          =-  ['address' (un -)]
          (cu ux-to-base (su fim:ag))
          ['label' (un so)]
          ['scriptPubKey' (un (cu to-hex so))]
          ['amount' (un no)]
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
      [id.res ((ar so) res.res)]
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
          ['fee' no]
          =-  ['changepos' (cu - no)]
          |=  a=@t
          ^-  ?(@ud %'-1')
          ?:  =(a '-1')
            %'-1'
          (rash a dem)
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
         ['hwm' ni]
      ==
    ::
    ==
  --
--
