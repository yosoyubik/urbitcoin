/-  spider
/+  *ph-io, lib=btc-node-json
=,  strand=strand:spider
^-  thread:spider
|=  args=vase
=/  addr
=/  address=@uc
  (to-base58:btc-rpc:lib '1GdK9UzpHBzqzX2A9JFP3Di4weBwqgmoQA')
=/  m  (strand ,vase)
;<  ~  bind:m  start-simple
;<  ~  bind:m  (raw-ship ~bud ~)
::
;<  ~  bind:m  (dojo ~bud "|start %btc-node-store")
;<  ~  bind:m  (dojo ~bud "|start %btc-node-hook")
::
;<  ~  bind:m  %+  dojo   ~bud
  "=credentials credentials+['http://127.0.0.1:18443/' ~[['Content-Type' 'application/json'] ['Authorization' 'Basic dXJiaXRjb2luZXI6dXJiaXRjb2luZXI']]]"
::
;<  ~  bind:m  (dojo ~bud ":btc-node-hook|action [%get-balance ~]")
;<  ~  bind:m  (wait-for-output ~bud "amount=0.00000000")
::  FIXME
::  Blockchain
  ::  %getbestblockhash: Returns the hash of the                              regtest / mainnet
  ::  best (tip) block in the longest blockchain.                               ::
  ::                                                                            ::
  ":btc-node-hook|action [%get-best-block-hash ~]"                              ::  Y / Y
  ::  %getblock: Returns an Object/string with information about block
  ::
  ":btc-node-hook|action [%get-block hash ~]"                                   ::  Y
  ":btc-node-hook|action [%get-block hash `%0]"                                 ::  Y / ? (recover: dig: over)
  ":btc-node-hook|action [%get-block hash `%1]"                                 ::  Y / Y
  ":btc-node-hook|action [%get-block hash `%2]"                                 ::  Y / ? (allocate: reclaim: half of 37 entries)
  ::  %getblockchaininfo: Returns info regarding blockchain processing.
  ::
  ":btc-node-hook|action [%get-blockchain-info ~]"                              ::  Y / Y
  ::  %getblockcount: Returns number of blocks in the longest blockchain.
  ::
  ":btc-node-hook|action [%get-block-count ~]"                                  ::  Y / Y
  ::  %getblockhash: Returns hash of block in best-block-chain at height.
  ::
  ":btc-node-hook|action [%get-block-hash height]"                              ::  Y / Y
  ::  %getblockheader: If verbose is false, returns a string that is
  ::  serialized, hex-encoded data for blockheader 'hash'. If verbose is
  ::  true, returns an Object
  ::
  ":btc-node-hook|action [%get-block-header hash ~]"                            ::  Y / Y
  ":btc-node-hook|action [%get-block-header hash `&]"                           ::  Y / Y
  ":btc-node-hook|action [%get-block-header hash `|]"                           ::  Y / Y
  ::  %getblockstats: Compute per block statistics for a given window.
  ::
  :: $=  hash-or-height
  :: $%  [%hex @ux]
  ::     [%num @ud]
  :: ==
  :: stats=(unit (list @t))
  ::
  ":btc-node-hook|action [%get-block-stats hex+hash ~]"                         ::  Y / X (! [%key 'utxo_increase'])
  ::  %getchaintips: Return information about tips in the block tree.
  ::
  ":btc-node-hook|action [%get-chain-tips ~]"                                   ::  Y / Y
  ::  %getchaintxstats: Compute statistics about total number rate
  ::  of transactions in the chain.
  ::
  ":btc-node-hook|action [%get-chain-tx-stats ~ ~]"                             ::  Y / ?
  ":btc-node-hook|action [%get-chain-tx-stats `1 `hash]"                        ::  Y / Y
  ::  %getdifficulty: Returns the proof-of-work difficulty as a multiple
  ::  of the minimum difficulty.
  ::
  ":btc-node-hook|action [%get-difficulty ~]"                                   ::  Y / Y
  ::  %getmempoolancestors: If txid is in the mempool, returns
  ::  all in-mempool ancestors.
  ::
  ::  How to create ancestor (tx) -> descendant (tx)
  ::
  ::  =inputs ~
  ::  =outputs [[%data 0x9.0209] [0c2N41E7Ur6hASSWCPdmgt1MwHFy9mr5wMpwn '1'] ~]
  ::  :btc-node-hook|action [%create-raw-transaction inputs outputs ~ ~]
  ::  :btc-node-hook|action [%fund-raw-transaction txida ~ |]
  ::  :btc-node-hook|action [%sign-raw-transaction-with-wallet txida ~ ~]
  ::  =txid-a :btc-node-hook|action [%send-raw-transaction txida *?]
  ::
  ::
  ::  =inputs [txid-a 0 0]~
  ::  =outputs [[%data 0x9.0209] [0c2N41E7Ur6hASSWCPdmgt1MwHFy9mr5wMpwn '0.5'] ~]
  ::  :btc-node-hook|action [%create-raw-transaction inputs outputs ~ ~]
  ::  :btc-node-hook|action [%fund-raw-transaction txidb ~ |]
  ::  :btc-node-hook|action [%sign-raw-transaction-with-wallet txidb ~ ~]
  ::  =txid-b :btc-node-hook|action [%send-raw-transaction txidb *?]
  ::
  ":btc-node-hook|action [%get-mempool-ancestors txid-b ~]"                     ::  Y / Y
  ":btc-node-hook|action [%get-mempool-ancestors txid-b `&]"                    ::  Y / Y
  ::  %getmempooldescendants: If txid is in the mempool, returns
  ::  all in-mempool descendants.
  ::
  ":btc-node-hook|action [%get-mempool-descendants txid-a ~]"                   ::  Y / Y
  ":btc-node-hook|action [%get-mempool-descendants txid-a `&]"                  ::  Y / Y
  ::  %getmempoolentry: Returns mempool data for given transaction
  ::
  ":btc-node-hook|action [%get-mempool-entry txid-a]"                           ::  Y / Y
  ::  %getmempoolinfo: Returns details on the active state of the
  ::  TX memory pool.
  ::  info: https://bitcoindev.network/bitcoin-transaction-mempool-statistics/
  ::
  ":btc-node-hook|action [%get-mempool-info ~]"                                 ::  Y / Y
  ::  %getrawmempool: Returns all transaction ids in memory pool as a
  ::  json array of string transaction ids.
  ::
  ":btc-node-hook|action [%get-raw-mempool ~]"                                  ::  Y / Y
  ::  %gettxout: Returns details about an unspent transaction output.
  ::
  ":btc-node-hook|action [%get-tx-out txid 1 ~]"                                ::  Y / Y
  ::  %gettxoutproof: Returns a hex-encoded proof that "txid" was
  ::  included in a block.
  ::
  "=txid 0x427b.882e.7ead.e462.fb5a.ca6c.56ce.6a72.2f18.6d37.d476.2774.714f.9237.14cc.eec5"
  ":btc-node-hook|action [%get-tx-out-proof ~[txid] ~]"                         ::  Y / Y
  ::  %gettxoutsetinfo: Returns statistics about the unspent transaction
  ::  output set.
  ::
  ":btc-node-hook|action [%get-tx-outset-info ~]"                               ::  Y / ?
  ::  %preciousblock: Treats a block as if it were received before
  ::  others with the same work.
  ::
  ":btc-node-hook|action [%precious-block hash]"                                ::  Y / Y
  ::  %pruneblockchain
  ::
  ":btc-node-hook|action [%prune-blockchain 1]"                                 ::  ?
  ::  %savemempool: Dumps the mempool to disk.
  ::  It will fail until the previous dump is fully loaded.
  ::
  ":btc-node-hook|action [%save-mempool ~]"                                     ::  Y / Y
  ::  %scantxoutset: Scans the unspent transaction output set for
  ::  entries that match certain output descriptors.
  ::
  :: action=?(%start %abort %status)
  :: scan-objects=(list scan-object)
  ::
  "=desc 'pkh([ca8a7ee5/0\'/0\'/3\']03137b4f2d8457209d894f8252fa797f3d619a042e76c0eb7da081aeb9c822b12a)#02m2zsxq'"
  "=s-o [desc ~]"
  ":btc-node-hook|action [%scan-tx-outset %start ~[desc]]"                      ::  Y / Y
  ":btc-node-hook|action [%scan-tx-outset %start s-o]"                          ::  Y / Y
  ::  %verifychain: Verifies blockchain database.
  ::
  ":btc-node-hook|action [%verify-chain ~ ~]"                                   ::  Y / Y
  ::  %verifytxoutproof: Verifies that a proof points to a transaction
  ::  in a block, returning the transaction it commits to
  ::  and throwing an RPC error if the block is not in our best chain
  ::
  ":btc-node-hook|action [%get-tx-out-proof ~[txid] ~]"
  "=proof 0x1.0000.305e.9156.83b5.c647.1a6e.04aa.9a53.a1a3.17b7.c3df.bfff.a4dc.42d9.e696.a65c.36b7.24ee.3cb5.db4d.a484.ff5e.95ad.1f04.8aa8.fb7f.1800.3fbe.4a2e.b529.4fa2.6c37.3265.ba0f.fb1a.5eff.ff7f.2000.0000.0001.0000.0001.ee3c.b5db.4da4.84ff.5e95.ad1f.048a.a8fb.7f18.003f.be4a.2eb5.294f.a26c.3732.65ba.0101"
  ":btc-node-hook|action [%verify-tx-out-proof proof]"                          ::  Y / Y
