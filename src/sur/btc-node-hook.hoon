=>  ::  Helper types used within and outside the library
    ::
    |%
    ::  %address: base58check encoded public key (20 bytes)
    ::
    ++  address  @uc
    ++  blockhash  @ux
    ::  Helper types
    ::
    +$  sig-hash
      $?  %'ALL'
          %'NONE'
          %'SINGLE'
          %'ALL|ANYONECANPAY'
          %'NONE|ANYONECANPAY'
          %'SINGLE|ANYONECANPAY'
      ==
    ::
    +$  sig-hash-type  (unit sig-hash)
    ::
    +$  estimate-mode  (unit ?(%'ECONOMICAL' %'CONSERVATIVE' %'UNSET'))
    ::
    +$  category  ?(%send %receive %generate %immature %orphan)
    ::
    +$  chain-status
      $?  %invalid
          %headers-only
          %valid-headers
          %valid-fork
          %active
      ==
    ::
    +$  soft-fork-status  ?(%defined %started %locked-in %active %failed)
    ::
    +$  purpose  ?(%send %receive)
    ::
    +$  address-type  ?(%legacy %p2sh-segwit %bech32)
    ::
    +$  bip125-replaceable  ?(%yes %no %unknown)
    ::
    +$  network-name  ?(%main %test %regtest)
    ::
    ::  FIXME: map instead of list produces a mint-vain
    +$  bip32-derivs  %-  unit  %-  list
        $:  pubkey=@ux
            $:  master-fingerprint=@t
                path=@t
        ==  ==
    ::  For redeem/witness script
    ::
    +$  script  [asm=@t hex=@ux type=@t]
    ::
    +$  script-pubkey  [asm=@t hex=@ux type=@t =address]
    ::
    +$  range  (unit ?(@ud [@ud @ud]))
    ::
    +$  vin
      $:  txid=@ux
          vout=@ud
          script-sig=[asm=@t hex=@ux]
          tx-in-witness=(list @ux)
          sequence=@ud
      ==
    ::
    +$  vout
      $:  value=@t
          n=@ud
          $=  script-pubkey
          $:  asm=@t
              hex=@ux
              req-sigs=@ud
              type=@t
              addresses=(list address)
      ==  ==
    ::
    +$  input
      $:  txid=@ux
          vout=@ud
          sequence=@ud
      ==
    ::
    +$  output
      $:  data=[%data @ux]
          addresses=(list [=address amount=@t])
      ==
    ::
    +$  scan-object
      $?  descriptor=@t
          $=  object
          $:  desc=@t
              range=(unit ?(@ud [@ud @ud]))
      ==  ==
    ::
    +$  utxo  %-  unit
      $:  amount=@t
          =script-pubkey
      ==
    ::
    +$  partially-signed-transaction
      $:  inputs=(list input)
          outputs=output
          locktime=(unit @ud)
          replaceable=(unit ?)
      ==
    ::
    +$  import-request
      $:  desc=@t
          $=  script-pubkey
          $%  [%script s=@t]
              [%address a=address]
          ==
          timestamp=?(@da %now)
          redeem-script=@t
          witness-script=@t
          pubkeys=(unit (list @t))
          keys=(unit (list @t))
          range=?(@ud [@ud @ud])
          internal=?
          watchonly=?
          label=@t
          keypool=?
      ==
    ::
    +$  serialized-tx
      $:  txid=@ux
          hash=@ux
          size=@ud
          vsize=@ud
          weight=@ud
          version=@ud
          locktime=@ud
          vin=(list vin)
          vout=(list vout)
      ==
    ::
    +$  prev-tx
      $:  txid=@ux
          vout=@ud
          script-pubkey=@ux
          redeem-script=@ux
          witness-script=@ux
          amount=@t
      ==
    ::
    +$  raw-tx
      $:  hex-string=@ux
          prev-txs=(unit (list prev-tx))
          =sig-hash-type
      ==
    ::
    +$  raw-transaction-rpc-out
      $:  in-active-chain=?
          hex=@ux
          txid=@ux
          hash=@ux
          size=@ud
          vsize=@ud
          weight=@ud
          version=@t
          locktime=@ud
          vin=(list vin)
          vout=(list vout)
          =blockhash
          confirmations=@ud
          blocktime=@ud
          time=@ud
      ==
    ::
    +$  tx-in-block
      $:  =address
          =category
          amount=@t
          label=@t
          vout=@ud
          fee=@t
          confirmations=@ud
          blockhash=@ux
          blockindex=@ud
          blocktime=@ud
          txid=@ux
          time=@ud
          time-received=@ud
          =bip125-replaceable
          abandoned=?
          comment=@t
          label=@t
          to=@t
      ==
    ::
    +$  errors  %-  list
      $:  txid=@ux
          vout=@ud
          script-sig=@ux
          sequence=@ud
          error=@t
      ==
    ::
    +$  mem-pool
      $:  size=@ud
          fee=@t
          modified-fee=@t
          time=@ud
          height=@ud
          descendant-count=@ud
          descendant-size=@ud
          descendant-fees=@t
          ancestor-count=@ud
          ancestor-size=@ud
          ancestor-fees=@t
          w-txid=@ux
          $=  fees
          $:  base=@t
              modified=@t
              ancestor=@t
              descendant=@t
          ==
          depends=(list @ux)
          spent-by=(list @ux)
          bip125-replaceable=?
      ==
    ::
    +$  mem-pool-response  %-  list
      ::  FIXME: a list for ux and map for the cell
      ::  produce a fish-loop
      ::
      $?  ::  (for verbose = false)
          ::
          @ux                      :: (list @ux)
          ::  (for verbose = true)
          ::
          [id=@ux =mem-pool]       :: (map id=@ux mem-pool)
      ==
    --
