=>  ::  Helper types used within and outside the library
    ::
    |%
    ::  +address: base58check encoded public key (20 bytes)
    ::
    ++  address  @uc
    ++  blockhash  @ux
    ::  $estimate-mode
    ::
    ::    Used in:
    ::      - %fund-raw-transaction
    ::      - %estimate-smart-fee
    ::      - %bump-fee
    ::      - %wallet-create-fundedpsbt
    ::
    +$  estimate-mode  (unit ?(%'ECONOMICAL' %'CONSERVATIVE' %'UNSET'))
    ::  $category:
    ::
    ::    Used in:
    ::      - $tx-in-block
    ::      - %get-transaction
    ::      - %list-transactions
    ::
    +$  category  ?(%send %receive %generate %immature %orphan)
    ::  $chain-status:
    ::
    ::    Used in:
    ::      - %get-chain-tips
    ::
    +$  chain-status
      $?  %invalid
          %headers-only
          %valid-headers
          %valid-fork
          %active
      ==
    ::  $soft-fork-status:
    ::
    ::    Used in:
    ::      - %get-blockchain-info/$bip9-softforks
    ::
    +$  soft-fork-status  ?(%defined %started %locked-in %active %failed)
    ::  $purpose:
    ::
    ::    Used in:
    ::      - %get-addresses-by-label
    ::      - %get-address-info
    ::
    +$  purpose  ?(%send %receive)
    ::  $address-type:
    ::
    ::    Used in:
    ::      - %add-multisig-address
    ::
    +$  address-type  ?(%legacy %p2sh-segwit %bech32)
    ::  $bip125-replaceable:
    ::
    ::    Used in:
    ::      - %get-transaction
    ::      - %list-transactions
    ::      - $tx-in-block
    ::
    +$  bip125-replaceable  ?(%yes %no %unknown)
    ::  $network-name:
    ::
    ::    Used in:
    ::      - %get-blockchain-info
    ::
    +$  network-name  ?(%main %test %regtest)
    ::  $sig-hash:
    ::
    ::    Used in:
    ::      - $sig-hash-type
    ::
    +$  sig-hash
      $?  %'ALL'
          %'NONE'
          %'SINGLE'
          %'ALL|ANYONECANPAY'
          %'NONE|ANYONECANPAY'
          %'SINGLE|ANYONECANPAY'
      ==
    ::  $sig-hash-type:
    ::
    ::    Used in:
    ::      - $raw-tx
    ::      - %sign-raw-transaction-with-key
    ::      - %wallet-process-psbt
    ::      - %decode-psbt
    ::
    +$  sig-hash-type  (unit sig-hash)
    ::  $script:
    ::
    ::    Used in:
    ::      - %decode-psbt: $redeem-script/$witness-script
    ::
    +$  script  [asm=@t hex=@ux type=@t]
    ::  $script-pubkey:
    ::
    ::    Used in:
    ::      - $utxo
    ::
    +$  script-pubkey  [asm=@t hex=@ux type=@t =address]
    ::  $range:
    ::
    ::    Used in:
    ::      - %derive-addresses
    ::      - $scan-object
    ::
    +$  range  (unit ?(@ud [@ud @ud]))
    ::  $vin:
    ::
    ::    Used in:
    ::      - $serialized-tx
    ::      - $raw-transaction-rpc-out
    ::
    +$  vin
      $:  txid=@ux
          vout=@ud
          script-sig=[asm=@t hex=@ux]
          tx-in-witness=(list @ux)
          sequence=@ud
      ==
    ::  $vout:
    ::
    ::    Used in:
    ::      - $serialized-tx
    ::      - $raw-transaction-rpc-out
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
    ::  $input:
    ::
    ::    Used in:
    ::      - %wallet-create-fundedpsbt
    ::      - $partially-signed-transaction
    ::
    +$  input
      $:  txid=@ux
          vout=@ud
          sequence=@ud
      ==
    ::  $output:
    ::
    ::    Used in:
    ::      - %wallet-create-fundedpsbt
    ::      - $partially-signed-transaction
    ::
    +$  output
      $:  data=[%data @ux]
          addresses=(list [=address amount=@t])
      ==
    ::  $scan-object:
    ::
    ::    Used in:
    ::      - %scan-tx-outset
    ::
    +$  scan-object
      $?  descriptor=@t
          $=  object
          $:  desc=@t
              =range
      ==  ==
    ::  $utxo:
    ::
    ::    Used in:
    ::      - %decode-psbt
    ::
    +$  utxo  %-  unit
      $:  amount=@t
          =script-pubkey
      ==
    ::  $partially-signed-transaction:
    ::
    ::    Used in:
    ::      - %create-psbt
    ::
    +$  partially-signed-transaction
      $:  inputs=(list input)
          outputs=output
          locktime=(unit @ud)
          replaceable=(unit ?)
      ==
    ::  $import-request:
    ::
    ::    Used in:
    ::      - %import-multi
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
    ::  $serialized-tx:
    ::
    ::    Used in:
    ::      - %decode-psbt
    ::      - %decode-raw-transaction
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
    ::  $prev-tx:
    ::
    ::    Used in:
    ::      - $raw-tx
    ::      - %sign-raw-transaction-with-key
    ::
    +$  prev-tx
      $:  txid=@ux
          vout=@ud
          script-pubkey=@ux
          redeem-script=@ux
          witness-script=@ux
          amount=@t
      ==
    ::  $raw-tx:
    ::
    ::    Used in:
    ::      - %sign-raw-transaction-with-wallet
    ::
    +$  raw-tx
      $:  hex-string=@ux
          prev-txs=(unit (list prev-tx))
          =sig-hash-type
      ==
    ::  $raw-transaction-rpc-out:
    ::
    ::    Used in:
    ::      - %get-block
    ::      - %get-raw-transaction
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
    ::  $tx-in-block:
    ::
    ::    Used in:
    ::      - %lists-in-ceblock
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
    ::  $errors:
    ::
    ::    Used in:
    ::      - %sign-raw-transaction-with-key
    ::      - %sign-raw-transaction-with-wallet
    ::
    +$  errors  %-  list
      $:  txid=@ux
          vout=@ud
          script-sig=@ux
          sequence=@ud
          error=@t
      ==
    ::  $mem-pool:
    ::
    ::    Used in:
    ::      - $mem-pool-response
    ::      - %get-mempool-entry
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
    ::  $mem-pool-response:
    ::
    ::    Used in:
    ::      - %get-raw-mempool
    ::      - %get-mempool-entry
    ::      -  %get-mempool-ancestors
    ::      -  %get-mempool-descendants
    ::      -  %get-raw-mempool
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
        $:  %create-multi-sig
            n-required=@ud
            keys=(list @ux)
            address-type=(unit address-type)
        ==
        ::  %deriveaddresses: Derives one or more addresses corresponding to an
        ::  output descriptor. Examples of output descriptors are:
        ::
        [%derive-addresses descriptor=@t =range]
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
        [%get-address-info =address]
        ::  %get-balance: Returns the total available balance.
        ::
        $:  %get-balance
            $?  ~
                $:  dummy=(unit @t)
                    minconf=(unit @ud)
                    include-watch-only=(unit ?)
        ==  ==  ==
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
        [%get-wallet-info wallet=@t]
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
        [%get-best-block-hash hex=@ux]
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
      ::
        [%get-block-count count=@ud]
      ::
        [%get-block-hash hash=@ux]
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
      ::
        $:  %get-block-stats
            avg-fee=@t
            avg-feerate=@ud
            avg-tx-size=@ud
            block-hash=@ux
            $=  fee-rate-percentiles
            $:  p-1=@t
                p-2=@t
                p-3=@t
                p-4=@t
                p-5=@t
            ==
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
      ::
        $:  %get-chain-tips  %-  list
            $:  height=@ud
                hash=@ux
                branch-len=@ud
                status=chain-status
        ==  ==
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
      ::
        [%get-difficulty n=@t]
      ::
        [%get-mempool-ancestors mem-pool-response]
      ::
        [%get-mempool-descendants mem-pool-response]
      ::
        [%get-mempool-entry mem-pool]
      ::
        $:  %get-mempool-info
            size=@ud
            bytes=@ud
            usage=@ud
            max-mem-pool=@ud
            mem-pool-min-fee=@t
            min-relay-tx-fee=@t
        ==
      ::
        [%get-raw-mempool mem-pool-response]
      ::
        $:  %get-tx-out
            best-block=@ux
            confirmations=@ud
            value=@t
            $=  script-pubkey
            $:  asm=@t
                hex=@ux
                req-sigs=@ud
                type=@t
                addresses=(list address)
            ==
            coinbase=?
        ==
      ::
        [%get-tx-out-proof data=@ux]
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
      ::
        [%precious-block ~]
      ::
        [%prune-blockchain height=@ud]
      ::
        [%save-mempool ~]
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
      ::
        [%verify-chain ?]
      ::
        [%verify-tx-out-proof (list @ux)]
    ::  Control
        [%help ~]
    ::  Generating
    ::
        [%generate blocks=(list blockhash)]
    ::  Raw Transactions
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
      ::
        [%combine-psbt psbt=@t]
      ::
        [%combine-raw-transaction hex=@ux]
      ::
        [%convert-to-psbt psbt=@t]
      ::
        [%create-psbt psbt=@t]
      ::
        [%create-raw-transaction transaction=@ux]
      ::
        $:  %decode-psbt
            tx=serialized-tx
            unknown=(map @t @t)
            $=  inputs  %-  list
            $:  non-witness-utxo=utxo
                witness-utxo=utxo
                $=  partial-signatures  %-  unit
                  (map pubkey=@ux signature=@ux)
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
      ::
        [%decode-raw-transaction =serialized-tx]
      ::
        $:  %decode-script
            asm=@t
            hex=@ux
            type=@t
            req-sigs=@ud
            addresses=(list address)
            p2sh=address
        ==
      ::
        [%finalize-psbt psbt=@t hex=@ux complete=?]
      ::
        [%fund-raw-transaction hex=@ux fee=@t change-pos=?(@ud %'-1')]
      ::
        [%get-raw-transaction data=?(@ux raw-transaction-rpc-out)]
      ::
        [%join-psbts psbt=@t]
      ::
        [%send-raw-transaction hex=@ux]
      ::
        $:  %sign-raw-transaction-with-key
            hex=@ux
            complete=?
            =errors
        ==
      ::
        $:  %test-mempool-accept  %-  list
            $:  txid=@ux
                allowed=?
                reject-reason=(unit @t)
        ==  ==
      ::
        [%utxo-update-psbt psbt=@t]
      ::
    ::  Util
    ::
        [%create-multi-sig =address redeem-script=@t]
      ::
        [%derive-addresses (list address)]
      ::
        [%estimate-smart-fee fee-rate=@t errors=(unit (list @t)) blocks=@ud]
      ::
        $:  %get-descriptor-info
            descriptor=@t
            is-range=?
            is-solvable=?
            has-private-keys=?
        ==
      ::
        [%sign-message-with-privkey signature=@t]
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
      ::
        [%verify-message ?]
      ::
    ::  Wallet
    ::
        [%abandon-transaction ~]
      ::
        [%abort-rescan ~]
      ::
        [%add-multisig-address =address redeem-script=@t]
      ::
        [%backup-wallet ~]
      ::
        [%bump-fee txid=@ux orig-fee=@t fee=@t errors=(list @t)]
      ::
        [%create-wallet name=@t warning=@t]
      ::
        [%dump-privkey key=@t]
      ::
        [%dump-wallet filename=@t]
      ::
        [%encrypt-wallet ~]
      ::
        [%get-addresses-by-label addresses=(list [=address =purpose])]
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
      ::
        [%get-balance amount=@t]
      ::
        [%get-new-address =address]
      ::
        [%get-raw-change-address =address]
      ::
        [%get-received-by-address amount=@t]
      ::
        [%get-received-by-label amount=@t]
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
        [%get-unconfirmed-balance @t]
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
        [%import-address ~]
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
        $:  %list-address-groupings
           $=  address  %-  list
           (list [=address amount=@t label=(unit @t)])
        ==
      ::
        [%list-labels labels=(list @t)]
      ::
        [%list-lock-unspent outputs=(list [txid=@ux vout=@ud])]
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
        $:  %list-received-by-label  %-  list
            $:  involves-watch-only=(unit %&)
                amount=@t
                confirmations=@ud
                label=@t
        ==  ==
      ::
        $:  %lists-in-ceblock
            transactions=(list tx-in-block)
            removed=(unit (list tx-in-block))
            lastblock=@ux
        ==
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
        [%list-wallet-dir wallets=(list @t)]
      ::
        [%list-wallets wallets=(list @t)]
      ::
        [%load-wallet name=@t warning=@t]
      ::
        [%lock-unspent ?]
      ::
        [%remove-pruned-funds ~]
      ::
        [%rescan-blockchain start-height=@ud stop-height=@ud]
      ::
        [%send-many txid=@ux]
      ::
        [%send-to-address txid=@ux]
      ::
        [%set-hd-seed ~]
      ::
        [%set-label ~]
      ::
        [%set-tx-fee ?]
      ::
        [%sign-message signature=@t]
      ::
        $:  %sign-raw-transaction-with-wallet
            hex=@ux
            complete=?
            =errors
        ==
      ::
        [%unload-wallet ~]
      ::
        [%wallet-create-fundedpsbt psbt=@t fee=@t changepos=?(@ud %'-1')]
      ::
        [%wallet-lock ~]
      ::
        [%wallet-passphrase ~]
      ::
        [%wallet-passphrase-change ~]
      ::
        [%wallet-process-psbt psbt=@t complete=?]
      ::
    ::  ZMQ
    ::
        $:  %get-zmq-notifications  %-  list
            $:  type=@t
                =address
                hwm=@ud
    ==  ==  ==
  --
--