::  Raw Transactions
  ::
  ":btc-node-hook|action [%analyze-psbt psbt]"                                  ::  Y / Y
  ::  %combinepsbt: Combine multiple partially signed Bitcoin
  ::  transactions into one transaction.
  ::
  ":btc-node-hook|action [%combine-psbt ~[psbt pbt1]]"                          ::  Y / Y
  ::  %combinerawtransaction: Combine multiple partially signed t
  ::  ransactions into one transaction.
  ::
  ":btc-node-hook|action [%combine-raw-transaction ~[hex hex1]]"                ::  Y / Y
  ::  %converttopsbt: Converts a network serialized transaction to a PSBT.
  ::     hex-string=@ux
  ::     permit-sig-data=(unit ?)
  ::     is-witness=(unit ?)
  ::
  "=hex 0x200.0000.0001.0000.0000.0000.0000.056a.0301.0203.0000.0000"
  ":btc-node-hook|action [%convert-to-psbt hex ~ ~]"                            ::  Y / Y
  ::  %createpsbt: Creates a transaction in the Partially Signed
  ::  Transaction format.
  ::
  "=outs [[%data 0x1.0203] ~]"
  ":btc-node-hook|action [%create-psbt ~ outs ~ ~]"                             ::  Y / Y
  ::  %createrawtransaction: Create a transaction spending the given
  ::  inputs and creating new outputs.
  ::
  "=outputs [[%data 0x1.0203] ~]"
  ":btc-node-hook|action [%create-raw-transaction ~ outs ~ ~]"                  ::  Y / Y
  ::  %decodepsbt: Return a JSON object representing the serialized,
  ::  base64-encoded partially signed Bitcoin transaction.
  ::
  ":btc-node-hook|action [%decode-psbt psbt]"                                   ::  Y / Y
  ::  %decoderawtransaction: Return a JSON object representing the
  ::  serialized, hex-encoded transaction.
  ::
  ":btc-node-hook|action [%decode-raw-transaction hex |]"                       ::  Y / Y
  ::  %decodescript: Decode a hex-encoded script.
  ::
  ":btc-node-hook|action [%decode-script hex]"                                  ::  Y / Y
  ::  %finalizepsbt: Finalize the inputs of a PSBT.
  ::
  ":btc-node-hook|action [%finalize-psbt psbt ~]"                               ::  Y / X (! [%key 'psbt'])
  ::  %fundrawtransaction: Add inputs to a transaction until it has
  ::  enough in value to meet its out value.
  :: hex-string=@ux
  :: $=  options  %-  unit
  :: $:  change-address=(unit address)
  ::     change-position=(unit @ud)
  ::     change-type=(unit address-type)
  ::     include-watching=(unit ?)
  ::     lock-unspents=(unit ?)
  ::     fee-rate=(unit @t)
  ::     subtract-fee-from-outputs=(unit (list @ud))
  ::     replaceable=(unit ?)
  ::     conf-target=(unit @ud)
  ::     mode=(unit estimate-mode)
  :: ==
  :: is-witness=(unit ?)
  ::
  "=hex 0x200.0000.0001.0000.0000.0000.0000.056a.0301.0203.0000.0000"
  ":btc-node-hook|action [%fund-raw-transaction hex ~ |]"                       ::  Y
  "=options `[~ `1 `%legacy ~ ~ ~ ~ ~ `1 `%'ECONOMICAL']"
  ":btc-node-hook|action [%fund-raw-transaction hex options |]"                 ::  Y
  ":btc-node-hook|action [%sign-raw-transaction-with-wallet hex ~ ~]"
  ":btc-node-hook|action [%send-raw-transaction signed-hex *?]"
  ::  %getrawtransaction: Return the raw transaction data.
  ::
  "=txid 0x427b.882e.7ead.e462.fb5a.ca6c.56ce.6a72.2f18.6d37.d476.2774.714f.9237.14cc.eec5"
  ":btc-node-hook|action [%get-raw-transaction txid `& ~]"                      ::  Y / Y
  ":btc-node-hook|action [%get-raw-transaction txid ~ ~]"                       ::  Y / Y
  ::  %joinpsbts: Joins multiple distinct PSBTs with different inputs
  ::  and outputs into one PSBT with inputs and outputs from all of
  ::  the PSBTs
  ::
  "=psbt2 'cHNidP8BAGECAAAAAf3Urc9TSr3BJ4odajd8JKN5C7Gm6KC72q7J8WDxOQELAAAAAAAAAAAAAgAAAAAAAAAABWoDAQIDcOYFKgEAAAAXqRRTUwFpKgXt05k7RL8hOJKq1Dhw3ocAAAAAAAEBIADyBSoBAAAAF6kU+jfMIvFPGJtz6FrQnynkFV043vqHAQQWABSZv6w6KjZjONZ1r1JCDem4SVXxqQAAAQAWABQ2/vWHW66dSAANLzMKCRKaJmp91gA='"
  ":btc-node-hook|action [%join-psbts ~[psbt psbt2]]"                           ::  Y / Y
  ::  %sendrawtransaction: Submits raw transaction
  ::  (serialized, hex-encoded) to local node and network.
  ::
  "=outputs [[%data 0x5.0209] [0c2N41E7Ur6hASSWCPdmgt1MwHFy9mr5wMpwn '0.0001']~]"
  "=txid 0xba65.3237.6ca2.4f29.b52e.4abe.3f00.187f.fba8.8a04.1fad.955e.ff84.a44d.dbb5.3cee"
  "=inputs [txid 0 0]~"
  ":btc-node-hook|action [%create-raw-transaction inputs outputs ~ ~]"
  "=hex 0x2.0000.0001.b2c6.a14d.1a54.9beb.3d89.7c70.6a4e.6c27.1b3c.6d4d.9abd.d8b8.aa3c.31ee.863d.fbd9.0000.0000.0000.0000.0002.0000.0000.0000.0000.056a.0301.0205.1027.0000.0000.0000.1976.a914.5555.e170.3b39.90a3.8b56.e62a.f660.14c1.b18b.df87.88ac.0000.0000"
  "=privkey 'cVQykQVhiGf2cBxRkCAne9Qgt7yz74XA9Kp29pnAUC93TGc7j7yz'"
  ":btc-node-hook|action [%sign-raw-transaction-with-key hex ~[privkey] ~ ~]"
  "=signed-hex 0x2.0000.0000.0101.b2c6.a14d.1a54.9beb.3d89.7c70.6a4e.6c27.1b3c.6d4d.9abd.d8b8.aa3c.31ee.863d.fbd9.0000.0000.1716.0014.99bf.ac3a.2a36.6338.d675.af52.420d.e9b8.4955.f1a9.0000.0000.0200.0000.0000.0000.0005.6a03.0102.0510.2700.0000.0000.0019.76a9.1455.55e1.703b.3990.a38b.56e6.2af6.6014.c1b1.8bdf.8788.ac02.4730.4402.206a.4f04.4a6b.5bb1.5c4c.ca54.6384.0012.d722.dfea.af30.41a4.1bc2.ed86.f9c8.9cd4.e402.202b.a01f.6e6f.48c5.0f43.1edb.0310.ff42.a715.9250.5078.4931.4d6a.a039.4590.1fa6.d301.2102.7936.9dc8.1157.6fa0.c372.cc9d.1b1f.620c.6c5d.cf2d.1f04.0e8e.07d0.a79a.dd7e.36f5.0000.0000"
  ":btc-node-hook|action [%send-raw-transaction signed-hex *?]"                 ::  Y
  ::  %signrawtransactionwithkey: Sign inputs for raw transaction
  ::  (serialized, hex-encoded).
  ::
  ::  hex-string=@ux
  ::  priv-keys=(list @t)
  ::  prev-txs=(unit (list prev-tx))
  ::  =sig-hash-type
  ::
  "=hex 0x2.0000.0000.0101.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.ffff.ffff.0502.ca00.0101.ffff.ffff.0200.f902.9500.0000.0017.a914.fa37.cc22.f14f.189b.73e8.5ad0.9f29.e415.5d38.defa.8700.0000.0000.0000.0026.6a24.aa21.a9ed.e2f6.1c3f.71d1.defd.3fa9.99df.a369.5375.5c69.0689.7999.62b4.8beb.d836.974e.8cf9.0120.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000"
  "=privkey 'cQFQs6QBkLHRZHApwGwVJTPxjTK9XFg63tvrYJcQZRzVPXTEDaxL'"
  ":btc-node-hook|action [%sign-raw-transaction-with-key hex ~[privkey] ~ ~]"   ::  Y
  ::  %testmempoolaccept: Returns result of mempool acceptance tests
  ::  indicating if raw transaction (serialized, hex-encoded) would be
  ::  accepted by mempool.
  ::
  ":btc-node-hook|action [%test-mempool-accept ~[hex] ~]"                       ::  Y / Y
  ::  %utxoupdatepsbt: Updates a PSBT with witness UTXOs retrieved from
  ::  the UTXO set or the mempool.
  ::
  "=psbt 'cHNidP8BAGECAAAAAe48tdtNpIT/XpWtHwSKqPt/GAA/vkoutSlPomw3MmW6AAAAAAAAAAAAAnDtApUAAAAAF6kUrxlQrfcNttHcPY7D60KHOK65q96HAAAAAAAAAAAFagMBAgMAAAAAAAEBIAD5ApUAAAAAF6kU+jfMIvFPGJtz6FrQnynkFV043vqHAQQWABSZv6w6KjZjONZ1r1JCDem4SVXxqQABABYAFHtkC22llD4Per/ocWQCZkd9JGJnAAA='"
  ":btc-node-hook|action [%utxo-update-psbt psbt ~]"                            ::  Y / Y