|%
::
+$  btc-node-hook-action    request:btc-rpc
+$  btc-node-hook-response  response:btc-rpc
::
++  btc-rpc
  |%
  +$  request
    $%
    ::  Blockchain
    ::
        ::  %getbestblockhash: Returns the hash of the
        ::  best (tip) block in the longest blockchain.
        ::
        [%get-best-block-hash ~]
        ::  %getblock: Returns an Object/string with information about block
        ::
        [%get-block blockhash=@ux verbosity=(unit ?(%0 %1 %2))]
        ::  %getblockchaininfo: Returns info regarding blockchain processing.
        ::
        [%get-blockchain-info ~]
        ::  %getblockcount: Returns number of blocks in the longest blockchain.
        ::
        [%get-block-count ~]
        ::  %getblockhash: Returns hash of block in best-block-chain at height.
        ::
        [%get-block-hash height=@ud]
        ::  %getblockheader: If verbose is false, returns a string that is
        ::  serialized, hex-encoded data for blockheader 'hash'. If verbose is
        ::  true, returns an Object
        ::
        [%get-block-header blockhash=@ux verbose=(unit ?)]
        ::  %getblockstats: Compute per block statistics for a given window.
        ::
        $:  %get-block-stats
            $=  hash-or-height
            $%  [%hex @ux]
                [%num @ud]
            ==
            stats=(unit (list @t))
        ==
        ::  %getchaintips: Return information about tips in the block tree.
        ::
        [%get-chain-tips ~]
        ::  %getchaintxstats: Compute statistics about total number rate
        ::  of transactions in the chain.
        ::
        [%get-chain-tx-stats n-blocks=(unit @ud) blockhash=(unit @ux)]
        ::  %getdifficulty: Returns the proof-of-work difficulty as a multiple
        ::  of the minimum difficulty.
        ::
        [%get-difficulty ~]
        ::  %getmempoolancestors: If txid is in the mempool, returns
        ::  all in-mempool ancestors.
        ::
        [%get-mempool-ancestors txid=@ux verbose=(unit ?)]
        ::  %getmempooldescendants: If txid is in the mempool, returns
        ::  all in-mempool descendants.
        ::
        [%get-mempool-descendants txid=@ux verbose=(unit ?)]
        ::  %getmempoolentry: Returns mempool data for given transaction
        ::
        [%get-mempool-entry txid=@ux]
        ::  %getmempoolinfo: Returns details on the active state of the
        ::  TX memory pool.
        ::
        [%get-mempool-info ~]
        ::  %getrawmempool: Returns all transaction ids in memory pool as a
        ::  json array of string transaction ids.
        ::
        [%get-raw-mempool verbose=(unit ?)]
        ::  %gettxout: Returns details about an unspent transaction output.
        ::
        [%get-tx-out txid=@ux n=@ud include-mempool=(unit ?)]
        ::  %gettxoutproof: Returns a hex-encoded proof that "txid" was
        ::  included in a block.
        ::
        [%get-tx-out-proof tx-ids=(list @ux) blockhash=(unit @ux)]
        ::  %gettxoutsetinfo: Returns statistics about the unspent transaction
        ::  output set.
        ::
        [%get-tx-outset-info ~]
        ::  %preciousblock: Treats a block as if it were received before
        ::  others with the same work.
        ::
        [%precious-block blockhash=@ux]
        ::  %pruneblockchain
        ::
        [%prune-blockchain height=@ud]
        ::  %savemempool: Dumps the mempool to disk.
        ::  It will fail until the previous dump is fully loaded.
        ::
        [%save-mempool ~]
        ::  %scantxoutset: Scans the unspent transaction output set for
        ::  entries that match certain output descriptors.
        ::
        $:  %scan-tx-outset
            action=?(%start %abort %status)
            scan-objects=(list scan-object)
        ==
        ::  %verifychain: Verifies blockchain database.
        ::
        [%verify-chain check-level=(unit @ud) n-blocks=(unit @ud)]
        ::  %verifytxoutproof: Verifies that a proof points to a transaction
        ::  in a block, returning the transaction it commits to
        :: and throwing an RPC error if the block is not in our best chain
        ::
        [%verify-tx-out-proof proof=@t]
    ::  Control
    ::
        [%help command=(unit @t)]
    ::  Generating
    ::
        [%generate blocks=@ud max-tries=(unit @ud)]
    ::  Raw Transactions
    ::
        ::  %analyzepsbt: Analyzes and provides information about
        ::  the current status of a PSBT and its inputs
        ::
        [%analyze-psbt psbt=@t]
        ::  %combinepsbt: Combine multiple partially signed Bitcoin
        ::  transactions into one transaction.
        ::
        [%combine-psbt txs=(list @t)]
        ::  %combinerawtransaction: Combine multiple partially signed t
        ::  ransactions into one transaction.
        ::
        [%combine-raw-transaction txs=(list @ux)]
        ::  %converttopsbt: Converts a network serialized transaction to a PSBT.
        ::
        $:  %convert-to-psbt
            hex-string=@ux
            permit-sig-data=(unit ?)
            is-witness=(unit ?)
        ==
        ::  %createpsbt: Creates a transaction in the Partially Signed
        ::  Transaction format.
        ::
        [%create-psbt partially-signed-transaction]
        ::  %createrawtransaction: Create a transaction spending the given
        ::  inputs and creating new outputs.
        ::
        [%create-raw-transaction partially-signed-transaction]
        ::  %decodepsbt: Return a JSON object representing the serialized,
        ::  base64-encoded partially signed Bitcoin transaction.
        ::
        [%decode-psbt psbt=@t]
        ::  %decoderawtransaction: Return a JSON object representing the
        ::  serialized, hex-encoded transaction.
        ::
        [%decode-raw-transaction hex-string=@ux is-witness=(unit ?)]
        ::  %decodescript: Decode a hex-encoded script.
        ::
        [%decode-script hex-string=@ux]
        ::  %finalizepsbt: Finalize the inputs of a PSBT.
        ::
        [%finalize-psbt psbt=@t extract=(unit ?)]
        ::  %fundrawtransaction: Add inputs to a transaction until it has
        ::  enough in value to meet its out value.
        ::
        $:  %fund-raw-transaction
            hex-string=@ux
            $=  options  %-  unit
            $:  change-address=(unit address)
                change-position=(unit @ud)
                change-type=(unit address-type)
                include-watching=(unit ?)
                lock-unspents=(unit ?)
                fee-rate=(unit @t)
                subtract-fee-from-outputs=(unit (list @ud))
                replaceable=(unit ?)
                conf-target=(unit @ud)
                =estimate-mode
            ==
            is-witness=(unit ?)
        ==
        ::  %getrawtransaction: Return the raw transaction data.
        ::
        [%get-raw-transaction txid=@ux verbose=(unit ?) blockhash=(unit @ux)]
        ::  %joinpsbts: Joins multiple distinct PSBTs with different inputs
        ::  and outputs into one PSBT with inputs and outputs from all of
        ::  the PSBTs
        ::
        [%join-psbts txs=(list @t)]
        ::  %sendrawtransaction: Submits raw transaction
        ::  (serialized, hex-encoded) to local node and network.
        ::
        [%send-raw-transaction hex-string=@ux allow-high-fees=(unit ?)]
        ::  %signrawtransactionwithkey: Sign inputs for raw transaction
        ::  (serialized, hex-encoded).
        ::
        $:  %sign-raw-transaction-with-key
            hex-string=@ux
            priv-keys=(list @t)
            prev-txs=(unit (list prev-tx))
            =sig-hash-type
        ==
        ::  %testmempoolaccept: Returns result of mempool acceptance tests
        ::  indicating if raw transaction (serialized, hex-encoded) would be
        ::  accepted by mempool.
        ::
        [%test-mempool-accept raw-txs=(list @ux) allow-high-fees=(unit ?)]
        ::  %utxoupdatepsbt: Updates a PSBT with witness UTXOs retrieved from
        ::  the UTXO set or the mempool.
        ::
        [%utxo-update-psbt psbt=@t]
    ::  Util
    ::
        ::  %createmultisig: Creates a multi-signature address with n signature
        ::  of m keys required. It returns a json object with the address and
        ::  redeemScript.
        ::
        [%create-multi-sig n-required=@ud keys=(list @ux) address-type=(unit address-type)]
        ::  %deriveaddresses: Derives one or more addresses corresponding to an
        ::  output descriptor. Examples of output descriptors are:
        ::
        [%derive-addresses descriptor=@t range=(unit ?(@ud [@ud @ud]))]
        ::  %estimatesmartfee: Estimates the approximate fee per kilobyte
        ::  needed for a transaction to begin confirmation within conf_target
        ::  blocks if possible and return the number of blocks for which the
        ::  estimate is valid.
        ::
        [%estimate-smart-fee conf-target=@ud =estimate-mode]
        ::  %getdescriptorinfo: Analyses a descriptor.
        ::
        [%get-descriptor-info descriptor=@t]
        ::  %signmessagewithprivkey: Sign a message with the private key of
        ::  an address
        ::
        [%sign-message-with-privkey privkey=@t message=@t]
        ::  %validateaddress: Return information about the given
        ::  bitcoin address.
        ::
        [%validate-address =address]
        ::  %verifymessage: Verify a signed message
        ::
        [%verify-message =address signature=@t message=@t]
    ::  Wallet
    ::
        ::  %abandon-transaction: Mark in-wallet transaction as abandoned.
        ::
        [%abandon-transaction txid=@ux]
        ::  %abort-rescan: Stops current wallet rescan triggered by an
        ::  RPC call, e.g. by an importprivkey call.
        ::
        [%abort-rescan ~]
        ::  %add-multisig-address: Add a nrequired-to-sign multisignature
        ::  address to the wallet.
        ::
        $:  %add-multisig-address
            n-required=@ud
            keys=(list address)
            label=(unit @t)
            =address-type
        ==
        ::  %backupwallet: Safely copies current wallet file to destination.
        ::
        [%backup-wallet destination=@t]
        ::  %bump-fee: Bumps the fee of an opt-in-RBF transaction T, replacing
        ::  it with a new transaction B.
        ::
        $:  %bump-fee
            txid=@ux
            $=  options  %-  unit
            $:  conf-target=(unit @t)
                total-fee=(unit @t)
                replaceable=(unit ?)
                =estimate-mode
            ==
        ==
        ::  %create-wallet: Creates and loads a new wallet.
        ::
        ::    - %name: The name for the new wallet.
        ::    - %disable-private-keys: Disable the possibility of private keys
        ::      (only watchonlys are possible in this mode).
        ::    - %blank: Create a blank wallet.
        ::      A blank wallet has no keys or HD seed.
        ::      One can be set using sethdseed.
        ::
        [%create-wallet name=@t disable-private-keys=(unit ?) blank=(unit ?)]
        ::  %dump-privkey: Reveals the private key corresponding to 'address'.
        ::
        [%dump-privkey =address]
        ::  %dump-wallet: Dumps all wallet keys in a human-readable format to
        ::  a server-side file.
        ::
        [%dump-wallet filename=@t]
        ::  %encrypt-wallet: Encrypts the wallet with 'passphrase'.
        ::
        [%encrypt-wallet passphrase=@t]
        ::  %get-addresses-by-label: Returns the list of addresses assigned the
        ::  specified label.
        ::
        [%get-addresses-by-label label=@t]
        ::  %get-address-info: Return information about the given bitcoin
        ::  address.
        ::
        [%get-address-info wallet=@t =address]
        ::  %get-balance: Returns the total available balance.
        ::
        $:  %get-balance
            wallet=@t
            dummy=(unit @t)
            minconf=(unit @ud)
            include-watch-only=(unit ?)
        ==
        ::  %get-new-address: Returns a new Bitcoin address for receiving
        ::  payments.
        ::
        [%get-new-address label=(unit @t) address-type=(unit address-type)]
        ::  %get-raw-change-address: Returns a new Bitcoin address,
        ::  for receiving change.
        ::
        [%get-raw-change-address address-type=(unit address-type)]
        ::  %get-received-by-address:  Returns the total amount received by the
        ::  given address in transactions with at least minconf confirmations.
        ::
        [%get-received-by-address =address minconf=@ud]
        ::  %get-received-by-label:  Returns the total amount received by
        ::  addresses with <label> in transactions with at least [minconf]
        ::  confirmations.
        ::
        [%get-received-by-label label=@t minconf=(unit @ud)]
        ::  %get-transaction:  Get detailed information about in-wallet
        ::  transaction <txid>
        ::
        [%get-transaction txid=@ux include-watch-only=(unit ?)]
        ::  %get-unconfirmed-balance:  Returns the server's total unconfirmed
        ::  balance
        ::
        [%get-unconfirmed-balance ~]
        ::  %get-wallet-info:  Returns an object containing various wallet
        ::  state info.
        ::
        [%get-wallet-info name=@t]
        ::  %import-address: Adds an address or script (in hex) that can be
        ::  watched as if it were in your wallet but cannot be used to spend.
        ::
        $:  %import-address
            =address
            label=(unit @t)
            rescan=(unit ?)
            p2sh=(unit ?)
        ==
        ::  %import-multi: Import addresses/scripts (with private or public
        ::  keys, redeem script (P2SH)), optionally rescanning the blockchain
        ::  from the earliest creation time of the imported scripts.
        ::
        $:  %import-multi
            requests=(list import-request)
            options=(unit rescan=?)
        ==
        ::  %import-privkey:  Adds a private key (as returned by dumpprivkey)
        ::  to your wallet.
        ::
        [%import-privkey privkey=@t label=(unit @t) rescan=(unit ?)]
        ::  %import-pruned-funds:  Imports funds without rescan.
        ::
        [%import-pruned-funds raw-transaction=@t tx-out-proof=@t]
        ::  %import-pubkey:  Adds a public key (in hex) that can be watched as
        ::  if it were in your wallet but cannot be used to spend.
        ::
        [%import-pubkey pubkey=@ux label=(unit @t) rescan=(unit ?)]
        ::  %import-wallet:  Imports keys from a wallet dump file
        ::
        [%import-wallet filename=@t]
        ::  %key-pool-refill:  Fills the keypool.
        ::
        [%key-pool-refill new-size=(unit @ud)]
        ::  %list-address-groupings:  Lists groups of addresses which have had
        ::  their common ownership (made public by common use as inputs or as
        ::  the resulting change in past transactions)
        ::
        [%list-address-groupings ~]
        ::  %list-labels:  Returns the list of all labels, or labels that are
        ::  assigned to addresses with a specific purpose.
        ::
        [%list-labels purpose=(unit purpose)]
        ::  %list-lock-unspent:  Returns list of temporarily unspendable
        ::  outputs.
        ::
        [%list-lock-unspent ~]
        ::  %list-received-by-address: List balances by receiving address.
        ::
        $:  %list-received-by-address
            $?  ~
                $:  minconf=(unit @ud)
                    include-empty=(unit ?)
                    include-watch-only=(unit ?)
                    address-filter=(unit @t)
        ==  ==  ==
        ::  %list-received-by-label: List received transactions by label.
        ::
        $:  %list-received-by-label
            $?  ~
                $:  minconf=(unit @ud)
                    include-empty=(unit ?)
                    include-watch-only=(unit ?)
        ==  ==  ==
        ::  %lists-in-ceblock: Get all transactions in blocks since block
        ::  [blockhash], or all transactions if omitted.
        ::
        $:  %lists-in-ceblock
            $?  ~
                $:  blockhash=(unit blockhash)
                    target-confirmations=(unit @ud)
                    include-watch-only=(unit ?)
                    include-removed=(unit ?)
        ==  ==  ==
        ::  %list-transactions: If a label name is provided, this will return
        ::  only incoming transactions paying to addresses with the specified
        ::  label.
        ::
        $:  %list-transactions
            $?  ~
                $:  label=(unit @t)
                    count=(unit @ud)
                    skip=(unit @ud)
                    include-watch-only=(unit ?)
        ==  ==  ==
        ::  %list-unspent: Returns array of unspent transaction outputs
        ::  (with between minconf and maxconf (inclusive) confirmations.
        ::
        $:  %list-unspent
            $?  ~
                $:  minconf=(unit @t)
                    maxconf=(unit @ud)
                    addresses=(unit (list @t))
                    include-unsafe=(unit ?)
                    $=  query-options  %-  unit
                    $:  minimum-amount=(unit @t)
                        maximum-amount=(unit @t)
                        maximum-count=(unit @t)
                        minimum-sum-amount=(unit @t)
        ==  ==  ==  ==
        ::  %list-wallet-dir  Returns a list of wallets in the wallet directory.
        ::
        [%list-wallet-dir ~]
        ::  %list-wallets  Returns a list of currently loaded wallets.
        ::  (For full information on the wallet, use "getwalletinfo"
        ::
        [%list-wallets ~]
        ::  %load-wallet  Loads a wallet from a wallet file or directory.
        ::
        [%load-wallet filename=@t]
        ::  %lock-unspent: Updates list of temporarily unspendable outputs.
        ::
        $:  %lock-unspent
            unlock=?
            transactions=(unit (list [txid=@ux vout=@ud]))
        ==
        ::  %remove-pruned-funds  Deletes the specified transaction from the
        ::  wallet.
        ::
        [%remove-pruned-funds txid=@ux]
        ::  %rescan-blockchain  Rescan the local blockchain for wallet related
        ::  transactions.
        ::
        [%rescan-blockchain start-height=(unit @ud) stop-height=(unit @ud)]
        ::  %send-many: Send multiple times.
        ::  Amounts are double-precision floating point numbers.
        ::
        $:  %send-many
            dummy=%''
            amounts=(list [=address amount=@t])
            minconf=(unit @ud)
            comment=(unit @t)
            subtract-fee-from=(unit (list address))
            :: subtract-fee-from=(unit (list address))
            conf-target=(unit @ud)
            estimate-mode=(unit @t)
        ==
        ::  %send-to-address: Send an amount to a given address.
        ::
        $:  %send-to-address
            =address
            amount=@t
            comment=(unit @t)
            comment-to=(unit @t)
            subtract-fee-from-amount=(unit ?)
            replaceable=(unit ?)
            conf-target=(unit @ud)
            estimate-mode=(unit @t)
        ==
        ::  %set-hd-seed: Set or generate a new HD wallet seed.
        ::  Non-HD wallets will not be upgraded to being a HD wallet.
        ::
        [%set-hd-seed ~]
        ::  %set-label:   Sets the label associated with the given address.
        ::
        [%set-label =address label=@t]
        ::  %set-tx-fee: Set the transaction fee per kB for this wallet.
        ::
        [%set-tx-fee amount=@t]
        ::  %sign-message:   Sign a message with the private key of an address
        ::
        [%sign-message =address message=@t]
        ::  %sign-raw-transaction-with-wallet: Sign inputs for raw transaction
        ::  (serialized, hex-encoded).
        ::
        [%sign-raw-transaction-with-wallet raw-tx]
        ::  %unload-wallet:   Unloads the wallet referenced by the request
        ::  endpoint otherwise unloads the wallet specified in the argument.
        ::
        [%unload-wallet wallet-name=(unit @t)]
        ::  %wallet-create-fundedpsbt: Creates and funds a transaction in the
        ::  Partially Signed Transaction format.
        ::  Inputs will be added if supplied inputs are not enough
        ::
        $:  %wallet-create-fundedpsbt
            inputs=(list input)
            outputs=output
            locktime=(unit @ud)
            $=  options  %-  unit
            $:  change-address=(unit @uc)
                change-position=(unit @ud)
                change-type=(unit address-type)
                include-watching=(unit ?)
                lock-unspents=(unit ?)
                fee-rate=(unit @t)
                subtract-fee-from-outputs=(unit (list @ud))
                replaceable=(unit ?)
                conf-target=(unit @ud)
                =estimate-mode
            ==
            bip32-derivs=(unit ?)
        ==
        ::  %wallet-lock:   Removes the wallet encryption key from memory,
        ::  locking the wallet.
        ::
        [%wallet-lock ~]
        ::  %wallet-passphrase:   Stores the wallet decryption key in memory
        ::  for 'timeout' seconds.
        ::
        [%wallet-passphrase passphrase=@t timeout=@ud]
        ::  C%wallet-passphrase-changehange: s the wallet passphrase from
        ::  'oldpassphrase' to 'newpassphrase'.
        ::
        $:  %wallet-passphrase-change
            old-passphrase=(unit @t)
            new-passphrase=(unit @t)
        ==
        ::  %wallet-process-psbt: Update a PSBT with input information from
        ::  our wallet and then sign inputs
        ::
        $:  %wallet-process-psbt
            psbt=@t
            sign=(unit ?)
            =sig-hash-type
            bip32-derivs=(unit ?)
        ==
    ::  ZMQ management
    ::
        ::  %get-zmq-notifications: Returns information about the active
        ::  ZeroMQ notifications.
        ::
        [%get-zmq-notifications ~]
    ==
  ::
  +$  response
    $%
    ::  Blockchain
    ::
        ::  %getbestblockhash: Returns the hash of the best (tip) block in the longest blockchain.
        ::
        [%get-best-block-hash hex=@ux]
        ::  %getblock: If verbosity is 0, returns a string that is serialized, hex-encoded data for block 'hash'.
        :: If verbosity is 1, returns an Object with information about block <hash>.
        :: If verbosity is 2, returns an Object with information about block <hash> and information about each transaction.
        ::
        :: Result (for verbosity = 0):
        :: "data"             (string) A string that is serialized, hex-encoded data for block 'hash'.
        ::
        :: Result (for verbosity = 1):
        :: {
        ::   "hash" : "hash",     (string) the block hash (same as provided)
        ::   "confirmations" : n,   (numeric) The number of confirmations, or -1 if the block is not on the main chain
        ::   "size" : n,            (numeric) The block size
        ::   "strippedsize" : n,    (numeric) The block size excluding witness data
        ::   "weight" : n           (numeric) The block weight as defined in BIP 141
        ::   "height" : n,          (numeric) The block height or index
        ::   "version" : n,         (numeric) The block version
        ::   "versionHex" : "00000000", (string) The block version formatted in hexadecimal
        ::   "merkleroot" : "xxxx", (string) The merkle root
        ::   "tx" : [               (array of string) The transaction ids
        ::      "transactionid"     (string) The transaction id
        ::      ,...
        ::   ],
        ::   "time" : ttt,          (numeric) The block time in seconds since epoch (Jan 1 1970 GMT)
        ::   "mediantime" : ttt,    (numeric) The median block time in seconds since epoch (Jan 1 1970 GMT)
        ::   "nonce" : n,           (numeric) The nonce
        ::   "bits" : "1d00ffff", (string) The bits
        ::   "difficulty" : x.xxx,  (numeric) The difficulty
        ::   "chainwork" : "xxxx",  (string) Expected number of hashes required to produce the chain up to this block (in hex)
        ::   "nTx" : n,             (numeric) The number of transactions in the block.
        ::   "previousblockhash" : "hash",  (string) The hash of the previous block
        ::   "nextblockhash" : "hash"       (string) The hash of the next block
        :: }
        ::
        :: Result (for verbosity = 2):
        :: {
        ::   ...,                     Same output as verbosity = 1.
        ::   "tx" : [               (array of Objects) The transactions in the format of the getrawtransaction RPC. Different from verbosity = 1 "tx" result.
        ::          ,...
        ::   ],
        ::   ,...                     Same output as verbosity = 1.
        :: }
        ::
        $:  %get-block
            $?  ::  verbosity = 0
                ::
                @ux
                ::  verbosity > 0
                ::
                $:  hash=@ux
                    confirmations=@ud
                    size=@ud
                    stripped-size=@ud
                    weight=@ud
                    height=@ud
                    version=@t
                    version-hex=@ux
                    merkle-root=@ux
                    $=  tx  %-  list
                    $?  ::  verbosity = 1
                        ::
                        @ux
                        ::  verbosity = 2
                        ::
                        raw-transaction-rpc-out
                    ==
                    time=@ud
                    median-time=@ud
                    nonce=@ud
                    bits=@ux
                    difficulty=@t
                    chain-work=@ux
                    n-tx=@ud
                    previous-blockhash=@ux
                    next-blockhash=@ux
        ==  ==  ==
        ::  %getblockchaininfo: Returns an object containing various state info regarding blockchain processing.
        ::
        :: Result:
        :: {
        ::   "chain": "xxxx",              (string) current network name as defined in BIP70 (main, test, regtest)
        ::   "blocks": xxxxxx,             (numeric) the current number of blocks processed in the server
        ::   "headers": xxxxxx,            (numeric) the current number of headers we have validated
        ::   "bestblockhash": "...",       (string) the hash of the currently best block
        ::   "difficulty": xxxxxx,         (numeric) the current difficulty
        ::   "mediantime": xxxxxx,         (numeric) median time for the current best block
        ::   "verificationprogress": xxxx, (numeric) estimate of verification progress [0..1]
        ::   "initialblockdownload": xxxx, (bool) (debug information) estimate of whether this node is in Initial Block Download mode.
        ::   "chainwork": "xxxx"           (string) total amount of work in active chain, in hexadecimal
        ::   "size_on_disk": xxxxxx,       (numeric) the estimated size of the block and undo files on disk
        ::   "pruned": xx,                 (boolean) if the blocks are subject to pruning
        ::   "pruneheight": xxxxxx,        (numeric) lowest-height complete block stored (only present if pruning is enabled)
        ::   "automatic_pruning": xx,      (boolean) whether automatic pruning is enabled (only present if pruning is enabled)
        ::   "prune_target_size": xxxxxx,  (numeric) the target size used by pruning (only present if automatic pruning is enabled)
        ::   "softforks": [                (array) status of softforks in progress
        ::      {
        ::         "id": "xxxx",           (string) name of softfork
        ::         "version": xx,          (numeric) block version
        ::         "reject": {             (object) progress toward rejecting pre-softfork blocks
        ::            "status": xx,        (boolean) true if threshold reached
        ::         },
        ::      }, ...
        ::   ],
        ::   "bip9_softforks": {           (object) status of BIP9 softforks in progress
        ::      "xxxx" : {                 (string) name of the softfork
        ::         "status": "xxxx",       (string) one of "defined", "started", "locked_in", "active", "failed"
        ::         "bit": xx,              (numeric) the bit (0-28) in the block version field used to signal this softfork (only for "started" status)
        ::         "startTime": xx,        (numeric) the minimum median time past of a block at which the bit gains its meaning
        ::         "timeout": xx,          (numeric) the median time past of a block at which the deployment is considered failed if not yet locked in
        ::         "since": xx,            (numeric) height of the first block to which the status applies
        ::         "statistics": {         (object) numeric statistics about BIP9 signalling for a softfork (only for "started" status)
        ::            "period": xx,        (numeric) the length in blocks of the BIP9 signalling period
        ::            "threshold": xx,     (numeric) the number of blocks with the version bit set required to activate the feature
        ::            "elapsed": xx,       (numeric) the number of blocks elapsed since the beginning of the current period
        ::            "count": xx,         (numeric) the number of blocks with the version bit set in the current period
        ::            "possible": xx       (boolean) returns false if there are not enough blocks left in this period to pass activation threshold
        ::         }
        ::      }
        ::   }
        ::   "warnings" : "...",           (string) any network and blockchain warnings.
        :: }
        ::
        $:  %get-blockchain-info
            chain=network-name
            blocks=@ud
            headers=@ud
            best-block-hash=@ux
            difficulty=@t
            median-time=@ud
            verification-progress=@ud
            initial-block-download=?
            chain-work=@ux
            size-on-disk=@ud
            pruned=?
            pruneheight=(unit @ud)
            automatic-pruning=(unit ?)
            prune-target-size=(unit @ud)
            $=  soft-forks  %-  list
            $:  id=@t
                version=@t
                reject-status=?
            ==
            $=  bip9-softforks  %+  map
                name=@t
                $:  status=soft-fork-status
                    bit=(unit @ud)
                    start-time=?(%'-1' @ud)
                    timeout=@ud
                    since=@ud
                    $=  statistics  %-  unit
                    $:  period=@ud
                        threshold=@ud
                        elapsed=@ud
                        count=@ud
                        possible=?
                ==  ==
            warnings=(list @t)
        ==
        ::  %getblockcount: Returns the number of blocks in the longest blockchain.
        ::
        :: Result:
        :: n    (numeric) The current block count
        ::
        [%get-block-count count=@ud]
        ::  %getblockhash: Returns hash of block in best-block-chain at height provided.
        ::
        :: Result:
        :: "hash"         (string) The block hash
        ::
        [%get-block-hash hash=@ux]
        ::  %getblockheader: If verbose is false, returns a string that is serialized, hex-encoded data for blockheader 'hash'.
        :: If verbose is true, returns an Object with information about blockheader <hash>.
        ::
        :: Result (for verbose = true):
        :: {
        ::   "hash" : "hash",     (string) the block hash (same as provided)
        ::   "confirmations" : n,   (numeric) The number of confirmations, or -1 if the block is not on the main chain
        ::   "height" : n,          (numeric) The block height or index
        ::   "version" : n,         (numeric) The block version
        ::   "versionHex" : "00000000", (string) The block version formatted in hexadecimal
        ::   "merkleroot" : "xxxx", (string) The merkle root
        ::   "time" : ttt,          (numeric) The block time in seconds since epoch (Jan 1 1970 GMT)
        ::   "mediantime" : ttt,    (numeric) The median block time in seconds since epoch (Jan 1 1970 GMT)
        ::   "nonce" : n,           (numeric) The nonce
        ::   "bits" : "1d00ffff", (string) The bits
        ::   "difficulty" : x.xxx,  (numeric) The difficulty
        ::   "chainwork" : "0000...1f3"     (string) Expected number of hashes required to produce the current chain (in hex)
        ::   "nTx" : n,             (numeric) The number of transactions in the block.
        ::   "previousblockhash" : "hash",  (string) The hash of the previous block
        ::   "nextblockhash" : "hash",      (string) The hash of the next block
        :: }
        ::
        :: Result (for verbose=false):
        :: "data"             (string) A string that is serialized, hex-encoded data for block 'hash'.
        ::
        $:  %get-block-header
            $?  :: (for verbose = false)
                ::
                @ux
                ::  (for verbose = true)
                ::
                $:  hash=@ux
                    confirmations=@ud
                    weight=@ud
                    version=@t
                    version-hex=@ux
                    merkle-root=@ux
                    time=@ud
                    median-time=@ud
                    nonce=@ud
                    bits=@ux
                    difficulty=@t
                    chain-work=@ux
                    n-tx=@ud
                    previous-blockhash=@ux
                    next-blockhash=@ux
        ==  ==  ==
        ::  %getblockstats: Compute per block statistics for a given window. All amounts are in satoshis.
        :: It won't work for some heights with pruning.
        :: It won't work without -txindex for utxo_size_inc, *fee or *feerate stats.
        ::
        :: Result:
        :: {                           (json object)
        ::   "avgfee": xxxxx,          (numeric) Average fee in the block
        ::   "avgfeerate": xxxxx,      (numeric) Average feerate (in satoshis per virtual byte)
        ::   "avgtxsize": xxxxx,       (numeric) Average transaction size
        ::   "blockhash": xxxxx,       (string) The block hash (to check for potential reorgs)
        ::   "feerate_percentiles": [  (array of numeric) Feerates at the 10th, 25th, 50th, 75th, and 90th percentile weight unit (in satoshis per virtual byte)
        ::       "10th_percentile_feerate",      (numeric) The 10th percentile feerate
        ::       "25th_percentile_feerate",      (numeric) The 25th percentile feerate
        ::       "50th_percentile_feerate",      (numeric) The 50th percentile feerate
        ::       "75th_percentile_feerate",      (numeric) The 75th percentile feerate
        ::       "90th_percentile_feerate",      (numeric) The 90th percentile feerate
        ::   ],
        ::   "height": xxxxx,          (numeric) The height of the block
        ::   "ins": xxxxx,             (numeric) The number of inputs (excluding coinbase)
        ::   "maxfee": xxxxx,          (numeric) Maximum fee in the block
        ::   "maxfeerate": xxxxx,      (numeric) Maximum feerate (in satoshis per virtual byte)
        ::   "maxtxsize": xxxxx,       (numeric) Maximum transaction size
        ::   "medianfee": xxxxx,       (numeric) Truncated median fee in the block
        ::   "mediantime": xxxxx,      (numeric) The block median time past
        ::   "mediantxsize": xxxxx,    (numeric) Truncated median transaction size
        ::   "minfee": xxxxx,          (numeric) Minimum fee in the block
        ::   "minfeerate": xxxxx,      (numeric) Minimum feerate (in satoshis per virtual byte)
        ::   "mintxsize": xxxxx,       (numeric) Minimum transaction size
        ::   "outs": xxxxx,            (numeric) The number of outputs
        ::   "subsidy": xxxxx,         (numeric) The block subsidy
        ::   "swtotal_size": xxxxx,    (numeric) Total size of all segwit transactions
        ::   "swtotal_weight": xxxxx,  (numeric) Total weight of all segwit transactions divided by segwit scale factor (4)
        ::   "swtxs": xxxxx,           (numeric) The number of segwit transactions
        ::   "time": xxxxx,            (numeric) The block time
        ::   "total_out": xxxxx,       (numeric) Total amount in all outputs (excluding coinbase and thus reward [ie subsidy + totalfee])
        ::   "total_size": xxxxx,      (numeric) Total size of all non-coinbase transactions
        ::   "total_weight": xxxxx,    (numeric) Total weight of all non-coinbase transactions divided by segwit scale factor (4)
        ::   "totalfee": xxxxx,        (numeric) The fee total
        ::   "txs": xxxxx,             (numeric) The number of transactions (excluding coinbase)
        ::   "utxo_increase": xxxxx,   (numeric) The increase/decrease in the number of unspent outputs
        ::   "utxo_size_inc": xxxxx,   (numeric) The increase/decrease in size for the utxo index (not discounting op_return and similar)
        :: }
        ::
        $:  %get-block-stats
            avg-fee=@t
            avg-feerate=@ud
            avg-tx-size=@ud
            block-hash=@ux
            fee-rate-percentiles=[p-1=@t p-2=@t p-3=@t p-4=@t p-5=@t]
            height=@ud
            ins=@ud
            max-fee=@t
            max-fee-rate=@t
            max-tx-size=@ud
            median-fee=@t
            median-time=@ud
            median-tx-size=@ud
            min-fee=@t
            min-fee-rate=@t
            min-tx-size=@ud
            outs=@ud
            subsidy=@t
            swtotal-size=@ud
            swtotal-weight=@ud
            swtxs=@ud
            time=@ud
            total-out=@t
            total-size=@ud
            total-weight=@t
            total-fee=@t
            txs=@ud
            utxo-increase=@ud
            utxo-size-inc=@ud
        ==
        ::  %getchaintips: Return information about all known tips in the block tree, including the main chain as well as orphaned branches.
        ::
        :: Result:
        :: [
        ::   {
        ::     "height": xxxx,         (numeric) height of the chain tip
        ::     "hash": "xxxx",         (string) block hash of the tip
        ::     "branchlen": 0          (numeric) zero for main chain
        ::     "status": "active"      (string) "active" for the main chain
        ::   },
        ::   {
        ::     "height": xxxx,
        ::     "hash": "xxxx",
        ::     "branchlen": 1          (numeric) length of branch connecting the tip to the main chain
        ::     "status": "xxxx"        (string) status of the chain (active, valid-fork, valid-headers, headers-only, invalid)
        ::   }
        :: ]
        :: Possible values for status:
        :: 1.  "invalid"               This branch contains at least one invalid block
        :: 2.  "headers-only"          Not all blocks for this branch are available, but the headers are valid
        :: 3.  "valid-headers"         All blocks are available for this branch, but they were never fully validated
        :: 4.  "valid-fork"            This branch is not part of the active chain, but is fully validated
        :: 5.  "active"                This is the tip of the active main chain, which is certainly valid
        ::
        $:  %get-chain-tips  %-  list
            $:  height=@ud
                hash=@ux
                branch-len=@ud
                status=chain-status
        ==  ==
        ::  %getchaintxstats: Compute statistics about the total number and rate of transactions in the chain.
        ::
        :: Result:
        :: {
        ::   "time": xxxxx,                         (numeric) The timestamp for the final block in the window in UNIX format.
        ::   "txcount": xxxxx,                      (numeric) The total number of transactions in the chain up to that point.
        ::   "window_final_block_hash": "...",      (string) The hash of the final block in the window.
        ::   "window_block_count": xxxxx,           (numeric) Size of the window in number of blocks.
        ::   "window_tx_count": xxxxx,              (numeric) The number of transactions in the window. Only returned if "window_block_count" is > 0.
        ::   "window_interval": xxxxx,              (numeric) The elapsed time in the window in seconds. Only returned if "window_block_count" is > 0.
        ::   "txrate": x.xx,                        (numeric) The average rate of transactions per second in the window. Only returned if "window_interval" is > 0.
        :: }
        ::
        $:  %get-chain-tx-stats
            time=@ud
            tx-count=@ud
            window-final-block-hash=@ux
            window-block-count=@ud
            window-tx-count=(unit @ud)
            window-interval=(unit @ud)
            tx-rate=(unit @ud)
        ==
        ::  %getdifficulty: Returns the proof-of-work difficulty as a multiple of the minimum difficulty.
        ::
        :: Result:
        :: n.nnn       (numeric) the proof-of-work difficulty as a multiple of the minimum difficulty.
        ::
        [%get-difficulty n=@t]
        ::  %getmempoolancestor: If txid is in the mempool, returns all in-mempool ancestors.
        ::
        :: Result (for verbose = false):
        :: [                       (json array of strings)
        ::   "transactionid"           (string) The transaction id of an in-mempool ancestor transaction
        ::   ,...
        :: ]
        ::
        :: Result (for verbose = true):
        :: {                           (json object)
        ::   "transactionid" : {       (json object)
        ::     "size" : n,             (numeric) virtual transaction size as defined in BIP 141. This is different from actual serialized size for witness transactions as witness data is discounted.
        ::     "fee" : n,              (numeric) transaction fee in BTC (DEPRECATED)
        ::     "modifiedfee" : n,      (numeric) transaction fee with fee deltas used for mining priority (DEPRECATED)
        ::     "time" : n,             (numeric) local time transaction entered pool in seconds since 1 Jan 1970 GMT
        ::     "height" : n,           (numeric) block height when transaction entered pool
        ::     "descendantcount" : n,  (numeric) number of in-mempool descendant transactions (including this one)
        ::     "descendantsize" : n,   (numeric) virtual transaction size of in-mempool descendants (including this one)
        ::     "descendantfees" : n,   (numeric) modified fees (see above) of in-mempool descendants (including this one) (DEPRECATED)
        ::     "ancestorcount" : n,    (numeric) number of in-mempool ancestor transactions (including this one)
        ::     "ancestorsize" : n,     (numeric) virtual transaction size of in-mempool ancestors (including this one)
        ::     "ancestorfees" : n,     (numeric) modified fees (see above) of in-mempool ancestors (including this one) (DEPRECATED)
        ::     "wtxid" : hash,         (string) hash of serialized transaction, including witness data
        ::     "fees" : {
        ::         "base" : n,         (numeric) transaction fee in BTC
        ::         "modified" : n,     (numeric) transaction fee with fee deltas used for mining priority in BTC
        ::         "ancestor" : n,     (numeric) modified fees (see above) of in-mempool ancestors (including this one) in BTC
        ::         "descendant" : n,   (numeric) modified fees (see above) of in-mempool descendants (including this one) in BTC
        ::     }
        ::     "depends" : [           (array) unconfirmed transactions used as inputs for this transaction
        ::         "transactionid",    (string) parent transaction id
        ::        ... ]
        ::     "spentby" : [           (array) unconfirmed transactions spending outputs from this transaction
        ::         "transactionid",    (string) child transaction id
        ::        ... ]
        ::     "bip125-replaceable" : true|false,  (boolean) Whether this transaction could be replaced due to BIP125 (replace-by-fee)
        ::   }, ...
        :: }
        ::
        [%get-mempool-ancestors mem-pool-response]
        ::  %getmempooldescendants: If txid is in the mempool, returns all in-mempool descendants.
        ::
        :: Result (for verbose = false):
        :: [                       (json array of strings)
        ::   "transactionid"           (string) The transaction id of an in-mempool descendant transaction
        ::   ,...
        :: ]
        ::
        :: Result (for verbose = true):
        :: {                           (json object)
        ::   "transactionid" : {       (json object)
        ::     "size" : n,             (numeric) virtual transaction size as defined in BIP 141. This is different from actual serialized size for witness transactions as witness data is discounted.
        ::     "fee" : n,              (numeric) transaction fee in BTC (DEPRECATED)
        ::     "modifiedfee" : n,      (numeric) transaction fee with fee deltas used for mining priority (DEPRECATED)
        ::     "time" : n,             (numeric) local time transaction entered pool in seconds since 1 Jan 1970 GMT
        ::     "height" : n,           (numeric) block height when transaction entered pool
        ::     "descendantcount" : n,  (numeric) number of in-mempool descendant transactions (including this one)
        ::     "descendantsize" : n,   (numeric) virtual transaction size of in-mempool descendants (including this one)
        ::     "descendantfees" : n,   (numeric) modified fees (see above) of in-mempool descendants (including this one) (DEPRECATED)
        ::     "ancestorcount" : n,    (numeric) number of in-mempool ancestor transactions (including this one)
        ::     "ancestorsize" : n,     (numeric) virtual transaction size of in-mempool ancestors (including this one)
        ::     "ancestorfees" : n,     (numeric) modified fees (see above) of in-mempool ancestors (including this one) (DEPRECATED)
        ::     "wtxid" : hash,         (string) hash of serialized transaction, including witness data
        ::     "fees" : {
        ::         "base" : n,         (numeric) transaction fee in BTC
        ::         "modified" : n,     (numeric) transaction fee with fee deltas used for mining priority in BTC
        ::         "ancestor" : n,     (numeric) modified fees (see above) of in-mempool ancestors (including this one) in BTC
        ::         "descendant" : n,   (numeric) modified fees (see above) of in-mempool descendants (including this one) in BTC
        ::     }
        ::     "depends" : [           (array) unconfirmed transactions used as inputs for this transaction
        ::         "transactionid",    (string) parent transaction id
        ::        ... ]
        ::     "spentby" : [           (array) unconfirmed transactions spending outputs from this transaction
        ::         "transactionid",    (string) child transaction id
        ::        ... ]
        ::     "bip125-replaceable" : true|false,  (boolean) Whether this transaction could be replaced due to BIP125 (replace-by-fee)
        ::   }, ...
        :: }
        ::
        [%get-mempool-descendants mem-pool-response]
        ::  %getmempoolentry: Returns mempool data for given transaction
        ::
        :: Result:
        :: {                           (json object)
        ::     "size" : n,             (numeric) virtual transaction size as defined in BIP 141. This is different from actual serialized size for witness transactions as witness data is discounted.
        ::     "fee" : n,              (numeric) transaction fee in BTC (DEPRECATED)
        ::     "modifiedfee" : n,      (numeric) transaction fee with fee deltas used for mining priority (DEPRECATED)
        ::     "time" : n,             (numeric) local time transaction entered pool in seconds since 1 Jan 1970 GMT
        ::     "height" : n,           (numeric) block height when transaction entered pool
        ::     "descendantcount" : n,  (numeric) number of in-mempool descendant transactions (including this one)
        ::     "descendantsize" : n,   (numeric) virtual transaction size of in-mempool descendants (including this one)
        ::     "descendantfees" : n,   (numeric) modified fees (see above) of in-mempool descendants (including this one) (DEPRECATED)
        ::     "ancestorcount" : n,    (numeric) number of in-mempool ancestor transactions (including this one)
        ::     "ancestorsize" : n,     (numeric) virtual transaction size of in-mempool ancestors (including this one)
        ::     "ancestorfees" : n,     (numeric) modified fees (see above) of in-mempool ancestors (including this one) (DEPRECATED)
        ::     "wtxid" : hash,         (string) hash of serialized transaction, including witness data
        ::     "fees" : {
        ::         "base" : n,         (numeric) transaction fee in BTC
        ::         "modified" : n,     (numeric) transaction fee with fee deltas used for mining priority in BTC
        ::         "ancestor" : n,     (numeric) modified fees (see above) of in-mempool ancestors (including this one) in BTC
        ::         "descendant" : n,   (numeric) modified fees (see above) of in-mempool descendants (including this one) in BTC
        ::     }
        ::     "depends" : [           (array) unconfirmed transactions used as inputs for this transaction
        ::         "transactionid",    (string) parent transaction id
        ::        ... ]
        ::     "spentby" : [           (array) unconfirmed transactions spending outputs from this transaction
        ::         "transactionid",    (string) child transaction id
        ::        ... ]
        ::     "bip125-replaceable" : true|false,  (boolean) Whether this transaction could be replaced due to BIP125 (replace-by-fee)
        :: }
        ::
        [%get-mempool-entry mem-pool]
        ::  %getmempoolinfo: Returns details on the active state of the TX memory pool.
        ::
        :: Result:
        :: {
        ::   "size": xxxxx,               (numeric) Current tx count
        ::   "bytes": xxxxx,              (numeric) Sum of all virtual transaction sizes as defined in BIP 141. Differs from actual serialized size because witness data is discounted
        ::   "usage": xxxxx,              (numeric) Total memory usage for the mempool
        ::   "maxmempool": xxxxx,         (numeric) Maximum memory usage for the mempool
        ::   "mempoolminfee": xxxxx       (numeric) Minimum fee rate in BTC/kB for tx to be accepted. Is the maximum of minrelaytxfee and minimum mempool fee
        ::   "minrelaytxfee": xxxxx       (numeric) Current minimum relay fee for transactions
        :: }
        ::
        $:  %get-mempool-info
            size=@ud
            bytes=@ud
            usage=@ud
            max-mem-pool=@ud
            mem-pool-min-fee=@t
            min-relay-tx-fee=@t
        ==
        ::  %getrawmempool: Returns all transaction ids in memory pool as a json array of string transaction ids.
        ::
        :: Hint: use getmempoolentry to fetch a specific transaction from the mempool.
        ::
        :: Result (for verbose = false):
        :: [                     (json array of string)
        ::   "transactionid"     (string) The transaction id
        ::   ,...
        :: ]
        ::
        :: Result: (for verbose = true):
        :: {                           (json object)
        ::   "transactionid" : {       (json object)
        ::     "size" : n,             (numeric) virtual transaction size as defined in BIP 141. This is different from actual serialized size for witness transactions as witness data is discounted.
        ::     "fee" : n,              (numeric) transaction fee in BTC (DEPRECATED)
        ::     "modifiedfee" : n,      (numeric) transaction fee with fee deltas used for mining priority (DEPRECATED)
        ::     "time" : n,             (numeric) local time transaction entered pool in seconds since 1 Jan 1970 GMT
        ::     "height" : n,           (numeric) block height when transaction entered pool
        ::     "descendantcount" : n,  (numeric) number of in-mempool descendant transactions (including this one)
        ::     "descendantsize" : n,   (numeric) virtual transaction size of in-mempool descendants (including this one)
        ::     "descendantfees" : n,   (numeric) modified fees (see above) of in-mempool descendants (including this one) (DEPRECATED)
        ::     "ancestorcount" : n,    (numeric) number of in-mempool ancestor transactions (including this one)
        ::     "ancestorsize" : n,     (numeric) virtual transaction size of in-mempool ancestors (including this one)
        ::     "ancestorfees" : n,     (numeric) modified fees (see above) of in-mempool ancestors (including this one) (DEPRECATED)
        ::     "wtxid" : hash,         (string) hash of serialized transaction, including witness data
        ::     "fees" : {
        ::         "base" : n,         (numeric) transaction fee in BTC
        ::         "modified" : n,     (numeric) transaction fee with fee deltas used for mining priority in BTC
        ::         "ancestor" : n,     (numeric) modified fees (see above) of in-mempool ancestors (including this one) in BTC
        ::         "descendant" : n,   (numeric) modified fees (see above) of in-mempool descendants (including this one) in BTC
        ::     }
        ::     "depends" : [           (array) unconfirmed transactions used as inputs for this transaction
        ::         "transactionid",    (string) parent transaction id
        ::        ... ]
        ::     "spentby" : [           (array) unconfirmed transactions spending outputs from this transaction
        ::         "transactionid",    (string) child transaction id
        ::        ... ]
        ::     "bip125-replaceable" : true|false,  (boolean) Whether this transaction could be replaced due to BIP125 (replace-by-fee)
        ::   }, ...
        :: }
        ::
        [%get-raw-mempool mem-pool-response]
        ::  %gettxout: Returns details about an unspent transaction output.
        ::
        :: Result:
        :: {
        ::   "bestblock":  "hash",    (string) The hash of the block at the tip of the chain
        ::   "confirmations" : n,       (numeric) The number of confirmations
        ::   "value" : x.xxx,           (numeric) The transaction value in BTC
        ::   "scriptPubKey" : {         (json object)
        ::      "asm" : "code",       (string)
        ::      "hex" : "hex",        (string)
        ::      "reqSigs" : n,          (numeric) Number of required signatures
        ::      "type" : "pubkeyhash", (string) The type, eg pubkeyhash
        ::      "addresses" : [          (array of string) array of bitcoin addresses
        ::         "address"     (string) bitcoin address
        ::         ,...
        ::      ]
        ::   },
        ::   "coinbase" : true|false   (boolean) Coinbase or not
        :: }
        ::
        :: $:  %get-tx-out
        ::     bestblock=@ux
        ::     confirmations=@ud
        ::     value=@t
        ::     coinbase=?
        ::     $=  script-pubkey
        ::     $:  asm=@t
        ::         hex=@ux
        ::         req-sigs=@ud
        ::         type=@t
        ::         addresses=(list address)
        ::     ==
        ::     coinbase=?
        :: ==
        ::  %gettxoutproof: Returns a hex-encoded proof that "txid" was included in a block.
        ::
        :: NOTE: By default this function only works sometimes. This is when there is an
        :: unspent output in the utxo for this transaction. To make it always work,
        :: you need to maintain a transaction index, using the -txindex command line option or
        :: specify the block in which the transaction is included manually (by blockhash).
        ::
        :: Result:
        :: "data"           (string) A string that is a serialized, hex-encoded data for the proof.
        ::
        [%get-tx-out-proof data=@ux]
        ::  %gettxoutsetinfo: Returns statistics about the unspent transaction output set.
        :: Note this call may take some time.
        ::
        :: Result:
        :: {
        ::   "height":n,     (numeric) The current block height (index)
        ::   "bestblock": "hex",   (string) The hash of the block at the tip of the chain
        ::   "transactions": n,      (numeric) The number of transactions with unspent outputs
        ::   "txouts": n,            (numeric) The number of unspent transaction outputs
        ::   "bogosize": n,          (numeric) A meaningless metric for UTXO set size
        ::   "hash_serialized_2": "hash", (string) The serialized hash
        ::   "disk_size": n,         (numeric) The estimated size of the chainstate on disk
        ::   "total_amount": x.xxx          (numeric) The total amount
        :: }
        ::
        $:  %get-tx-outset-info
            height=@ud
            best-block=@ux
            transactions=@ud
            tx-outs=@ud
            bogo-size=@ud
            hash-serialized-2=@ux
            disk-size=@ud
            total-amount=@t
        ==
        ::  %preciousblock: Treats a block as if it were received before others with the same work.
        ::
        :: A later preciousblock call can override the effect of an earlier one.
        ::
        :: The effects of preciousblock are not retained across restarts.
        ::
        [%precious-block ~]
        ::  %pruneblockchain:
        ::
        :: Result:
        :: n    (numeric) Height of the last block pruned.
        ::
        [%prune-blockchain height=@ud]
        ::  %savemempool: Dumps the mempool to disk. It will fail until the previous dump is fully loaded.
        ::
        [%save-mempool ~]
        ::  %scantxoutset: EXPERIMENTAL warning: this call may be removed or changed in future releases.
        ::
        :: Scans the unspent transaction output set for entries that match certain output descriptors.
        :: Examples of output descriptors are:
        ::     addr(<address>)                      Outputs whose scriptPubKey corresponds to the specified address (does not include P2PK)
        ::     raw(<hex script>)                    Outputs whose scriptPubKey equals the specified hex scripts
        ::     combo(<pubkey>)                      P2PK, P2PKH, P2WPKH, and P2SH-P2WPKH outputs for the given pubkey
        ::     pkh(<pubkey>)                        P2PKH outputs for the given pubkey
        ::     sh(multi(<n>,<pubkey>,<pubkey>,...)) P2SH-multisig outputs for the given threshold and pubkeys
        ::
        :: In the above, <pubkey> either refers to a fixed public key in hexadecimal notation, or to an xpub/xprv optionally followed by one
        :: or more path elements separated by "/", and optionally ending in "/*" (unhardened), or "/*'" or "/*h" (hardened) to specify all
        :: unhardened or hardened child keys.
        :: In the latter case, a range needs to be specified by below if different from 1000.
        :: For more information on output descriptors, see the documentation in the doc/descriptors.md file.
        ::
        :: Result:
        :: {
        ::   "unspents": [
        ::     {
        ::     "txid" : "transactionid",     (string) The transaction id
        ::     "vout": n,                    (numeric) the vout value
        ::     "scriptPubKey" : "script",    (string) the script key
        ::     "desc" : "descriptor",        (string) A specialized descriptor for the matched scriptPubKey
        ::     "amount" : x.xxx,             (numeric) The total amount in BTC of the unspent output
        ::     "height" : n,                 (numeric) Height of the unspent transaction output
        ::    }
        ::    ,...],
        ::  "total_amount" : x.xxx,          (numeric) The total amount of all found unspent outputs in BTC
        :: ]
        ::
        $:  %scan-tx-outset
            $=  unspents  %-  list
            $:  txid=@ux
                vout=@ud
                script-pubkey=@ux
                desc=@t
                amount=@t
                height=@ud
            ==
            total-amount=@t
        ==
        ::  %verifychain: Verifies blockchain database.
        ::
        :: Result:
        :: true|false       (boolean) Verified or not
        ::
        [%verify-chain ?]
        ::  %verifytxoutproof: Verifies that a proof points to a transaction in a block, returning the transaction it commits to
        :: and throwing an RPC error if the block is not in our best chain
        ::
        :: Result:
        :: ["txid"]      (array, strings) The txid(s) which the proof commits to, or empty array if the proof can not be validated.
        ::
        [%verify-tx-out-proof (list @ux)]
    ::  Control
        [%help ~]
    ::  Generating
    ::
        [%generate blocks=(list blockhash)]
    ::  Raw Transactions
    ::
        ::  %analyzepsbt: Analyzes and provides information about the current status of a PSBT and its inputs
        ::
        :: Result:
        :: {
        ::   "inputs" : [                      (array of json objects)
        ::     {
        ::       "has_utxo" : true|false     (boolean) Whether a UTXO is provided
        ::       "is_final" : true|false     (boolean) Whether the input is finalized
        ::       "missing" : {               (json object, optional) Things that are missing that are required to complete this input
        ::         "pubkeys" : [             (array, optional)
        ::           "keyid"                 (string) Public key ID, hash160 of the public key, of a public key whose BIP 32 derivation path is missing
        ::         ]
        ::         "signatures" : [          (array, optional)
        ::           "keyid"                 (string) Public key ID, hash160 of the public key, of a public key whose signature is missing
        ::         ]
        ::         "redeemscript" : "hash"   (string, optional) Hash160 of the redeemScript that is missing
        ::         "witnessscript" : "hash"  (string, optional) SHA256 of the witnessScript that is missing
        ::       }
        ::       "next" : "role"             (string, optional) Role of the next person that this input needs to go to
        ::     }
        ::     ,...
        ::   ]
        ::   "estimated_vsize" : vsize       (numeric, optional) Estimated vsize of the final signed transaction
        ::   "estimated_feerate" : feerate   (numeric, optional) Estimated feerate of the final signed transaction in BTC/kB. Shown only if all UTXO slots in the PSBT have been filled.
        ::   "fee" : fee                     (numeric, optional) The transaction fee paid. Shown only if all UTXO slots in the PSBT have been filled.
        ::   "next" : "role"                 (string) Role of the next person that this psbt needs to go to
        :: }
        ::
        $:  %analyze-psbt
            $=  inputs  %-  list
            $:  has-utxo=?
                is-final=?
                $=  missing  %-  unit  %-  list
                $:  pubkeys=(unit (list @ux))
                    signatures=(unit (list @ux))
                    redeem-script=(unit @ux)
                    witness-script=(unit @ux)
                ==
                next=(unit @t)
            ==
            estimated-vsize=(unit @t)
            estimated-feerate=(unit @t)
            fee=(unit @t)
            next=@t
        ==
        ::  %combinepsbt: Combine multiple partially signed Bitcoin transactions into one transaction.
        :: Implements the Combiner role.
        ::
        :: Result:
        ::   "psbt"          (string) The base64-encoded partially signed transaction
        ::
        [%combine-psbt psbt=@t]
        ::  %combinerawtransaction:Combine multiple partially signed transactions into one transaction.
        :: The combined transaction may be another partially signed transaction or a
        :: fully signed transaction.
        ::
        :: Result:
        :: "hex"            (string) The hex-encoded raw transaction with signature(s)
        ::
        [%combine-raw-transaction hex=@ux]
        ::  %converttopsbt: Converts a network serialized transaction to a PSBT. This should be used only with createrawtransaction and fundrawtransaction
        :: createpsbt and walletcreatefundedpsbt should be used for new applications.
        ::
        :: Result:
        ::   "psbt"        (string)  The resulting raw transaction (base64-encoded string)
        ::
        [%convert-to-psbt psbt=@t]
        ::  %createpsbt: Creates a transaction in the Partially Signed Transaction format.
        :: Implements the Creator role.
        ::
        :: Result:
        ::   "psbt"        (string)  The resulting raw transaction (base64-encoded string)
        ::
        [%create-psbt psbt=@t]
        ::  %createrawtransaction: Create a transaction spending the given inputs and creating new outputs.
        :: Outputs can be addresses or data.
        :: Returns hex-encoded raw transaction.
        :: Note that the transaction's inputs are not signed, and
        :: it is not stored in the wallet or transmitted to the network.
        ::
        :: Result:
        :: "transaction"              (string) hex string of the transaction
        ::
        [%create-raw-transaction transaction=@ux]
        ::  %decodepsbt: Return a JSON object representing the serialized, base64-encoded partially signed Bitcoin transaction.
        ::
        :: Result:
        :: {
        ::   "tx" : {                   (json object) The decoded network-serialized unsigned transaction.
        ::     ...                                      The layout is the same as the output of decoderawtransaction.
        ::   },
        ::   "unknown" : {                (json object) The unknown global fields
        ::     "key" : "value"            (key-value pair) An unknown key-value pair
        ::      ...
        ::   },
        ::   "inputs" : [                 (array of json objects)
        ::     {
        ::       "non_witness_utxo" : {   (json object, optional) Decoded network transaction for non-witness UTXOs
        ::         ...
        ::       },
        ::       "witness_utxo" : {            (json object, optional) Transaction output for witness UTXOs
        ::         "amount" : x.xxx,           (numeric) The value in BTC
        ::         "scriptPubKey" : {          (json object)
        ::           "asm" : "asm",            (string) The asm
        ::           "hex" : "hex",            (string) The hex
        ::           "type" : "pubkeyhash",    (string) The type, eg 'pubkeyhash'
        ::           "address" : "address"     (string) Bitcoin address if there is one
        ::         }
        ::       },
        ::       "partial_signatures" : {             (json object, optional)
        ::         "pubkey" : "signature",           (string) The public key and signature that corresponds to it.
        ::         ,...
        ::       }
        ::       "sighash" : "type",                  (string, optional) The sighash type to be used
        ::       "redeem_script" : {       (json object, optional)
        ::           "asm" : "asm",            (string) The asm
        ::           "hex" : "hex",            (string) The hex
        ::           "type" : "pubkeyhash",    (string) The type, eg 'pubkeyhash'
        ::         }
        ::       "witness_script" : {       (json object, optional)
        ::           "asm" : "asm",            (string) The asm
        ::           "hex" : "hex",            (string) The hex
        ::           "type" : "pubkeyhash",    (string) The type, eg 'pubkeyhash'
        ::         }
        ::       "bip32_derivs" : {          (json object, optional)
        ::         "pubkey" : {                     (json object, optional) The public key with the derivation path as the value.
        ::           "master_fingerprint" : "fingerprint"     (string) The fingerprint of the master key
        ::           "path" : "path",                         (string) The path
        ::         }
        ::         ,...
        ::       }
        ::       "final_scriptsig" : {       (json object, optional)
        ::           "asm" : "asm",            (string) The asm
        ::           "hex" : "hex",            (string) The hex
        ::         }
        ::        "final_scriptwitness": ["hex", ...] (array of string) hex-encoded witness data (if any)
        ::       "unknown" : {                (json object) The unknown global fields
        ::         "key" : "value"            (key-value pair) An unknown key-value pair
        ::          ...
        ::       },
        ::     }
        ::     ,...
        ::   ]
        ::   "outputs" : [                 (array of json objects)
        ::     {
        ::       "redeem_script" : {       (json object, optional)
        ::           "asm" : "asm",            (string) The asm
        ::           "hex" : "hex",            (string) The hex
        ::           "type" : "pubkeyhash",    (string) The type, eg 'pubkeyhash'
        ::         }
        ::       "witness_script" : {       (json object, optional)
        ::           "asm" : "asm",            (string) The asm
        ::           "hex" : "hex",            (string) The hex
        ::           "type" : "pubkeyhash",    (string) The type, eg 'pubkeyhash'
        ::       }
        ::       "bip32_derivs" : [          (array of json objects, optional)
        ::         {
        ::           "pubkey" : "pubkey",                     (string) The public key this path corresponds to
        ::           "master_fingerprint" : "fingerprint"     (string) The fingerprint of the master key
        ::           "path" : "path",                         (string) The path
        ::           }
        ::         }
        ::         ,...
        ::       ],
        ::       "unknown" : {                (json object) The unknown global fields
        ::         "key" : "value"            (key-value pair) An unknown key-value pair
        ::          ...
        ::       },
        ::     }
        ::     ,...
        ::   ]
        ::   "fee" : fee                      (numeric, optional) The transaction fee paid if all UTXOs slots in the PSBT have been filled.
        :: }
        ::
        $:  %decode-psbt
            tx=serialized-tx
            unknown=(map @t @t)
            $=  inputs  %-  list
            $:  non-witness-utxo=utxo
                witness-utxo=utxo
                partial-signatures=(unit (map pubkey=@ux signature=@ux))
                =sig-hash-type
                redeem-script=(unit script)
                witness-script=(unit script)
                $=  bip32-derivs  %-  unit  %+  map
                pubkey=@ux
                $:  master-fingerprint=@t
                    path=@t
                ==
                final-script-sig=(unit [asm=@t hex=@ux])
                final-script-witness=(unit (list @ux))
                unknown=(map @t @t)
            ==
            $=  outputs  %-  list
            $:  redeem-script=(unit script)
                witness-script=(unit script)
                $=  bip32-derivs  %-  unit  %+  map
                pubkey=@ux
                $:  master-fingerprint=@t
                    path=@t
                ==
                unknown=(map @t @t)
            ==
            fee=(unit @t)
        ==
        ::  %decoderawtransaction: Return a JSON object representing the serialized, hex-encoded transaction.
        ::
        :: Result:
        :: {
        ::   "txid" : "id",        (string) The transaction id
        ::   "hash" : "id",        (string) The transaction hash (differs from txid for witness transactions)
        ::   "size" : n,             (numeric) The transaction size
        ::   "vsize" : n,            (numeric) The virtual transaction size (differs from size for witness transactions)
        ::   "weight" : n,           (numeric) The transaction's weight (between vsize*4 - 3 and vsize*4)
        ::   "version" : n,          (numeric) The version
        ::   "locktime" : ttt,       (numeric) The lock time
        ::   "vin" : [               (array of json objects)
        ::      {
        ::        "txid": "id",    (string) The transaction id
        ::        "vout": n,         (numeric) The output number
        ::        "scriptSig": {     (json object) The script
        ::          "asm": "asm",  (string) asm
        ::          "hex": "hex"   (string) hex
        ::        },
        ::        "txinwitness": ["hex", ...] (array of string) hex-encoded witness data (if any)
        ::        "sequence": n     (numeric) The script sequence number
        ::      }
        ::      ,...
        ::   ],
        ::   "vout" : [             (array of json objects)
        ::      {
        ::        "value" : x.xxx,            (numeric) The value in BTC
        ::        "n" : n,                    (numeric) index
        ::        "scriptPubKey" : {          (json object)
        ::          "asm" : "asm",          (string) the asm
        ::          "hex" : "hex",          (string) the hex
        ::          "reqSigs" : n,            (numeric) The required sigs
        ::          "type" : "pubkeyhash",  (string) The type, eg 'pubkeyhash'
        ::          "addresses" : [           (json array of string)
        ::            "12tvKAXCxZjSmdNbao16dKXC8tRWfcF5oc"   (string) bitcoin address
        ::            ,...
        ::          ]
        ::        }
        ::      }
        ::      ,...
        ::   ],
        :: }
        ::
        [%decode-raw-transaction =serialized-tx]
        ::  %decodescript: Decode a hex-encoded script.
        ::
        :: Result:
        :: {
        ::   "asm":"asm",   (string) Script public key
        ::   "hex":"hex",   (string) hex-encoded public key
        ::   "type":"type", (string) The output type
        ::   "reqSigs": n,    (numeric) The required signatures
        ::   "addresses": [   (json array of string)
        ::      "address"     (string) bitcoin address
        ::      ,...
        ::   ],
        ::   "p2sh","address" (string) address of P2SH script wrapping this redeem script (not returned if the script is already a P2SH).
        :: }
        ::
        $:  %decode-script
            asm=@t
            hex=@ux
            type=@t
            req-sigs=@ud
            addresses=(list address)
            p2sh=address
        ==
        ::  %finalizepsbt: Finalize the inputs of a PSBT. If the transaction is fully signed, it will produce a
        :: network serialized transaction which can be broadcast with sendrawtransaction. Otherwise a PSBT will be
        :: created which has the final_scriptSig and final_scriptWitness fields filled for inputs that are complete.
        :: Implements the Finalizer and Extractor roles.
        ::
        :: Result:
        :: {
        ::   "psbt" : "value",          (string) The base64-encoded partially signed transaction if not extracted
        ::   "hex" : "value",           (string) The hex-encoded network transaction if extracted
        ::   "complete" : true|false,   (boolean) If the transaction has a complete set of signatures
        ::   ]
        :: }
        ::
        [%finalize-psbt psbt=@t hex=@ux complete=?]
        ::  %fundrawtransaction: Add inputs to a transaction until it has enough in value to meet its out value.
        :: This will not modify existing inputs, and will add at most one change output to the outputs.
        :: No existing outputs will be modified unless "subtractFeeFromOutputs" is specified.
        :: Note that inputs which were signed may need to be resigned after completion since in/outputs have been added.
        :: The inputs added will not be signed, use signrawtransactionwithkey
        ::  or signrawtransactionwithwallet for that.
        :: Note that all existing inputs must have their previous output transaction be in the wallet.
        :: Note that all inputs selected must be of standard form and P2SH scripts must be
        :: in the wallet using importaddress or addmultisigaddress (to calculate fees).
        :: You can see whether this is the case by checking the "solvable" field in the listunspent output.
        :: Only pay-to-pubkey, multisig, and P2SH versions thereof are currently supported for watch-only
        ::
        :: Result:
        :: {
        ::   "hex":       "value", (string)  The resulting raw transaction (hex-encoded string)
        ::   "fee":       n,         (numeric) Fee in BTC the resulting transaction pays
        ::   "changepos": n          (numeric) The position of the added change output, or -1
        :: }
        ::
        [%fund-raw-transaction hex=@ux fee=@t change-pos=?(@ud %'-1')]
        ::  %getrawtransaction: Return the raw transaction data.
        ::
        :: By default this function only works for mempool transactions. When called with a blockhash
        :: argument, getrawtransaction will return the transaction if the specified block is available and
        :: the transaction is found in that block. When called without a blockhash argument, getrawtransaction
        :: will return the transaction if it is in the mempool, or if -txindex is enabled and the transaction
        :: is in a block in the blockchain.
        ::
        :: Hint: Use gettransaction for wallet transactions.
        ::
        :: If verbose is 'true', returns an Object with information about 'txid'.
        :: If verbose is 'false' or omitted, returns a string that is serialized, hex-encoded data for 'txid'.
        ::
        :: Result (if verbose is not set or set to false):
        :: "data"      (string) The serialized, hex-encoded data for 'txid'
        ::
        :: Result (if verbose is set to true):
        :: {
        ::   "in_active_chain": b, (bool) Whether specified block is in the active chain or not (only present with explicit "blockhash" argument)
        ::   "hex" : "data",       (string) The serialized, hex-encoded data for 'txid'
        ::   "txid" : "id",        (string) The transaction id (same as provided)
        ::   "hash" : "id",        (string) The transaction hash (differs from txid for witness transactions)
        ::   "size" : n,             (numeric) The serialized transaction size
        ::   "vsize" : n,            (numeric) The virtual transaction size (differs from size for witness transactions)
        ::   "weight" : n,           (numeric) The transaction's weight (between vsize*4-3 and vsize*4)
        ::   "version" : n,          (numeric) The version
        ::   "locktime" : ttt,       (numeric) The lock time
        ::   "vin" : [               (array of json objects)
        ::      {
        ::        "txid": "id",    (string) The transaction id
        ::        "vout": n,         (numeric)
        ::        "scriptSig": {     (json object) The script
        ::          "asm": "asm",  (string) asm
        ::          "hex": "hex"   (string) hex
        ::        },
        ::        "sequence": n      (numeric) The script sequence number
        ::        "txinwitness": ["hex", ...] (array of string) hex-encoded witness data (if any)
        ::      }
        ::      ,...
        ::   ],
        ::   "vout" : [              (array of json objects)
        ::      {
        ::        "value" : x.xxx,            (numeric) The value in BTC
        ::        "n" : n,                    (numeric) index
        ::        "scriptPubKey" : {          (json object)
        ::          "asm" : "asm",          (string) the asm
        ::          "hex" : "hex",          (string) the hex
        ::          "reqSigs" : n,            (numeric) The required sigs
        ::          "type" : "pubkeyhash",  (string) The type, eg 'pubkeyhash'
        ::          "addresses" : [           (json array of string)
        ::            "address"        (string) bitcoin address
        ::            ,...
        ::          ]
        ::        }
        ::      }
        ::      ,...
        ::   ],
        ::   "blockhash" : "hash",   (string) the block hash
        ::   "confirmations" : n,      (numeric) The confirmations
        ::   "blocktime" : ttt         (numeric) The block time in seconds since epoch (Jan 1 1970 GMT)
        ::   "time" : ttt,             (numeric) Same as "blocktime"
        :: }
        ::
        [%get-raw-transaction data=?(@ux raw-transaction-rpc-out)]
        ::  %joinpsbts: Joins multiple distinct PSBTs with different inputs and outputs into one PSBT with inputs and outputs from all of the PSBTs
        :: No input in any of the PSBTs can be in more than one of the PSBTs.
        ::
        :: Result:
        ::   "psbt"          (string) The base64-encoded partially signed transaction
        ::
        [%join-psbts psbt=@t]
        ::  %sendrawtransaction: Submits raw transaction (serialized, hex-encoded) to local node and network.
        ::
        :: Also see createrawtransaction and signrawtransactionwithkey calls.
        ::
        :: Result:
        :: "hex"             (string) The transaction hash in hex
        ::
        [%send-raw-transaction hex=@ux]
        ::  %signrawtransactionwithkey: Sign inputs for raw transaction (serialized, hex-encoded).
        :: The second argument is an array of base58-encoded private
        :: keys that will be the only keys used to sign the transaction.
        :: The third optional argument (may be null) is an array of previous transaction outputs that
        :: this transaction depends on but may not yet be in the block chain.
        ::
        :: Result:
        :: {
        ::   "hex" : "value",                  (string) The hex-encoded raw transaction with signature(s)
        ::   "complete" : true|false,          (boolean) If the transaction has a complete set of signatures
        ::   "errors" : [                      (json array of objects) Script verification errors (if there are any)
        ::     {
        ::       "txid" : "hash",              (string) The hash of the referenced, previous transaction
        ::       "vout" : n,                   (numeric) The index of the output to spent and used as input
        ::       "scriptSig" : "hex",          (string) The hex-encoded signature script
        ::       "sequence" : n,               (numeric) Script sequence number
        ::       "error" : "text"              (string) Verification or signing error related to the input
        ::     }
        ::     ,...
        ::   ]
        :: }
        ::
        $:  %sign-raw-transaction-with-key
            hex=@ux
            complete=?
            =errors
        ==
        ::  %testmempoolaccept: Returns result of mempool acceptance tests indicating if raw transaction (serialized, hex-encoded) would be accepted by mempool.
        ::
        :: This checks if the transaction violates the consensus or policy rules.
        ::
        :: See sendrawtransaction call.
        ::
        :: Result:
        :: [                   (array) The result of the mempool acceptance test for each raw transaction in the input array.
        ::                             Length is exactly one for now.
        ::  {
        ::   "txid"           (string) The transaction hash in hex
        ::   "allowed"        (boolean) If the mempool allows this tx to be inserted
        ::   "reject-reason"  (string) Rejection string (only present when 'allowed' is false)
        ::  }
        :: ]
        ::
        $:  %test-mempool-accept  %-  list
            $:  txid=@ux
                allowed=?
                reject-reason=(unit @t)
        ==  ==
        ::  %utxoupdatepsbt: Updates a PSBT with witness UTXOs retrieved from the UTXO set or the mempool.
        ::
        :: Result:
        ::   "psbt"          (string) The base64-encoded partially signed transaction with inputs updated
        ::
        [%utxo-update-psbt psbt=@t]
    ::  Util
    ::
        ::  %createmultisig: Creates a multi-signature address with n signature
        ::  of m keys required. It returns a json object with the address and
        ::  redeemScript.
        ::
        :: Result:
        :: {
        ::   "address":"multisigaddress",  (string) The value of the new multisig address.
        ::   "redeemScript":"script"       (string) The string value of the hex-encoded redemption script.
        :: }
        ::
        [%create-multi-sig =address redeem-script=@t]
        ::  %deriveaddresses: Derives one or more addresses corresponding to an
        ::  output descriptor. Examples of output descriptors are:
        ::
        ::  Result:
        ::  [ address ] (array) the derived addresses
        ::
        [%derive-addresses (list address)]
        ::  %estimatesmartfee: Estimates the approximate fee per kilobyte needed for a transaction to begin
        :: confirmation within conf_target blocks if possible and return the number of blocks
        :: for which the estimate is valid. Uses virtual transaction size as defined
        :: in BIP 141 (witness data is discounted).
        ::
        ::  Result:
        :: {
        ::   "feerate" : x.x,     (numeric, optional) estimate fee rate in BTC/kB
        ::   "errors": [ str... ] (json array of strings, optional) Errors encountered during processing
        ::   "blocks" : n         (numeric) block number where estimate was found
        :: }
        ::
        [%estimate-smart-fee fee-rate=@t errors=(unit (list @t)) blocks=@ud]
        ::  %getdescriptorinfo: Analyses a descriptor.
        ::
        :: Result:
        :: {
        ::   "descriptor" : "desc",         (string) The descriptor in canonical form, without private keys
        ::   "isrange" : true|false,        (boolean) Whether the descriptor is ranged
        ::   "issolvable" : true|false,     (boolean) Whether the descriptor is solvable
        ::   "hasprivatekeys" : true|false, (boolean) Whether the input descriptor contained at least one private key
        :: }
        ::
        [%get-descriptor-info descriptor=@t is-range=? is-solvable=? has-private-keys=?]
        ::  %signmessagewithprivkey: Sign a message with the private key of an address
        ::
        :: Result:
        :: "signature"          (string) The signature of the message encoded in base 64
        ::
        [%sign-message-with-privkey signature=@t]
        ::  %validateaddress: Return information about the given bitcoin address.
        ::
        :: Result:
        :: {
        ::   "isvalid" : true|false,       (boolean) If the address is valid or not. If not, this is the only property returned.
        ::   "address" : "address",        (string) The bitcoin address validated
        ::   "scriptPubKey" : "hex",       (string) The hex-encoded scriptPubKey generated by the address
        ::   "isscript" : true|false,      (boolean) If the key is a script
        ::   "iswitness" : true|false,     (boolean) If the address is a witness address
        ::   "witness_version" : version   (numeric, optional) The version number of the witness program
        ::   "witness_program" : "hex"     (string, optional) The hex value of the witness program
        :: }
        ::
        $:  %validate-address
            is-valid=?
            =address
            script-pubkey=@ux
            is-script=?
            is-witness=?
            witness-version=(unit @t)
            witness-program=(unit @ux)
        ==
        ::  %verifymessage: Verify a signed message
        ::
        :: Result:
        :: true|false   (boolean) If the signature is verified or not.
        ::
        [%verify-message ?]
    ::  Wallet
    ::
        [%abandon-transaction ~]
        [%abort-rescan ~]
        ::  %add-multisig-address
        ::
        ::  Result:
        :: {
        ::   "address":"multisigaddress",    (string) The value of the new multisig address.
        ::   "redeemScript":"script"         (string) The string value of the hex-encoded redemption script.
        :: }
        ::
        [%add-multisig-address =address redeem-script=@t]
        [%backup-wallet ~]
        ::  %bump-fee:
        ::
        ::  Result:
        ::    {
        ::      "txid":    "value",   (string)  The id of the new transaction
        ::      "origfee":  n,         (numeric) Fee of the replaced transaction
        ::      "fee":      n,         (numeric) Fee of the new transaction
        ::      "errors":  [ str... ] (json array of strings) Errors encountered during processing (may be empty)
        ::    }
        ::
        [%bump-fee txid=@ux orig-fee=@t fee=@t errors=(list @t)]
        ::  %create-wallet:
        ::
        ::  Result:
        ::      {
        ::        "name" :    <wallet_name>,        (string) The wallet name if created successfully. If the wallet was created using a full path, the wallet_name will be the full path.
        ::        "warning" : <warning>,            (string) Warning message if wallet was not loaded cleanly.
        ::      }
        ::
        [%create-wallet name=@t warning=@t]
        ::  %dump-privkey
        ::
        ::  Result:
        :: "key"                (string) The private key
        ::
        [%dump-privkey key=@t]
        [%dump-wallet filename=@t]
        [%encrypt-wallet ~]
        ::
        ::  %get-addresses-by-label:
        ::
        ::   Result:
        ::      { (json object with addresses as keys)
        ::        "address": { (json object with information about address)
        ::          "purpose": "string" (string)  Purpose of address ("send" for sending address, "receive" for receiving address)
        ::        },...
        ::      }
        [%get-addresses-by-label addresses=(list [=address =purpose])]
        ::
        ::  %get-address-info:
        ::
        ::  Result:
        :: {
        ::      "address" : "address",        (string) The bitcoin address validated
        ::      "scriptPubKey" : "hex",       (string) The hex-encoded scriptPubKey generated by the address
        ::      "ismine" : true|false,        (boolean) If the address is yours or not
        ::      "iswatchonly" : true|false,   (boolean) If the address is watchonly
        ::      "solvable" : true|false,      (boolean) Whether we know how to spend coins sent to this address, ignoring the possible lack of private keys
        ::      "desc" : "desc",            (string, optional) A descriptor for spending coins sent to this address (only when solvable)
        ::      "isscript" : true|false,      (boolean) If the key is a script
        ::      "ischange" : true|false,      (boolean) If the address was used for change output
        ::      "iswitness" : true|false,     (boolean) If the address is a witness address
        ::      "witness_version" : version   (numeric, optional) The version number of the witness program
        ::      "witness_program" : "hex"     (string, optional) The hex value of the witness program
        ::      "script" : "type"             (string, optional) The output script type. Only if "isscript" is true and the redeemscript is known. Possible types: nonstandard, pubkey, pubkeyhash, scripthash, multisig, nulldata, witness_v0_keyhash, witness_v0_scripthash, witness_unknown
        ::      "hex" : "hex",                (string, optional) The redeemscript for the p2sh address
        ::      "pubkeys"                     (string, optional) Array of pubkeys associated with the known redeemscript (only if "script" is "multisig")
              ::     [
              ::       "pubkey"
              ::       ,...
              ::     ]
        ::      "sigsrequired" : xxxxx        (numeric, optional) Number of signatures required to spend multisig output (only if "script" is "multisig")
        ::      "pubkey" : "publickeyhex",    (string, optional) The hex value of the raw public key, for single-key addresses (possibly embedded in P2SH or P2WSH)
        ::      "embedded" : {...},           (object, optional) Information about the address embedded in P2SH or P2WSH, if relevant and known. It includes all getaddressinfo output fields for the embedded address, excluding metadata ("timestamp", "hdkeypath", "hdseedid") and relation to the wallet ("ismine", "iswatchonly").
        ::      "iscompressed" : true|false,  (boolean, optional) If the pubkey is compressed
        ::      "label" :  "label"         (string) The label associated with the address, "" is the default label
        ::      "timestamp" : timestamp,      (number, optional) The creation time of the key if available in seconds since epoch (Jan 1 1970 GMT)
        ::      "hdkeypath" : "keypath"       (string, optional) The HD keypath if the key is HD and available
        ::      "hdseedid" : "<hash160>"      (string, optional) The Hash160 of the HD seed
        ::      "hdmasterfingerprint" : "<hash160>" (string, optional) The fingperint of the master key.
        ::      "labels"                      (object) Array of labels associated with the address.
        ::        [{ (json object of label data)
        ::             "name": "labelname" (string) The label
        ::             "purpose": "string" (string) Purpose of address ("send" for sending address, "receive" for receiving address)
        ::        },...
        ::       ]
        ::  }
        ::
        $:  %get-address-info
            =address
            script-pubkey=@ux
            is-mine=?
            is-watchonly=?
            solvable=?
            desc=(unit @t)
            is-script=?
            is-change=?
            is-witness=?
            witness-version=(unit @t)
            witness-program=(unit @ux)
            script=(unit @t)
            hex=(unit @ux)
            pubkeys=(unit (list @ux))
            sigs-required=(unit @ud)
            pubkey=(unit @ux)
            $=  embedded  %-  unit
            $:  script-pubkey=@ux
                solvable=?
                desc=(unit @t)
                is-script=?
                is-change=?
                is-witness=?
                witness-version=(unit @t)
                witness-program=(unit @ux)
                script=(unit @ux)
                hex=(unit @ux)
                pubkeys=(unit (list @ux))
                sigs-required=(unit @ud)
                pubkey=(unit @ux)
                is-compressed=(unit ?)
                label=(unit @t)
                hd-master-finger-print=(unit @ux)
                labels=(list [name=@t =purpose])
            ==
            is-compressed=(unit ?)
            label=(unit @t)
            timestamp=(unit @t)
            hd-key-path=(unit @t)
            hd-seed-id=(unit @ux)
            hd-master-finger-print=(unit @ux)
            labels=(list [name=@t =purpose])
        ==
        ::  %get-balance
        ::
        ::    Result:
        ::    amount: The total amount in BTC received for this wallet.
        ::
        [%get-balance amount=@t]
        ::
        ::  %get-new-address
        ::  "address"    (string) The new bitcoin address
        ::
        [%get-new-address =address]
        ::  %get-raw-change-address
        ::  "address"    (string) The new bitcoin address
        ::
        [%get-raw-change-address =address]
        ::  %get-received-by-address
        ::  "amount"    The total amount in BTC received for this wallet.
        ::
        [%get-received-by-address amount=@t]
        ::  %get-received-by-address
        ::  "amount"    The total amount in BTC received for this wallet.
        ::
        [%get-received-by-label amount=@t]
        ::
        ::  %get-transaction
        ::  Result:
        :: {
        ::   "amount" : x.xxx,        (numeric) The transaction amount in BTC
        ::   "fee": x.xxx,            (numeric) The amount of the fee in BTC. This is negative and only available for the
        ::                               'send' category of transactions.
        ::   "confirmations" : n,     (numeric) The number of confirmations
        ::   "blockhash" : "hash",  (string) The block hash
        ::   "blockindex" : xx,       (numeric) The index of the transaction in the block that includes it
        ::   "blocktime" : ttt,       (numeric) The time in seconds since epoch (1 Jan 1970 GMT)
        ::   "txid" : "transactionid",   (string) The transaction id.
        ::   "time" : ttt,            (numeric) The transaction time in seconds since epoch (1 Jan 1970 GMT)
        ::   "timereceived" : ttt,    (numeric) The time received in seconds since epoch (1 Jan 1970 GMT)
        ::   "bip125-replaceable": "yes|no|unknown",  (string) Whether this transaction could be replaced due to BIP125 (replace-by-fee);
        ::                                                    may be unknown for unconfirmed transactions not in the mempool
        ::   "details" : [
        ::     {
        ::       "address" : "address",          (string) The bitcoin address involved in the transaction
        ::       "category" :                      (string) The transaction category.
        ::                    "send"                  Transactions sent.
        ::                    "receive"               Non-coinbase transactions received.
        ::                    "generate"              Coinbase transactions received with more than 100 confirmations.
        ::                    "immature"              Coinbase transactions received with 100 or fewer confirmations.
        ::                    "orphan"                Orphaned coinbase transactions received.
        ::       "amount" : x.xxx,                 (numeric) The amount in BTC
        ::       "label" : "label",              (string) A comment for the address/transaction, if any
        ::       "vout" : n,                       (numeric) the vout value
        ::       "fee": x.xxx,                     (numeric) The amount of the fee in BTC. This is negative and only available for the
        ::                                            'send' category of transactions.
        ::       "abandoned": xxx                  (bool) 'true' if the transaction has been abandoned (inputs are respendable). Only available for the
        ::                                            'send' category of transactions.
        ::     }
        ::     ,...
        ::   ],
        ::   "hex" : "data"         (string) Raw data for transaction
        :: }
        ::
        $:  %get-transaction
            amount=@t
            fee=@t
            confirmations=@ud
            blockhash=@ux
            blockindex=@ud
            blocktime=@ud
            txid=@ux
            time=@ud
            time-received=@ud
            =bip125-replaceable
            $=  details  %-  list
            $:  =address
                =category
                amount=@t
                label=@t
                vout=@ud
                fee=@t
                abandoned=?
            ==
            hex=@ux
        ==
        ::
        ::  Returns the server's total unconfirmed balance
        ::
        ::  ???
        ::
        [%get-unconfirmed-balance @t]
        ::
        ::  %get-wallet-info
        ::
        ::  Result:
        :: {
        ::   "walletname": xxxxx,               (string) the wallet name
        ::   "walletversion": xxxxx,            (numeric) the wallet version
        ::   "balance": xxxxxxx,                (numeric) the total confirmed balance of the wallet in BTC
        ::   "unconfirmed_balance": xxx,        (numeric) the total unconfirmed balance of the wallet in BTC
        ::   "immature_balance": xxxxxx,        (numeric) the total immature balance of the wallet in BTC
        ::   "txcount": xxxxxxx,                (numeric) the total number of transactions in the wallet
        ::   "keypoololdest": xxxxxx,           (numeric) the timestamp (seconds since Unix epoch) of the oldest pre-generated key in the key pool
        ::   "keypoolsize": xxxx,               (numeric) how many new keys are pre-generated (only counts external keys)
        ::   "keypoolsize_hd_internal": xxxx,   (numeric) how many new keys are pre-generated for internal use (used for change outputs, only appears if the wallet is using this feature, otherwise external keys are used)
        ::   "unlocked_until": ttt,             (numeric) the timestamp in seconds since epoch (midnight Jan 1 1970 GMT) that the wallet is unlocked for transfers, or 0 if the wallet is locked
        ::   "paytxfee": x.xxxx,                (numeric) the transaction fee configuration, set in BTC/kB
        ::   "hdseedid": "<hash160>"            (string, optional) the Hash160 of the HD seed (only present when HD is enabled)
        ::   "private_keys_enabled": true|false (boolean) false if privatekeys are disabled for this wallet (enforced watch-only wallet)
        :: }
        ::
        $:  %get-wallet-info
            wallet-name=@t
            wallet-version=@ud
            balance=@t
            unconfirmed-balance=@t
            immature-balance=@t
            tx-count=@ud
            key-pool-oldest=@ud
            key-pool-size=@ud
            key-pool-size-hd-internal=(unit @ud)
            unlocked-until=(unit @ud)
            pay-tx-fee=@t
            hd-seed-id=(unit @ux)
            private-keys-enabled=?
        ==
        ::
        ::  %import-address
        ::
        [%import-address ~]
        ::
        ::  Response is an array with the same size as the input that has the execution result :
        ::   [{"success": true}, {"success": true, "warnings": ["Ignoring irrelevant private key"]}, {"success": false, "error": {"code": -1, "message": "Internal Server Error"}}, ...]
        ::
        $:  %import-multi  %-  list
            $:  success=?
                warnings=(unit (list @t))
                $=  errors  %-  unit
                $:  code=@t
                    message=@t
        ==  ==  ==
        ::
        [%import-privkey ~]
        ::
        [%import-pruned-funds ~]
        ::
        [%import-pubkey ~]
        ::
        [%import-wallet ~]
        ::
        [%key-pool-refill ~]
        ::
        ::  %list-address-groupings:
        ::
        ::  Result:
        :: [
        ::   [
        ::     [
        ::       "address",            (string) The bitcoin address
        ::       amount,                 (numeric) The amount in BTC
        ::       "label"               (string, optional) The label
        ::     ]
        ::     ,...
        ::   ]
        ::   ,...
        :: ]
        ::
        $:  %list-address-groupings
           $=  address  %-  list
           (list [=address amount=@t label=(unit @t)])
        ==
        ::
        [%list-labels labels=(list @t)]
        ::
        ::  Result:
        :: [
        ::   {
        ::     "txid" : "transactionid",     (string) The transaction id locked
        ::     "vout" : n                      (numeric) The vout value
        ::   }
        ::   ,...
        :: ]
        ::
        [%list-lock-unspent outputs=(list [txid=@ux vout=@ud])]
        ::
        ::  %list-received-by-address
        ::
        ::  Result:
        :: [
        ::   {
        ::     "involvesWatchonly" : true,        (bool) Only returned if imported addresses were involved in transaction
        ::     "address" : "receivingaddress",  (string) The receiving address
        ::     "amount" : x.xxx,                  (numeric) The total amount in BTC received by the address
        ::     "confirmations" : n,               (numeric) The number of confirmations of the most recent transaction included
        ::     "label" : "label",               (string) The label of the receiving address. The default label is "".
        ::     "txids": [
        ::        "txid",                         (string) The ids of transactions received with the address
        ::        ...
        ::     ]
        ::   }
        ::   ,...
        :: ]
        ::
        $:  %list-received-by-address  %-  list
            $:  involves-watch-only=(unit %&)
                =address
                amount=@t
                confirmations=@ud
                label=@t
                txids=(list @ux)
        ==  ==
        ::
        ::  %list-received-by-label
        ::
        ::  Result:
        :: [
        ::   {
        ::     "involvesWatchonly" : true,   (bool) Only returned if imported addresses were involved in transaction
        ::     "amount" : x.xxx,             (numeric) The total amount received by addresses with this label
        ::     "confirmations" : n,          (numeric) The number of confirmations of the most recent transaction included
        ::     "label" : "label"           (string) The label of the receiving address. The default label is "".
        ::   }
        ::   ,...
        :: ]
        ::
        $:  %list-received-by-label  %-  list
            $:  involves-watch-only=(unit %&)
                amount=@t
                confirmations=@ud
                label=@t
        ==  ==
        ::
        ::  %lists-in-ceblock
        ::
        ::  Result:
        :: {
        ::   "transactions": [
        ::     "address":"address",    (string) The bitcoin address of the transaction.
        ::     "category":               (string) The transaction category.
        ::                 "send"                  Transactions sent.
        ::                 "receive"               Non-coinbase transactions received.
        ::                 "generate"              Coinbase transactions received with more than 100 confirmations.
        ::                 "immature"              Coinbase transactions received with 100 or fewer confirmations.
        ::                 "orphan"                Orphaned coinbase transactions received.
        ::     "amount": x.xxx,          (numeric) The amount in BTC. This is negative for the 'send' category, and is positive
        ::                                          for all other categories
        ::     "vout" : n,               (numeric) the vout value
        ::     "fee": x.xxx,             (numeric) The amount of the fee in BTC. This is negative and only available for the 'send' category of transactions.
        ::     "confirmations": n,       (numeric) The number of confirmations for the transaction.
        ::                                           When it's < 0, it means the transaction conflicted that many blocks ago.
        ::     "blockhash": "hashvalue",     (string) The block hash containing the transaction.
        ::     "blockindex": n,          (numeric) The index of the transaction in the block that includes it.
        ::     "blocktime": xxx,         (numeric) The block time in seconds since epoch (1 Jan 1970 GMT).
        ::     "txid": "transactionid",  (string) The transaction id.
        ::     "time": xxx,              (numeric) The transaction time in seconds since epoch (Jan 1 1970 GMT).
        ::     "timereceived": xxx,      (numeric) The time received in seconds since epoch (Jan 1 1970 GMT).
        ::     "bip125-replaceable": "yes|no|unknown",  (string) Whether this transaction could be replaced due to BIP125 (replace-by-fee);
        ::                                                    may be unknown for unconfirmed transactions not in the mempool
        ::     "abandoned": xxx,         (bool) 'true' if the transaction has been abandoned (inputs are respendable). Only available for the 'send' category of transactions.
        ::     "comment": "...",       (string) If a comment is associated with the transaction.
        ::     "label" : "label"       (string) A comment for the address/transaction, if any
        ::     "to": "...",            (string) If a comment to is associated with the transaction.
        ::   ],
        ::   "removed": [
        ::     <structure is the same as "transactions" above, only present if include_removed=true>
        ::     Note: transactions that were re-added in the active chain will appear as-is in this array, and may thus have a positive confirmation count.
        ::   ],
        ::   "lastblock": "lastblockhash"     (string) The hash of the block (target_confirmations-1) from the best block on the main chain. This is typically used to feed back into listsinceblock the next time you call it. So you would generally use a target_confirmations of say 6, so you will be continually re-notified of transactions until they've reached 6 confirmations plus any new ones
        :: }
        ::
        $:  %lists-in-ceblock
            transactions=(list tx-in-block)
            removed=(unit (list tx-in-block))
            lastblock=@ux
        ==
        ::
        ::  %list-transactions
        ::
        ::  Result:
        :: [
        ::   {
        ::     "address":"address",    (string) The bitcoin address of the transaction.
        ::     "category":               (string) The transaction category.
        ::                 "send"                  Transactions sent.
        ::                 "receive"               Non-coinbase transactions received.
        ::                 "generate"              Coinbase transactions received with more than 100 confirmations.
        ::                 "immature"              Coinbase transactions received with 100 or fewer confirmations.
        ::                 "orphan"                Orphaned coinbase transactions received.
        ::     "amount": x.xxx,          (numeric) The amount in BTC. This is negative for the 'send' category, and is positive
        ::                                         for all other categories
        ::     "label": "label",       (string) A comment for the address/transaction, if any
        ::     "vout": n,                (numeric) the vout value
        ::     "fee": x.xxx,             (numeric) The amount of the fee in BTC. This is negative and only available for the
        ::                                          'send' category of transactions.
        ::     "confirmations": n,       (numeric) The number of confirmations for the transaction. Negative confirmations indicate the
        ::                                          transaction conflicts with the block chain
        ::     "trusted": xxx,           (bool) Whether we consider the outputs of this unconfirmed transaction safe to spend.
        ::     "blockhash": "hashvalue", (string) The block hash containing the transaction.
        ::     "blockindex": n,          (numeric) The index of the transaction in the block that includes it.
        ::     "blocktime": xxx,         (numeric) The block time in seconds since epoch (1 Jan 1970 GMT).
        ::     "txid": "transactionid", (string) The transaction id.
        ::     "time": xxx,              (numeric) The transaction time in seconds since epoch (midnight Jan 1 1970 GMT).
        ::     "timereceived": xxx,      (numeric) The time received in seconds since epoch (midnight Jan 1 1970 GMT).
        ::     "comment": "...",       (string) If a comment is associated with the transaction.
        ::     "bip125-replaceable": "yes|no|unknown",  (string) Whether this transaction could be replaced due to BIP125 (replace-by-fee);
        ::                                                      may be unknown for unconfirmed transactions not in the mempool
        ::     "abandoned": xxx          (bool) 'true' if the transaction has been abandoned (inputs are respendable). Only available for the
        ::                                          'send' category of transactions.
        ::   }
        ::
        ::
        $:  %list-transactions  %-  list
            $:  =address
                =category
                amount=@t
                label=@t
                vout=@ud
                fee=@t
                confirmations=@ud
                trusted=?
                blockhash=@ux
                blockindex=@ud
                blocktime=@ud
                txid=@ux
                time=@ud
                time-received=@ud
                comment=@t
                =bip125-replaceable
                abandoned=?
        ==  ==
        ::
        ::  %list-unspent
        ::
        ::  Result:
        :: [                   (array of json object)
        ::   {
        ::     "txid" : "txid",          (string) the transaction id
        ::     "vout" : n,               (numeric) the vout value
        ::     "address" : "address",    (string) the bitcoin address
        ::     "label" : "label",        (string) The associated label, or "" for the default label
        ::     "scriptPubKey" : "key",   (string) the script key
        ::     "amount" : x.xxx,         (numeric) the transaction output amount in BTC
        ::     "confirmations" : n,      (numeric) The number of confirmations
        ::     "redeemScript" : "script" (string) The redeemScript if scriptPubKey is P2SH
        ::     "witnessScript" : "script" (string) witnessScript if the scriptPubKey is P2WSH or P2SH-P2WSH
        ::     "spendable" : xxx,        (bool) Whether we have the private keys to spend this output
        ::     "solvable" : xxx,         (bool) Whether we know how to spend this output, ignoring the lack of keys
        ::     "desc" : xxx,             (string, only when solvable) A descriptor for spending this output
        ::     "safe" : xxx              (bool) Whether this output is considered safe to spend. Unconfirmed transactions
        ::                               from outside keys and unconfirmed replacement transactions are considered unsafe
        ::                               and are not eligible for spending by fundrawtransaction and sendtoaddress.
        ::   }
        ::   ,...
        :: ]
        $:  %list-unspent
        $=  txs  %-  list
            $:  txid=@ux
                vout=@ud
                =address
                label=@t
                script-pubkey=@ux
                amount=@t
                confirmations=@ud
                redeem-script=@ux
                witness-script=@ux
                spendable=?
                solvable=?
                desc=(unit @t)
                safe=?
        ==  ==
        ::
        ::  %list-wallet-dir:
        ::
        :: Response:
        ::    {  "wallets":
        ::       [  {"name":"test-wallet-2"}
        ::          ...
        ::       ]
        ::    }
        [%list-wallet-dir wallets=(list @t)]
        ::
        ::  %list-wallets
        :: Result:
        :: [                         (json array of strings)
        ::   "walletname"            (string) the wallet name
        ::    ...
        :: ]
        ::
        [%list-wallets wallets=(list @t)]
        ::
        ::  %load-wallet
        ::
        ::  Result:
        :: {
        ::   "name" :    <wallet_name>,        (string) The wallet name if loaded successfully.
        ::   "warning" : <warning>,            (string) Warning message if wallet was not loaded cleanly.
        :: }
        ::
        [%load-wallet name=@t warning=@t]
        ::
        ::  Result:
        :: true|false    (boolean) Whether the command was successful or not
        ::
        [%lock-unspent ?]
        ::
        [%remove-pruned-funds ~]
        ::
        ::
        ::  Result:
        :: {
        ::   "start_height"     (numeric) The block height where the rescan started (the requested height or 0)
        ::   "stop_height"      (numeric) The height of the last rescanned block. May be null in rare cases if there was a reorg and the call didn't scan any blocks because they were already scanned in the background.
        :: }
        ::
        [%rescan-blockchain start-height=@ud stop-height=@ud]
        ::
        ::  Result:
        :: "txid"                   (string) The transaction id for the send. Only 1 transaction is created regardless of
        ::                                     the number of addresses.
        ::
        [%send-many txid=@ux]
        ::
        ::  Result:
        :: "txid"                   (string) The transaction id for the send. Only 1 transaction is created regardless of
        ::
        ::
        [%send-to-address txid=@ux]
        ::
        [%set-hd-seed ~]
        ::
        [%set-label ~]
        ::
        [%set-tx-fee ?]
        ::  %sign-message
        ::
        ::  Result:
        :: "signature"          (string) The signature of the message encoded in base 64
        ::
        [%sign-message signature=@t]
        ::  %sign-raw-transaction-with-wallet
        ::
        :: Result:
        :: {
        ::   "hex" : "value",                  (string) The hex-encoded raw transaction with signature(s)
        ::   "complete" : true|false,          (boolean) If the transaction has a complete set of signatures
        ::   "errors" : [                      (json array of objects) Script verification errors (if there are any)
        ::     {
        ::       "txid" : "hash",              (string) The hash of the referenced, previous transaction
        ::       "vout" : n,                   (numeric) The index of the output to spent and used as input
        ::       "scriptSig" : "hex",          (string) The hex-encoded signature script
        ::       "sequence" : n,               (numeric) Script sequence number
        ::       "error" : "text"              (string) Verification or signing error related to the input
        ::     }
        ::     ,...
        ::   ]
        :: }
        $:  %sign-raw-transaction-with-wallet
            hex=@ux
            complete=?
            =errors
        ==
        ::
        [%unload-wallet ~]
        ::
        ::  %wallet-create-fundedpsbt
        ::  Result:
        :: {
        ::   "psbt": "value",        (string)  The resulting raw transaction (base64-encoded string)
        ::   "fee":       n,         (numeric) Fee in BTC the resulting transaction pays
        ::   "changepos": n          (numeric) The position of the added change output, or -1
        :: }
        ::
        [%wallet-create-fundedpsbt psbt=@t fee=@t changepos=?(@ud %'-1')]
        ::
        [%wallet-lock ~]
        ::
        [%wallet-passphrase ~]
        ::
        [%wallet-passphrase-change ~]
        ::
        ::
        ::  Result:
        :: {
        ::   "psbt" : "value",          (string) The base64-encoded partially signed transaction
        ::   "complete" : true|false,   (boolean) If the transaction has a complete set of signatures
        ::   ]
        :: }
        ::
        [%wallet-process-psbt psbt=@t complete=?]
    ::  ZMQ
    ::
        ::  %get-zmq-notifications:
        ::
        ::  Result:
        :: [
        ::   {                        (json object)
        ::     "type": "pubhashtx",   (string) Type of notification
        ::     "address": "...",      (string) Address of the publisher
        ::     "hwm": n                 (numeric) Outbound message high water mark
        ::   },
        ::   ...
        :: ]
        ::
        $:  %get-zmq-notifications  %-  list
            $:  type=@t
                =address
                hwm=@ud
    ==  ==  ==
  --
--