::  Util
  ::  %createmultisig: Creates a multi-signature address with n signature
  ::  of m keys required. It returns a json object with the address and
  ::  redeemScript.
  "=n-required 1"
  "=pubkey 0x3.137b.4f2d.8457.209d.894f.8252.fa79.7f3d.619a.042e.76c0.eb7d.a081.aeb9.c822.b12a"
  ":btc-node-hook|action [%create-multi-sig n-required ~[pubkey] ~]"            :: Y / Y
  ::  %deriveaddresses: Derives one or more addresses corresponding to an
  ::  output descriptor.
  ::
  "=desc 'pkh([ca8a7ee5/0\'/0\'/3\']03137b4f2d8457209d894f8252fa797f3d619a042e76c0eb7da081aeb9c822b12a)#02m2zsxq'"
  ":btc-node-hook|action [%derive-addresses desc ~]"                            :: Y / Y
  ::  %estimatesmartfee: Estimates the approximate fee per kilobyte
  ::  needed for a transaction to begin confirmation within conf_target
  ::  blocks if possible and return the number of blocks for which the
  ::  estimate is valid.
  ::
  ":btc-node-hook|action [%estimate-smart-fee 1 ~]"                             :: Y / X ([%key 'feerate'])
  ::  %getdescriptorinfo: Analyses a descriptor.
  ::
  "=desc 'pkh([ca8a7ee5/0\'/0\'/3\']03137b4f2d8457209d894f8252fa797f3d619a042e76c0eb7da081aeb9c822b12a)#02m2zsxq'"
  ":btc-node-hook|action [%get-descriptor-info desc]"                           :: Y / Y
  ::  %signmessagewithprivkey: Sign a message with the private key of
  ::  an address
  ::
  ":btc-node-hook|action [%dump-privkey address]"
  "=privkey 'cQFQs6QBkLHRZHApwGwVJTPxjTK9XFg63tvrYJcQZRzVPXTEDaxL'"
  ":btc-node-hook|action [%sign-message-with-privkey privkey 'message']"        :: Y
  ::  %validateaddress: Return information about the given
  ::  bitcoin address.
  ::
  "=address 0cn1bExc9k899ncAreUbBfrSswitm7pGvz9A"
  ":btc-node-hook|action [%validate-address address]"                           :: Y / X (! [%key 'address'])
  ::  %verifymessage: Verify a signed message
  ::
  ":btc-node-hook|action [%get-new-address `'sign' `%'legacy']"
  "=address 0cn1bExc9k899ncAreUbBfrSswitm7pGvz9A"
  ":btc-node-hook|action [%sign-message address 'message']"
  "=signature 'H51j3cleCTwjeQUPpcjizWAP4rCYwG7XJo76kz1jb74CbAcQgwgghZfUE0Jt4JtKjD0yRgwmuwn+UiMpMJvZ4XI='"
  ":btc-node-hook|action [%verify-message address signature 'message']"         :: Y
  ::
::  Wallet
  ::
  ::  %abandon-transaction: Mark in-wallet transaction as abandoned.
  ::
  "=txid 0x427b.882e.7ead.e462.fb5a.ca6c.56ce.6a72.2f18.6d37.d476.2774.714f.9237.14cc.eec5"
  ":btc-node-hook|action [%abandon-transaction txid]"                           ::  Y
  ::  %abort-rescan: Stops current wallet rescan triggered by an
  ::  RPC call, e.g. by an importprivkey call.
  ::
  ":btc-node-hook|action [%abort-rescan ~]"                                     ::  Y
  ::  %add-multisig-address: Add a nrequired-to-sign multisignature
  ::  address to the wallet.
  ::       n-required=@ud
  ::       keys=(list address)
  ::       label=(unit @t)
  ::       address-type
  ::
  "=addrs ~[0c2MsucmvV5dMPEmeq17mUh6JAvg3ZUdBK87C 0c2N2jNiPqH9aVTMVnW45EyABURmHeTgYi72F 0c2N9V9Mfcnkqqnbz9woTuE5vzhHcxzomUhZZ]"
  ":btc-node-hook|action [%add-multisig-address 3 addrs `'mult' %p2sh-segwit]"  ::  Y
  ":btc-node-hook|action [%add-multisig-address 3 addrs `'mult' %legacy]"       ::  Y
  "=addrs ~[bech32+'bcrt1qkuv4mcl3g40xsdcwjxsw2d7hm8yavgsrel56qq']"
  ":btc-node-hook|action [%add-multisig-address 3 addrs `'mult' %bech32]"       ::  Y
  ::  %backupwallet: Safely copies current wallet file to destination.
  ::  destination=@t
  ::
  ":btc-node-hook|action [%backup-wallet 'destination']"                        ::  Y
  ::  %bump-fee: Bumps the fee of an opt-in-RBF transaction T, replacing
  ::  it with a new transaction B.
  ::
  ::  %-  unit
  :: $:  conf-target=(unit @t)
  ::     total-fee=(unit @t)
  ::     replaceable=(unit ?)
  ::     =estimate-mode
  :: ==
  ::
  "=txid 0x427b.882e.7ead.e462.fb5a.ca6c.56ce.6a72.2f18.6d37.d476.2774.714f.9237.14cc.eec5"
  ":btc-node-hook|action [%bump-fee txid ~]"                                    ::  Y
  ":btc-node-hook|action [%bump-fee txid `[~ `'1.0' `%.y `'ECONOMICAL']]"       ::  Y
  ":btc-node-hook|action [%bump-fee txid `[`1 ~ `%.y `%'ECONOMICAL']]"          ::  Y
  ::  %create-wallet: Creates and loads a new wallet.
  ::
  ::    - %name: The name for the new wallet.
  ::    - %disable-private-keys: Disable the possibility of private keys
  ::      (only watchonlys are possible in this mode).
  ::    - %blank: Create a blank wallet.
  ::      A blank wallet has no keys or HD seed.
  ::      One can be set using sethdseed.
  ::
  ":btc-node-hook|action [%create-wallet 'uno' ~ ~]"                            ::  Y
  ":btc-node-hook|action [%create-wallet 'dos' `%.y `%.y]"                      ::  Y
  ::  %dump-privkey: Reveals the private key corresponding to 'address'.
  ::
  ":btc-node-hook|action [%dump-privkey address]"                               ::  Y
  ::  %dump-wallet: Dumps all wallet keys in a human-readable format to
  ::  a server-side file.
  ::
  ":btc-node-hook|action [%dump-wallet 'filename']"                             ::  Y
  ::  %encrypt-wallet: Encrypts the wallet with 'passphrase'.
  ::
  ":btc-node-hook|action [%encrypt-wallet 'passphrase']"                        ::  Y
  ::  %get-addresses-by-label: Returns the list of addresses assigned the
  ::  specified label.
  ::
  ":btc-node-hook|action [%get-addresses-by-label 'label']"                     ::  Y
  ::  %get-address-info: Return information about the given bitcoin
  ::  address.
  ::
  "=addr 0c2NEWr8bGRVLJEGocdZbuy7jqUZJFqNf1Zck"
  ":btc-node-hook|action [%get-address-info addr]"                              ::  Y
  "=addr bech32+'bcrt1qkuv4mcl3g40xsdcwjxsw2d7hm8yavgsrel56qq'"
  ":btc-node-hook|action [%get-address-info addr]"                              ::  Y
  ::  %get-balance: Returns the total available balance.
  ::  dummy=(unit @t)
  ::  minconf=(unit @ud)
  ::  include-watch-only=(unit ?)
  ::
  ":btc-node-hook|action [%get-balance ~]"                                      ::  Y
  ":btc-node-hook|action [%get-balance `[`%'*' `23 `%.n]]"                         ::  Y
  ::  %get-new-address: Returns a new Bitcoin address for receiving
  ::  payments.
  ::  label=(unit @t) address-type=(unit address-type)
  ::
  ::  > :btc-node-hook|action [%get-new-address `'label' `%bech32]
  ::  [%get-new-address address=0c34ZAXddyPHS73fyhHdDB4Em2rYpQEBgEum]
  ::  > :btc-node-hook|action [%get-new-address `'label1' `%bech32]
  ::  [%get-new-address address=0c3Jsb5REZvw9FxFiDQtqN3HgxCuqw7XDZWV]
  ::  > :btc-node-hook|action [%get-new-address `'label2' `%bech32]
  ::  [%get-new-address address=0c3CMPrTmtHKDypw1Ksm4aW55XaNyEeVHdLd]
  ::  > :btc-node-hook|action [%get-new-address `'label3' `%p2sh-segwit]
  ::  [%get-new-address address=0c3HmPX3xaBC9P6q693P41biK5NctzkpyyaC]
  ::  > :btc-node-hook|action [%get-new-address `'label4' `%legacy]
  ::  [%get-new-address address=0c35ZcQHQ5mdzDae2Coc1cABJJtgrbHyehSz]
  ::
  ":btc-node-hook|action [%get-new-address `'label' `%bech32]"                  ::  Y
  ":btc-node-hook|action [%get-new-address `'label3' `%p2sh-segwit]"            ::  Y
  ":btc-node-hook|action [%get-new-address `'label4' `%legacy]"                 ::  Y
  ::  %get-raw-change-address: Returns a new Bitcoin address,
  ::  for receiving change.
  ::
  ":btc-node-hook|action [%get-raw-change-address `%bech32]"                    ::  Y
  ::  %get-received-by-address:  Returns the total amount received by the
  ::  given address in transactions with at least minconf confirmations.
  ::
  "=addr 0c2NEWr8bGRVLJEGocdZbuy7jqUZJFqNf1Zck"
  "=addr bech32+'bcrt1qkuv4mcl3g40xsdcwjxsw2d7hm8yavgsrel56qq'"
  ":btc-node-hook|action [%get-received-by-address addr 1]"                     ::  Y
  ::  %get-received-by-label:  Returns the total amount received by
  ::  addresses with <label> in transactions with at least [minconf]
  ::  confirmations.
  ::
  ":btc-node-hook|action [%get-received-by-label 'label3' `1]"                  ::  Y
  ::  %get-transaction:  Get detailed information about in-wallet
  ::  transaction <txid>
  ::
  ":btc-node-hook|action [%get-transaction txid `%.y ~]"                          ::  Y
  ::  %get-unconfirmed-balance:  Returns the server's total unconfirmed
  ::  balance
  ::
  ":btc-node-hook|action [%get-unconfirmed-balance ~]"                          ::  Y
  ::  %get-wallet-info:  Returns an object containing various wallet
  ::  state info.
  ::
  ":btc-node-hook|action [%get-wallet-info 'test']"                             ::  Y
  ":btc-node-hook|action [%get-wallet-info '']"                                 ::  Y
  ::  %import-address: Adds an address or script (in hex) that can be
  ::  watched as if it were in your wallet but cannot be used to spend.
  ::        address
  ::        label=(unit @t)
  ::        rescan=(unit ?)
  ::        p2sh=(unit ?)
  ::
  "=addr addr+0c2NEWr8bGRVLJEGocdZbuy7jqUZJFqNf1Zck"
  "=addr bech32+'bcrt1qkuv4mcl3g40xsdcwjxsw2d7hm8yavgsrel56qq'"
  "=addr script+0x0"
  "=addr bech32+'bcrt1qkuv4mcl3g40xsdcwjxsw2d7hm8yavgsrel56qq'"
  ":btc-node-hook|action [%import-address addr `'addr' `%.n `%.n]"              ::  Y
  ":btc-node-hook|action [%import-address addr `'bech32' `%.n `%.n]"            ::  Y
  ":btc-node-hook|action [%import-address addr `'script' `%.n `%.n]"            ::  Y
  ::  %import-multi: Import addresses/scripts (with private or public
  ::  keys, redeem script (P2SH)), optionally rescanning the blockchain
  ::  from the earliest creation time of the imported scripts.
  ::
  :: $:  desc=(unit @t)
  ::     $=  script-pubkey
  ::     $%  [%script s=@t]
  ::         [%address a=?(address [%bech32 @t])]
  ::     ==
  ::     timestamp=(unit ?(@da %now))
  ::     redeem-script=(unit @t)
  ::     witness-script=(unit @t)
  ::     pubkeys=(unit (list @t))
  ::     keys=(unit (list @t))
  ::     range=(unit ?(@ud [@ud @ud]))
  ::     internal=(unit ?)
  ::     watchonly=(unit ?)
  ::     label=(unit @t)
  ::     keypool=(unit ?)
  :: ==
  ::
  ::  Address created in another wallet
  ::
  "=i-r [~ address+0c2MyY7CAKpnyU27vURLKSQR1q3WNd5g32yyp %now ~ ~ ~ ~ ~ ~ ~ ~ ~]~"
  ":btc-node-hook|action [%import-multi i-r `|]"                                ::  Y
  ::  %import-privkey:  Adds a private key (as returned by dumpprivkey)
  ::  to your wallet.
  ::
  "=privkey 'cSun7g168F9DG7Xjd1yhkWrfKbfMWWSiWXAZ5ugLLAcoy2tckkBD'"
  ":btc-node-hook|action [%import-privkey privkey `'privkey' `%.n]"             ::  Y
  ::  %import-pruned-funds:  Imports funds without rescan.
  ::  raw-transaction=@t tx-out-proof=@t
  ::
  "=raw-transaction 0x2.0000.0000.0101.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.ffff.ffff.0502.ca00.0101.ffff.ffff.0200.f902.9500.0000.0017.a914.fa37.cc22.f14f.189b.73e8.5ad0.9f29.e415.5d38.defa.8700.0000.0000.0000.0026.6a24.aa21.a9ed.e2f6.1c3f.71d1.defd.3fa9.99df.a369.5375.5c69.0689.7999.62b4.8beb.d836.974e.8cf9.0120.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000"
  "=tx-out-proof 0x1.0000.305e.9156.83b5.c647.1a6e.04aa.9a53.a1a3.17b7.c3df.bfff.a4dc.42d9.e696.a65c.36b7.24ee.3cb5.db4d.a484.ff5e.95ad.1f04.8aa8.fb7f.1800.3fbe.4a2e.b529.4fa2.6c37.3265.ba0f.fb1a.5eff.ff7f.2000.0000.0001.0000.0001.ee3c.b5db.4da4.84ff.5e95.ad1f.048a.a8fb.7f18.003f.be4a.2eb5.294f.a26c.3732.65ba.0101"
  ":btc-node-hook|action [%import-pruned-funds raw-transaction tx-out-proof]"   ::  Y
  ::  %import-pubkey:  Adds a public key (in hex) that can be watched as
  ::  if it were in your wallet but cannot be used to spend.
  ::
  "=pubkey 0x3.4cef.939e.228d.a2f7.82d9.ce14.2d6c.a8c2.a2a7.857c.c219.bfee.fffd.f7dd.ebc2.be5f"
  "=label `'imported'"
  "=rescan `%.n"
  ":btc-node-hook|action [%import-pubkey pubkey label rescan]"                  ::  Y
  ::  %import-wallet:  Imports keys from a wallet dump file
  ::
  ":btc-node-hook|action [%import-wallet 'filename']"
  ::  %key-pool-refill:  Fills the keypool.
  ::
  ":btc-node-hook|action [%key-pool-refill ~]"                                  ::  Y
  ":btc-node-hook|action [%key-pool-refill `5]"                                 ::  Y
  ::  %list-address-groupings:  Lists groups of addresses which have had
  ::  their common ownership (made public by common use as inputs or as
  ::  the resulting change in past transactions)
  ::
  ":btc-node-hook|action [%list-address-groupings ~]"                           ::  Y
  ::  %list-labels:  Returns the list of all labels, or labels that are
  ::  assigned to addresses with a specific purpose.
  ::
  ":btc-node-hook|action [%list-labels ~]"                                      ::  Y
  ":btc-node-hook|action [%list-labels `%send]"                                 ::  Y
  ":btc-node-hook|action [%list-labels `%receive]"                              ::  Y
  ::  %list-lock-unspent:  Returns list of temporarily unspendable
  ::  outputs.
  ::
  ":btc-node-hook|action [%list-lock-unspent ~]"                                ::  Y
  ::  %list-received-by-address: List balances by receiving address.
  ::       minconf=(unit @ud)
  ::       include-empty=(unit ?)
  ::       include-watch-only=(unit ?)
  ::       address-filter=(unit @t)
  ::
  ":btc-node-hook|action [%list-received-by-address ~]"                         ::  Y
  ":btc-node-hook|action [%list-received-by-address `1 `| `| ~]"                ::  Y
  ::  %list-received-by-label: List received transactions by label.
  ::      minconf=(unit @ud)
  ::      include-empty=(unit ?)
  ::      include-watch-only=(unit ?)
  ::
  ":btc-node-hook|action [%list-received-by-label ~]"                           ::  Y
  ":btc-node-hook|action [%list-received-by-label `1 `| `|]"                    ::  Y
  ::  %lists-in-ceblock: Get all transactions in blocks since block
  ::  [blockhash], or all transactions if omitted.
  ::        blockhash=(unit blockhash)
  ::        target-confirmations=(unit @ud)
  ::        include-watch-only=(unit ?)
  ::        include-removed=(unit ?)
  ::
  ":btc-node-hook|action [%lists-in-ceblock ~]"                                 ::  Y
  "=h 0x3a47.188d.6065.233e.1c0f.97cf.ec4b.012c.beb6.ace2.604b.5a32.80f1.4412.631f.19c7"
  ":btc-node-hook|action [%lists-in-ceblock `h `1 `| `|]"                       ::  Y
  ::  %list-transactions: If a label name is provided, this will return
  ::  only incoming transactions paying to addresses with the specified
  ::  label.
  ::        label=(unit @t)
  ::        count=(unit @ud)
  ::        skip=(unit @ud)
  ::        include-watch-only=(unit ?)
  ::
  ":btc-node-hook|action [%list-transactions ~]"                                ::  Y
  ":btc-node-hook|action [%list-transactions `'label' `1 `1 `|]"                ::  Y
  ::  %list-unspent: Returns array of unspent transaction outputs
  ::  (with between minconf and maxconf (inclusive) confirmations.
  ::    minconf=(unit @ud)
  ::    maxconf=(unit @ud)
  ::    addresses=(unit (list @t))
  ::    include-unsafe=(unit ?)
  ::    $=  query-options  %-  unit
  ::    $:  minimum-amount=(unit @ud)
  ::        maximum-amount=(unit @ud)
  ::        maximum-count=(unit @ud)
  ::        minimum-sum-amount=(unit @ud)
  ::
  ":btc-node-hook|action [%list-unspent ~]"                                     ::  Y
  "=addr 0c2MxnKaTkg4mfQ7xNHzpddTiyfhs8ztJzn17"
  ":btc-node-hook|action [%list-unspent `1 `150 `~[addr] `| `[`0 `120 `120 `2]]"::  Y
  ::  %list-wallet-dir  Returns a list of wallets in the wallet directory.
  ::
  ":btc-node-hook|action [%list-wallet-dir ~]"                                  ::  Y
  ::  %list-wallets  Returns a list of currently loaded wallets.
  ::  (For full information on the wallet, use "getwalletinfo"
  ::
  ":btc-node-hook|action [%list-wallets ~]"                                     ::  Y
  ::  %load-wallet  Loads a wallet from a wallet file or directory.
  ::
  ":btc-node-hook|action [%load-wallet 'uno']"
  ::  %lock-unspent: Updates list of temporarily unspendable outputs.
  ::  unlock=?
  ::   transactions=(unit (list [txid=@ux vout=@ud]))
  ::
  "=tx 0xde1d.e97c.0301.b0af.026d.1a17.4cc7.e46c.b663.100e.073d.ad51.d26c.5532.78cb.4576z"
  ":btc-node-hook|action [%lock-unspent | `[tx 0]~]"                            ::  Y
  ::  %remove-pruned-funds  Deletes the specified transaction from the
  ::  wallet.
  ::
  ":btc-node-hook|action [%remove-pruned-funds txid]"                           ::  Y
  ::  %rescan-blockchain  Rescan the local blockchain for wallet related
  ::  transactions.
  ::  start-height=(unit @ud) stop-height=(unit @ud)
  ::
  ":btc-node-hook|action [%rescan-blockchain `0 `10]"                           ::  Y
  ::  %send-many: Send multiple times.
  ::  Amounts are double-precision floating point numbers.
  ::        dummy=%''
  ::        amounts=(list [address amount=@t])
  ::        minconf=(unit @ud)
  ::        comment=(unit @t)
  ::        subtract-fee-from=(unit (list address))
  ::        conf-target=(unit @ud)
  ::        estimate-mode=(unit @t)
  :: 1
  "=to [0c2MsucmvV5dMPEmeq17mUh6JAvg3ZUdBK87C '1']~"
  "=fee `~[0c2MxnKaTkg4mfQ7xNHzpddTiyfhs8ztJzn17]"
  ":btc-node-hook|action [%send-many %'' to `1 `'comm' fee `| `1 `%'UNSET']"    ::  Y
  ":btc-node-hook|action [%send-many %'' to ~ `'comm' ~ `| ~ ~]"                ::  Y
  ::  %send-to-address: Send an amount to a given address.
  ::        address
  ::        amount=@t
  ::        comment=(unit @t)
  ::        comment-to=(unit @t)
  ::        subtract-fee-from-amount=(unit ?)
  ::        replaceable=(unit ?)
  ::        conf-target=(unit @ud)
  ::        estimate-mode=(unit @t)
  ::
  ":btc-node-hook|action [%send-to-address address '1' `'comm' `'comm' `| `|  `1 `%'UNSET']"
  ::  %set-hd-seed: Set or generate a new HD wallet seed.
  ::  Non-HD wallets will not be upgraded to being a HD wallet.
  ::
  ":btc-node-hook|action [%set-hd-seed ~]"                                      ::  Y
  ::  %set-label:   Sets the label associated with the given address.
  ::
  ":btc-node-hook|action [%set-label address 'label']"                          ::  Y
  ::  %set-tx-fee: Set the transaction fee per kB for this wallet.
  ::
  ":btc-node-hook|action [%set-tx-fee '5']"                                     ::  Y
  ::  %sign-message:   Sign a message with the private key of an address
  ::
  ":btc-node-hook|action [%get-new-address `'sign' `%legacy]"
  "=address 0cmjiSfqxQeMsRgkEAddmdANrSVC6NU98wWF"
  ":btc-node-hook|action [%sign-message address 'message']"                     ::  Y
  ::  %sign-raw-transaction-with-wallet: Sign inputs for raw transaction
  ::  (serialized, hex-encoded).
  ::
  ::   $:  hex-string=@ux
  ::       prev-txs=(unit (list prev-tx))
  ::       =sig-hash-type
  ::   ==
  ::
  "=hex 0x2.0000.0000.0101.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.ffff.ffff.0502.ca00.0101.ffff.ffff.0200.f902.9500.0000.0017.a914.fa37.cc22.f14f.189b.73e8.5ad0.9f29.e415.5d38.defa.8700.0000.0000.0000.0026.6a24.aa21.a9ed.e2f6.1c3f.71d1.defd.3fa9.99df.a369.5375.5c69.0689.7999.62b4.8beb.d836.974e.8cf9.0120.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000.0000"
  ":btc-node-hook|action [%sign-raw-transaction-with-wallet hex ~ ~]"           ::  Y
  "=prevtx 0xefd3.369e.1338.6cd7.357d.d2bc.249f.8d0a.a9e2.a1c7.4271.0693.bf16.e45f.81b9.4433"
  "=script-pubkey 0xa9.1476.03a9.eabd.c983.6eb8.dc6c.4ed0.8d92.106d.2c97.aa87"
  "=prev ~[prevtx 0 script-pubkey ~ ~ ~]"
  ":btc-node-hook|action [%sign-raw-transaction-with-wallet hex `prev ~]"       ::  Y
  ::  %unload-wallet:   Unloads the wallet referenced by the request
  ::  endpoint otherwise unloads the wallet specified in the argument.
  ::
  ":btc-node-hook|action [%unload-wallet `'test']"                              ::  Y
  ::  %wallet-create-fundedpsbt: Creates and funds a transaction in the
  ::  Partially Signed Transaction format.
  ::  Inputs will be added if supplied inputs are not enough
  ::
  ::        inputs=(list input)
  ::        outputs=output
  ::        locktime=(unit @ud)
  ::        $=  options  %-  unit
  ::        $:  change-address=(unit @uc)
  ::            change-position=(unit @ud)
  ::            change-type=(unit address-type)
  ::            include-watching=(unit ?)
  ::            lock-unspents=(unit ?)
  ::            fee-rate=(unit @t)
  ::            subtract-fee-from-outputs=(unit (list @ud))
  ::            replaceable=(unit ?)
  ::            conf-target=(unit @ud)
  ::            =estimate-mode
  ::        ==
  ::        bip32-derivs=(unit ?)
  ::
  ::  txid with amount='25.00000000'
  ::
  "=txid 0xba65.3237.6ca2.4f29.b52e.4abe.3f00.187f.fba8.8a04.1fad.955e.ff84.a44d.dbb5.3cee"
  "=inputs [txid 0 0]~"
  "=outputs [[%data 0x1.0203] ~]"
  "=options `[~ `1 `%legacy `& `& ~ `~[1] `& `1 `%'ECONOMICAL']"
  "=options `[~ `1 `%legacy `& `& ~ `~[1] `& `1 `%'ECONOMICAL']"
  ":btc-node-hook|action [%wallet-create-fundedpsbt inputs outputs ~ options ~]"      ::  Y
  ::>=
  :: [ %wallet-create-fundedpsbt
  ::     psbt
  ::   \/'cHNidP8BAGECAAAAAe48tdtNpIT/XpWtHwSKqPt/GAA/vkoutSlPomw3MmW6AAAAAAAAAAAAAnDtApUAAAAAF6kUrxlQrfcNttHcPY7D60KHOK65q96HAAAA\/
  ::     AAAAAAAFagMBAgMAAAAAAAEBIAD5ApUAAAAAF6kU+jfMIvFPGJtz6FrQnynkFV043vqHAQQWABSZv6w6KjZjONZ1r1JCDem4SVXxqQABABYAFHtkC22llD4Pe
  ::     r/ocWQCZkd9JGJnAAA='
  ::   \/                                                                                                                         \/
  ::   fee='0.00002960'
  ::   changepos=0
  :: ]
  ::
  ::  %wallet-lock:   Removes the wallet encryption key from memory,
  ::  locking the wallet.
  ::
  ":btc-node-hook|action [%wallet-lock ~]"                                      ::  Y
  ::  %wallet-passphrase:   Stores the wallet decryption key in memory
  ::  for 'timeout' seconds.
  ::
  ":btc-node-hook|action [%wallet-passphrase 'pass' 20]"                        ::  Y
  ::  %wallet-passphrase-changehange: s the wallet passphrase from
  ::  'oldpassphrase' to 'newpassphrase'.
  ::
  ":btc-node-hook|action [%wallet-passphrase-change `'pass' `'pass.2']"         ::  Y
  ::  %wallet-process-psbt: Update a PSBT with input information from
  ::  our wallet and then sign inputs
  ::              psbt=@t
  ::              sign=?
  ::              =sig-hash
  ::              bip32-derivs=(unit ?)
  ::
  ::  txid with amount='25.00000000'
  ::
  "=psbt 'cHNidP8BAGECAAAAAe48tdtNpIT/XpWtHwSKqPt/GAA/vkoutSlPomw3MmW6AAAAAAAAAAAAAnDtApUAAAAAF6kUrxlQrfcNttHcPY7D60KHOK65q96HAAAAAAAAAAAFagMBAgMAAAAAAAEBIAD5ApUAAAAAF6kU+jfMIvFPGJtz6FrQnynkFV043vqHAQQWABSZv6w6KjZjONZ1r1JCDem4SVXxqQABABYAFHtkC22llD4Per/ocWQCZkd9JGJnAAA='"
  ":btc-node-hook|action [%wallet-process-psbt psbt | %'ALL' ~]"                ::  Y
  ::  ZMQ management
  ::
  ":btc-node-hook|action [%get-zmq-notifications ~]"                            ::  ?

;<  ~  bind:m  end-simple
(pure:m *vase)

:: ;<  ~  bind:m  (just-events (dojo ~bud "|start %btc-node-store"))
:: ;<  ~  bind:m  (just-events (dojo ~bud "|start %btc-node-hook"))
:: ::
:: :: ;<  ~  bind:m  (just-events (dojo ~bud ":btc-node-hook|action [%create-wallet 'test2' ~ ~]"))
:: :: ;<  ~  bind:m  (wait-for-dojo ~bud "create-wallet")
:: :: ::
:: ;<  ~  bind:m  (just-events (dojo ~bud ":btc-node-hook|action [%get-balance 'test2' ~ ~ ~]"))
:: ;<  ~  bind:m  (wait-for-dojo ~bud "get-balance")
:: ::
:: ;<  ~  bind:m  (just-events (dojo ~bud ":btc-node-hook|action [%list-wallets ~]"))
:: ;<  ~  bind:m  (wait-for-dojo ~bud "list-wallets")
:: ::
:: ;<  ~  bind:m  (just-events (dojo ~bud ":btc-node-hook|action [%list-transactions ~ ~ ~ ~]"))
:: ;<  ~  bind:m  (wait-for-dojo ~bud "list-transactions")
:: ::
:: ~&  >  'DONE'
:: (pure:m ~)
