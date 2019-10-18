|%
++  address  @  ::TODO  did an aura exist for this? we need a to-string arm
++  blockhash  @ux
+$  map-type  ?(@ud @t ?)
+$  sig-hash-type  %-  unit
  $?  %'ALL'
      %'NONE'
      %'SINGLE'
      %'ALL|ANYONECANPAY'
      %'NONE|ANYONECANPAY'
      %'SINGLE|ANYONECANPAY'
  ==
::
+$  estimate-mode  (unit ?(%'ECONOMICAL' %'CONSERVATIVE' %'UNSET'))
::
+$  import-request
  $:  desc=@t
      script-pubkey=@t
      timestamp=?(@da %'now')
      redeem-script=@t
      witness-script=@t
      pub-keys=(unit (list @t))
      keys=(unit (list @t))
      range=?(@ud [@ud @ud])
      internal=?
      watchonly=?
      label=@t
      keypool=?
  ==
::
+$  category  ?(%'send' %'receive' %'generate' %'immature' %'orphan')
::
+$  tx
  $:  txid=@t
      vout=@ud
      script-pubkey=@t
      redeem-script=@t
      witness-script=@t
      amount=@t
  ==
::
+$  tx-short
  $:  txid=@t
      vout=@ud
      sequencet=@ud
  ==
::
+$  tx-response
  $:  address=@t
      =category
      amount=@t
      label=@t
      vout=@ud
      fee=@t
      confirmations=@t
      blockhash=@t
      blockindex=@ud
      blocktime=@t
      txid=@t
      time=@t
      time-received=@t
      bip125-replaceable=(unit ?)
      abandoned=?
      comment=@t
      label=@t
      to=@t
  ==
+$  btc-node-hook-action  request:btc-rpc
::
++  btc-rpc
  |%
  +$  request
    $%
    ::  node management
    ::
        [%generate blocks=@ud max-tries=(unit @ud)]
        [%get-blockchain-info ~]
        ::
    ::  chain state
    ::
        [%get-block-count ~]
    ::  wallet management
        ::  %abandon-transaction: Mark in-wallet transaction as abandoned.
        ::
        ::    %txid: The transaction id
        ::
        [%abandon-transaction txid=@t]
        ::  %abort-rescan: Stops current wallet rescan triggered by an
        ::  RPC call, e.g. by an importprivkey call.
        ::
        [%abort-rescan ~]
        ::
        ::
        :: %add-multisig-address:
        ::    Add a nrequired-to-sign multisignature address
        ::    to the wallet. Requires a new wallet backup.
        ::    Each key is a Bitcoin address or hex-encoded public key.
        ::    This functionality is only intended for use with
        ::    non-watchonly addresses.
        ::    See `importaddress` for watchonly p2sh address support.
        ::    If 'label' is specified, assign address to that label.
        ::
        ::  - %nrequired:
        ::    The number of required signatures out of the n keys or addresses.
        ::  - %keys:
        ::    A json array of bitcoin addresses or hex-encoded public keys
        ::  - %label: A label to assign the addresses to.
        ::  - %address-type: The address type to use.
        ::    Options are "legacy", "p2sh-segwit", and "bech32".
        $:  %add-multisig-address
            n-required=@ud
            keys=(list @ux)
            label=(unit @t)
            address-type=(unit @t)
        ==
        ::  %backupwallet:
        ::    Safely copies current wallet file to destination.
        ::
        [%backup-wallet destination=@t]
        ::  Bumps the fee of an opt-in-RBF transaction T, replacing it with a new transaction B.
        ::  (An opt-in RBF transaction with the given txid must be in the wallet.
        ::  (The command will pay the additional fee by decreasing (or perhaps removing) its change output.
        ::  (If the change output is not big enough to cover the increased fee, the command will currently fail
        ::  (instead of adding new inputs to compensate. (A future implementation could improve this.)
        ::  (The command will fail if the wallet or mempool contains a transaction that spends one of T's outputs.
        ::  (By default, the new fee will be calculated automatically using estimatesmartfee.
        ::  (The user can specify a confirmation target for estimatesmartfee.
        ::  (Alternatively, the user can specify totalFee, or use RPC settxfee to set a higher fee rate.
        ::  (At a minimum, the new fee rate must be high enough to pay an additional new relay fee (incrementalfee
        ::  (returned by getnetworkinfo) to enter the node's mempool.
        ::
        ::  (Arguments:
        ::  (1. txid                           (string, required) The txid to be bumped
        ::  (2. options                        (json object, optional)
        ::      {
        ::        "confTarget": n,           (numeric, optional, default=fallback to wallet's default) Confirmation target (in blocks)
        ::        "totalFee": n,             (numeric, optional, default=fallback to 'confTarget') Total fee (NOT feerate) to pay, in satoshis.
        ::                                   In rare cases, the actual fee paid might be slightly higher than the specified
        ::                                   totalFee if the tx change output has to be removed because it is too close to
        ::                                   the dust threshold.
        ::        "replaceable": bool,       (boolean, optional, default=true) Whether the new transaction should still be
        ::                                   marked bip-125 replaceable. If true, the sequence numbers in the transaction will
        ::                                   be left unchanged from the original. If false, any input sequence numbers in the
        ::                                   original transaction that were less than 0xfffffffe will be increased to 0xfffffffe
        ::                                   so the new transaction will not be explicitly bip-125 replaceable (though it may
        ::                                   still be replaceable in practice, for example if it has unconfirmed ancestors which
        ::                                   are replaceable).
        ::        "estimate_mode": "str",    (string, optional, default=UNSET) The fee estimate mode, must be one of:
        ::                                   "UNSET"
        ::                                   "ECONOMICAL"
        ::                                   "CONSERVATIVE"
        ::      }
        ::
        $:  %bump-fee
            txid=@t
            $=  options  %-  unit
            $:  conf-target=(unit @t)
                total-fee=(unit @t)
                replaceable=(unit ?)
                estimate-mode=(unit ?(%'ECONOMICAL' %'CONSERVATIVE' %'UNSET'))
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
        ::  Reveals the private key corresponding to 'address'.
        ::  (Then the importprivkey can be used with this output
        ::
        ::  (Arguments:
        ::  (1. address    (string, required) The bitcoin address for the private key
        ::
        [%dump-privkey address=@t]
        ::  Dumps all wallet keys in a human-readable format to a server-side file. This does not allow overwriting existing files.
        ::  (Imported scripts are included in the dumpfile, but corresponding BIP173 addresses, etc. may not be added automatically by importwallet.
        ::  (Note that if your wallet contains keys which are not derived from your HD seed (e.g. imported keys), these are not covered by
        ::  (only backing up the seed itself, and must be backed up too (e.g. ensure you back up the whole dumpfile).
        ::
        ::  (Arguments:
        ::  (1. filename    (string, required) The filename with path (either absolute or relative to bitcoind)
        ::
        [%dump-wallet filename=@t]
        ::  Encrypts the wallet with 'passphrase'. This is for first time encryption.
        ::  (After this, any calls that interact with private keys such as sending or signing
        ::  (will require the passphrase to be set prior the making these calls.
        ::  (Use the walletpassphrase call for this, and then walletlock call.
        ::  (If the wallet is already encrypted, use the walletpassphrasechange call.
        ::
        ::  (Arguments:
        ::  (1. passphrase    (string, required) The pass phrase to encrypt the wallet with. It must be at least 1 character, but should be long.
        ::
        [%encrypt-wallet passphrase=@t]
        ::  Returns the list of addresses assigned the specified label.
        ::
        ::  (Arguments:
        ::  (1. label    (string, required) The label.
        ::
        [%get-addresses-by-label label=@t]
        ::  Return information about the given bitcoin address. Some information requires the address
        ::  (to be in the wallet.
        ::
        ::  (Arguments:
        ::  (1. address    (string, required) The bitcoin address to get the information of.
        ::
        [%get-address-info address=@t]
        ::  Returns the total available balance.
        ::  (The available balance is what the wallet considers currently spendable, and is
        ::  (thus affected by options which limit spendability such as -spendzeroconfchange.
        ::
        ::  (Arguments:
        ::  (1. dummy                (string, optional) Remains for backward compatibility. Must be excluded or set to "*".
        ::  (2. minconf              (numeric, optional, default=0) Only include transactions confirmed at least this many times.
        ::  (3. include-watch-only    (boolean, optional, default=false) Also include balance in watch-only addresses (see 'importaddress')
        ::
        [%get-balance dummy=(unit @t) minconf=(unit @ud) include-watch-only=(unit ?)]
        ::  Returns a new Bitcoin address for receiving payments.
        ::  (If 'label' is specified, it is added to the address book
        ::  (so payments received with the address will be associated with 'label'.
        ::
        ::  (Arguments:
        ::  (1. label           (string, optional, default="") The label name for the address to be linked to. It can also be set to the empty string "" to represent the default label. The label does not need to exist, it will be created if there is no label by the given name.
        ::  (2. address-type    (string, optional, default=set by -addresstype) The address type to use. Options are "legacy", "p2sh-segwit", and "bech32".
        ::
        [%get-new-address label=(unit @t) address-type=(unit @t)]
        ::  Returns a new Bitcoin address, for receiving change.
        ::  (This is for use with raw transactions, NOT normal use.
        ::
        ::  (Arguments:
        ::  (1. address-type    (string, optional, default=set by -changetype) The address type to use. Options are "legacy", "p2sh-segwit", and "bech32".
        ::
        [%get-raw-change-address address-type=(unit @t)]
        ::  Returns the total amount received by the given address in transactions with at least minconf confirmations.
        ::
        ::  (Arguments:
        ::  (1. address    (string, required) The bitcoin address for transactions.
        ::  (2. minconf    (numeric, optional, default=1) Only include transactions confirmed at least this many times.
        ::
        [%get-received-by-address address=@t minconf=@ud]
        ::  Returns the total amount received by addresses with <label> in transactions with at least [minconf] confirmations.
        ::
        ::  (Arguments:
        ::  (1. label      (string, required) The selected label, may be the default label using "".
        ::  (2. minconf    (numeric, optional, default=1) Only include transactions confirmed at least this many times.
        ::
        [%get-received-by-label label=@t minconf=(unit @ud)]
        ::  Get detailed information about in-wallet transaction <txid>
        ::
        ::  (Arguments:
        ::  (1. txid                 (string, required) The transaction id
        ::  (2. include-watch-only    (boolean, optional, default=false) Whether to include watch-only addresses in balance calculation and details[]
        ::
        [%get-transaction txid=@t include-watch-only=(unit ?)]
        ::  Returns the server's total unconfirmed balance
        ::
        [%get-unconfirmed-balance ~]
        ::  Returns an object containing various wallet state info.
        ::
        [%get-wallet-info ~]
        ::  Adds an address or script (in hex) that can be watched as if it were in your wallet but cannot be used to spend. Requires a new wallet backup.
        ::
        ::  (Note: This call can take over an hour to complete if rescan is true, during that time, other rpc calls
        ::  (may report that the imported address exists but related transactions are still missing, leading to temporarily incorrect/bogus balances and unspent outputs until rescan completes.
        ::  (If you have the full public key, you should call importpubkey instead of this.
        ::
        ::  (Note: If you import a non-standard raw script in hex form, outputs sending to it will be treated
        ::  (as change, and not show up in many RPCs.
        ::
        ::  (Arguments:
        ::  (1. address    (string, required) The Bitcoin address (or hex-encoded script)
        ::  (2. label      (string, optional, default="") An optional label
        ::  (3. rescan     (boolean, optional, default=true) Rescan the wallet for transactions
        ::  (4. p2sh       (boolean, optional, default=false) Add the P2SH version of the script as well
        ::
        [%import-address address=@t label=(unit @t) rescan=(unit ?) p2sh=(unit ?)]
        ::  Import addresses/scripts (with private or public keys, redeem script (P2SH)), optionally rescanning the blockchain from the earliest creation time of the imported scripts. Requires a new wallet backup.
        ::
        ::  (If an address/script is imported without all of the private keys required to spend from that address, it will be watchonly. The 'watchonly' option must be set to true in this case or a warning will be returned.
        ::  (Conversely, if all the private keys are provided and the address/script is spendable, the watchonly option must be set to false, or a warning will be returned.
        ::
        ::  (Note: This call can take over an hour to complete if rescan is true, during that time, other rpc calls
        ::  (may report that the imported keys, addresses or scripts exists but related transactions are still missing.
        ::
        ::  (Arguments:
        ::  (1. requests                                                         (json array, required) Data to be imported
        ::      [
        ::        {                                                            (json object)
        ::          "desc": "str",                                             (string) Descriptor to import. If using descriptor, do not also provide address/scriptPubKey, scripts, or pubkeys
        ::          "scriptPubKey": "<script>" | { "address":"<address>" },    (string / json, required) Type of scriptPubKey (string for script, json for address). Should not be provided if using a descriptor
        ::          "timestamp": timestamp | "now",                            (integer / string, required) Creation time of the key in seconds since epoch (Jan 1 1970 GMT),
        ::                                                                     or the string "now" to substitute the current synced blockchain time. The timestamp of the oldest
        ::                                                                     key will determine how far back blockchain rescans need to begin for missing wallet transactions.
        ::                                                                     "now" can be specified to bypass scanning, for keys which are known to never have been used, and
        ::                                                                     0 can be specified to scan the entire blockchain. Blocks up to 2 hours before the earliest key
        ::                                                                     creation time of all keys being imported by the importmulti call will be scanned.
        ::          "redeemscript": "str",                                     (string) Allowed only if the scriptPubKey is a P2SH or P2SH-P2WSH address/scriptPubKey
        ::          "witnessscript": "str",                                    (string) Allowed only if the scriptPubKey is a P2SH-P2WSH or P2WSH address/scriptPubKey
        ::          "pubkeys": [                                               (json array, optional, default=empty array) Array of strings giving pubkeys to import. They must occur in P2PKH or P2WPKH scripts. They are not required when the private key is also provided (see the "keys" argument).
        ::            "pubKey",                                                (string)
        ::            ...
        ::          ],
        ::          "keys": [                                                  (json array, optional, default=empty array) Array of strings giving private keys to import. The corresponding public keys must occur in the output or redeemscript.
        ::            "key",                                                   (string)
        ::            ...
        ::          ],
        ::          "range": n or [n,n],                                       (numeric or array) If a ranged descriptor is used, this specifies the end or the range (in the form [begin,end]) to import
        ::          "internal": bool,                                          (boolean, optional, default=false) Stating whether matching outputs should be treated as not incoming payments (also known as change)
        ::          "watchonly": bool,                                         (boolean, optional, default=false) Stating whether matching outputs should be considered watchonly.
        ::          "label": "str",                                            (string, optional, default='') Label to assign to the address, only allowed with internal=false
        ::          "keypool": bool,                                           (boolean, optional, default=false) Stating whether imported public keys should be added to the keypool for when users request new addresses. Only allowed when wallet private keys are disabled
        ::        },
        ::        ...
        ::      ]
        ::  (2. options                                                          (json object, optional)
        ::      {
        ::        "rescan": bool,                                              (boolean, optional, default=true) Stating if should rescan the blockchain after all imports
        ::      }
        ::
        $:  %import-multi
            requests=(list import-request)
            options=(unit rescan=?)
        ==
        ::  Adds a private key (as returned by dumpprivkey) to your wallet. Requires a new wallet backup.
        ::  (Hint: use importmulti to import more than one private key.
        ::
        ::  (Note: This call can take over an hour to complete if rescan is true, during that time, other rpc calls
        ::  (may report that the imported key exists but related transactions are still missing, leading to temporarily incorrect/bogus balances and unspent outputs until rescan completes.
        ::
        ::  (Arguments:
        ::  (1. privkey    (string, required) The private key (see dumpprivkey)
        ::  (2. label      (string, optional, default=current label if address exists, otherwise "") An optional label
        ::  (3. rescan     (boolean, optional, default=true) Rescan the wallet for transactions
        ::
        [%import-privkey privkey=@t label=(unit @t) rescan=(unit ?)]
        ::  Imports funds without rescan. Corresponding address or script must previously be included in wallet. Aimed towards pruned wallets. The end-user is responsible to import additional transactions that subsequently spend the imported outputs or rescan after the point in the blockchain the transaction is included.
        ::
        ::  (Arguments:
        ::  (1. rawtransaction    (string, required) A raw transaction in hex funding an already-existing address in wallet
        ::  (2. txoutproof        (string, required) The hex output from gettxoutproof that contains the transaction
        ::
        [%import-pruned-funds raw-transaction=@t tx-out-proof=@t]
        ::  Adds a public key (in hex) that can be watched as if it were in your wallet but cannot be used to spend. Requires a new wallet backup.
        ::
        ::  (Note: This call can take over an hour to complete if rescan is true, during that time, other rpc calls
        ::  (may report that the imported pubkey exists but related transactions are still missing, leading to temporarily incorrect/bogus balances and unspent outputs until rescan completes.
        ::
        ::  (Arguments:
        ::  (1. pubkey    (string, required) The hex-encoded public key
        ::  (2. label     (string, optional, default="") An optional label
        ::  (3. rescan    (boolean, optional, default=true) Rescan the wallet for transactions
        ::
        [%import-pubkey pubkey=@t label=(unit @t) rescan=(unit ?)]
        ::  Imports keys from a wallet dump file (see dumpwallet). Requires a new wallet backup to include imported keys.
        ::
        ::  (Arguments:
        ::  (1. filename    (string, required) The wallet file
        ::
        [%import-wallet filename=@t]
        ::  Fills the keypool.
        ::
        ::  (Arguments:
        ::  (1. newsize    (numeric, optional, default=100) The new keypool size
        ::
        [%key-pool-refill new-size=(unit @ud)]
        ::  Lists groups of addresses which have had their common ownership
        ::  (made public by common use as inputs or as the resulting change
        ::  (in past transactions
        ::
        [%list-address-groupings ~]
        ::  Returns the list of all labels, or labels that are assigned to addresses with a specific purpose.
        ::
        ::  (Arguments:
        ::  (1. purpose    (string, optional) Address purpose to list labels for ('send','receive'). An empty string is the same as not providing this argument.
        ::
        [%list-labels purpose=(unit @t)]
        ::  Returns list of temporarily unspendable outputs.
        ::  (See the lockunspent call to lock and unlock transactions for spending.
        ::
        [%list-lock-unspent ~]
        ::  List balances by receiving address.
        ::
        ::  (Arguments:
        ::  (1. minconf              (numeric, optional, default=1) The minimum number of confirmations before payments are included.
        ::  (2. include-empty        (boolean, optional, default=false) Whether to include addresses that haven't received any payments.
        ::  (3. include-watch-only    (boolean, optional, default=false) Whether to include watch-only addresses (see 'importaddress').
        ::  (4. address-filter       (string, optional) If present, only return information on this address.
        ::
        $:  %list-received-by-address
            minconf=(unit @ud)
            include-empty=(unit ?)
            include-watch-only=(unit ?)
            address-filter=(unit @t)
        ==
        ::  List received transactions by label.
        ::
        ::  (Arguments:
        ::  (1. minconf              (numeric, optional, default=1) The minimum number of confirmations before payments are included.
        ::  (2. include-empty        (boolean, optional, default=false) Whether to include labels that haven't received any payments.
        ::  (3. include-watch-only    (boolean, optional, default=false) Whether to include watch-only addresses (see 'importaddress').
        ::
        $:  %list-received-by-label
            minconf=(unit @ud)
            include-empty=(unit ?)
            include-watch-only=(unit ?)
        ==
        ::  Get all transactions in blocks since block [blockhash], or all transactions if omitted.
        ::  (If "blockhash" is no longer a part of the main chain, transactions from the fork point onward are included.
        ::  (Additionally, if include-removed is set, transactions affecting the wallet which were removed are returned in the "removed" array.
        ::
        ::  (Arguments:
        ::  (1. blockhash               (string, optional) If set, the block hash to list transactions since, otherwise list all transactions.
        ::  (2. target-confirmations    (numeric, optional, default=1) Return the nth block hash from the main chain. e.g. 1 would mean the best block hash. Note: this is not used as a filter, but only affects [lastblock] in the return value
        ::  (3. include-watch-only       (boolean, optional, default=false) Include transactions to watch-only addresses (see 'importaddress')
        ::  (4. include-removed         (boolean, optional, default=true) Show transactions that were removed due to a reorg in the "removed" array
        ::                            (not guaranteed to work on pruned nodes)
        ::
        $:  %lists-in-ceblock
            blockhash=(unit @t)
            target-confirmations=(unit @ud)
            include-watch-only=(unit ?)
            include-removed=(unit ?)
        ==
        ::  If a label name is provided, this will return only incoming transactions paying to addresses with the specified label.
        ::
        ::  (Returns up to 'count' most recent transactions skipping the first 'from' transactions.
        ::
        ::  (Arguments:
        ::  (1. label                (string, optional) If set, should be a valid label name to return only incoming transactions
        ::                         with the specified label, or "*" to disable filtering and return all transactions.
        ::  (2. count                (numeric, optional, default=10) The number of transactions to return
        ::  (3. skip                 (numeric, optional, default=0) The number of transactions to skip
        ::  (4. include-watch-only    (boolean, optional, default=false) Include transactions to watch-only addresses (see 'importaddress')
        ::
        $:  %list-transactions
            label=(unit @t)
            count=(unit @ud)
            skip=(unit @ud)
            include-watch-only=(unit ?)
        ==
        ::  Returns array of unspent transaction outputs
        ::  (with between minconf and maxconf (inclusive) confirmations.
        ::  (Optionally filter to only include txouts paid to specified addresses.
        ::
        ::  (Arguments:
        ::  (1. minconf                            (numeric, optional, default=1) The minimum confirmations to filter
        ::  (2. maxconf                            (numeric, optional, default=9999999) The maximum confirmations to filter
        ::  (3. addresses                          (json array, optional, default=empty array) A json array of bitcoin addresses to filter
        ::      [
        ::        "address",                     (string) bitcoin address
        ::        ...
        ::      ]
        ::  (4. include-unsafe                     (boolean, optional, default=true) Include outputs that are not safe to spend
        ::                                       See description of "safe" attribute below.
        ::  (5. query-options                      (json object, optional) JSON with query options
        ::      {
        ::        "minimumAmount": amount,       (numeric or string, optional, default=0) Minimum value of each UTXO in BTC
        ::        "maximumAmount": amount,       (numeric or string, optional, default=unlimited) Maximum value of each UTXO in BTC
        ::        "maximumCount": n,             (numeric, optional, default=unlimited) Maximum number of UTXOs
        ::        "minimumSumAmount": amount,    (numeric or string, optional, default=unlimited) Minimum sum value of all UTXOs in BTC
        ::      }
        ::
        $:  %list-unspent
            minconf=(unit @t)
            maxconf=(unit @ud)
            addresses=(unit (list @t))
            include-unsafe=(unit ?)
            $=  query-options  %-  unit
            $:  minimum-amount=(unit @t)
                maximum-amount=(unit @t)
                maximum-count=(unit @t)
                minimum-sum-amount=(unit @t)
            ==
        ==
        ::  Returns a list of wallets in the wallet directory.
        ::
        [%list-wallet-dir ~]
        ::  Returns a list of currently loaded wallets.
        ::  (For full information on the wallet, use "getwalletinfo"
        ::
        [%list-wallets ~]
        ::  Loads a wallet from a wallet file or directory.
        ::  (Note that all wallet command-line options used when starting bitcoind will be
        ::  (applied to the new wallet (eg -zapwallettxes, upgradewallet, rescan, etc).
        ::
        ::  (Arguments:prev-txs
        ::  (1. filename    (string, required) The wallet directory or .dat file.
        ::
        [%load-wallet filename=@t]
        ::  Updates list of temporarily unspendable outputs.
        ::  (Temporarily lock (unlock=false) or unlock (unlock=true) specified transaction outputs.
        ::  (If no transaction outputs are specified when unlocking then all current locked transaction outputs are unlocked.
        ::  (A locked transaction output will not be chosen by automatic coin selection, when spending bitcoins.
        ::  (Locks are stored in memory only. Nodes start with zero locked outputs, and the locked output list
        ::  (is always cleared (by virtue of process exit) when a node stops or fails.
        ::  (Also see the listunspent call
        ::
        ::  (Arguments:
        ::  (1. unlock                  (boolean, required) Whether to unlock (true) or lock (false) the specified transactions
        ::  (2. transactions            (json array, optional, default=empty array) A json array of objects. Each object the txid (string) vout (numeric).
        ::      [
        ::        {                   (json object)
        ::          "txid": "hex",    (string, required) The transaction id
        ::          "vout": n,        (numeric, required) The output number
        ::        },
        ::        ...
        ::      ]
        ::
        [%lock-unspent unlock=? transactions=(unit (list [txid=@t vout=@ud]))]
        ::  Deletes the specified transaction from the wallet. Meant for use with pruned wallets and as a companion to importprunedfunds. This will affect wallet balances.
        ::
        ::  (Arguments:
        ::  (1. txid    (string, required) The hex-encoded id of the transaction you are deleting
        ::
        [%remove-pruned-funds txid=@t]
        ::  Rescan the local blockchain for wallet related transactions.
        ::
        ::  (Arguments:
        ::  (1. start-height    (numeric, optional, default=0) block height where the rescan should start
        ::  (2. stop-height     (numeric, optional) the last block height that should be scanned. If none is provided it will rescan up to the tip at return time of this call.
        ::
        [%rescan-blockchain start-height=(unit @ud) stop-height=(unit @ud)]
        ::  Send multiple times. Amounts are double-precision floating point numbers.
        ::
        ::  (Arguments:
        ::  (1. dummy                     (string, required) Must be set to "" for backwards compatibility.
        ::  (2. amounts                   (json object, required) A json object with addresses and amounts
        ::      {
        ::        "address": amount,    (numeric or string, required) The bitcoin address is the key, the numeric amount (can be string) in BTC is the value
        ::      }
        ::  (3. minconf                   (numeric, optional, default=1) Only use the balance confirmed at least this many times.
        ::  (4. comment                   (string, optional) A comment
        ::  (5. subtract-fee-from           (json array, optional) A json array with addresses.
        ::                              The fee will be equally deducted from the amount of each selected address.
        ::                              Those recipients will receive less bitcoins than you enter in their corresponding amount field.
        ::                              If no addresses are specified here, the sender pays the fee.
        ::      [
        ::        "address",            (string) Subtract fee from this address
        ::        ...
        ::      ]
        ::  (6. replaceable               (boolean, optional, default=fallback to wallet's default) Allow this transaction to be replaced by a transaction with higher fees via BIP 125
        ::  (7. conf-target               (numeric, optional, default=fallback to wallet's default) Confirmation target (in blocks)
        ::  (8. estimate-mode             (string, optional, default=UNSET) The fee estimate mode, must be one of:
        ::                              "UNSET"
        ::                              "ECONOMICAL"
        ::                              "CONSERVATIVE"
        ::
        $:  %send-many
            dummy=%''
            amounts=(list [address=@t amount=@t])
            minconf=(unit @ud)
            comment=(unit @t)
            subtract-fee-from=(unit (list address))
            conf-target=(unit @ud)
            estimate-mode=(unit @t)
        ==
        ::  Send an amount to a given address.
        ::
        ::  (Arguments:
        ::  (1. address                  (string, required) The bitcoin address to send to.
        ::  (2. amount                   (numeric or string, required) The amount in BTC to send. eg 0.1
        ::  (3. comment                  (string, optional) A comment used to store what the transaction is for.
        ::                             This is not part of the transaction, just kept in your wallet.
        ::  (4. comment-to               (string, optional) A comment to store the name of the person or organization
        ::                             to which you're sending the transaction. This is not part of the
        ::                             transaction, just kept in your wallet.
        ::  (5. subtract-fee-from    (boolean, optional, default=false) The fee will be deducted from the amount being sent.
        ::                             The recipient will receive less bitcoins than you enter in the amount field.
        ::  (6. replaceable              (boolean, optional, default=fallback to wallet's default) Allow this transaction to be replaced by a transaction with higher fees via BIP 125
        ::  (7. conf-target              (numeric, optional, default=fallback to wallet's default) Confirmation target (in blocks)
        ::  (8. estimate-mode            (string, optional, default=UNSET) The fee estimate mode, must be one of:
        ::                             "UNSET"
        ::                             "ECONOMICAL"
        ::                             "CONSERVATIVE"
        ::
        $:  %send-to-address
            address=@t
            amount=@t
            comment=(unit @t)
            comment-to=(unit @t)
            subtract-fee-from=(unit (list address))
            replaceable=(unit ?)
            conf-target=(unit @ud)
            estimate-mode=(unit @t)
        ==
        ::  Set or generate a new HD wallet seed. Non-HD wallets will not be upgraded to being a HD wallet. Wallets that are already
        ::  (HD will have a new HD seed set so that new keys added to the keypool will be derived from this new seed.
        ::
        ::  (Note that you will need to MAKE A NEW BACKUP of your wallet after setting the HD wallet seed.
        ::
        ::  (Arguments:
        ::  (1. newkeypool    (boolean, optional, default=true) Whether to flush old unused addresses, including change addresses, from the keypool and regenerate it.
        ::                  If true, the next address from getnewaddress and change address from getrawchangeaddress will be from this new seed.
        ::                  If false, addresses (including change addresses if the wallet already had HD Chain Split enabled) from the existing
        ::                  keypool will be used until it has been depleted.
        ::  (2. seed          (string, optional, default=random seed) The WIF private key to use as the new HD seed.
        ::                  The seed value can be retrieved using the dumpwallet command. It is the private key marked hdseed=1
        ::
        [%set-hd-seed ~]
        ::  Sets the label associated with the given address.
        ::
        ::  (Arguments:
        ::  (1. address    (string, required) The bitcoin address to be associated with a label.
        ::  (2. label      (string, required) The label to assign to the address.
        ::
        [%set-label address=@t label=@t]
        ::  Set the transaction fee per kB for this wallet. Overrides the global -paytxfee command line parameter.
        ::
        ::  (Arguments:
        ::  (1. amount    (numeric or string, required) The transaction fee in BTC/kB
        ::
        [%set-tx-fee amount=@t]
        ::  Sign a message with the private key of an address
        ::
        ::  (Arguments:
        ::  (1. address    (string, required) The bitcoin address to use for the private key.
        ::  (2. message    (string, required) The message to create a signature of.
        ::
        ::  (Result:
        :: "signature"          (string) The signature of the message encoded in base 64
        ::
        [%sign-message address=@t message=@t]
        ::  Sign inputs for raw transaction (serialized, hex-encoded).
        ::  (The second optional argument (may be null) is an array of previous transaction outputs that
        ::  (this transaction depends on but may not yet be in the block chain.
        ::
        ::  (Arguments:
        ::  (1. hexstring                        (string, required) The transaction hex string
        ::  (2. prevtxs                          (json array, optional) A json array of previous dependent transaction outputs
        ::      [
        ::        {                            (json object)
        ::          "txid": "hex",             (string, required) The transaction id
        ::          "vout": n,                 (numeric, required) The output number
        ::          "scriptPubKey": "hex",     (string, required) script key
        ::          "redeemScript": "hex",     (string) (required for P2SH) redeem script
        ::          "witnessScript": "hex",    (string) (required for P2WSH or P2SH-P2WSH) witness script
        ::          "amount": amount,          (numeric or string, required) The amount spent
        ::        },
        ::        ...
        ::      ]
        ::  (3. sighashtype                      (string, optional, default=ALL) The signature hash type. Must be one of
        ::                                     "ALL"
        ::                                     "NONE"
        ::                                     "SINGLE"
        ::                                     "ALL|ANYONECANPAY"
        ::                                     "NONE|ANYONECANPAY"
        ::                                     "SINGLE|ANYONECANPAY"
        ::
        $:  %sign-raw-transaction-with-wallet
           hex-string=@t
           prev-txs=(unit (list tx))
           =sig-hash-type
        ==
        ::  Unloads the wallet referenced by the request endpoint otherwise unloads the wallet specified in the argument.
        ::  (Specifying the wallet name on a wallet endpoint is invalid.
        ::  (Arguments:
        ::  (1. wallet-name    (string, optional, default=the wallet name from the RPC request) The name of the wallet to unload.
        ::
        [%unload-wallet wallet-name=(unit @t)]
        ::  Creates and funds a transaction in the Partially Signed Transaction format. Inputs will be added if supplied inputs are not enough
        ::  (Implements the Creator and Updater roles.
        ::
        ::  (Arguments:
        ::  (1. inputs                             (json array, required) A json array of json objects
        ::      [
        ::        {                              (json object)
        ::          "txid": "hex",               (string, required) The transaction id
        ::          "vout": n,                   (numeric, required) The output number
        ::          "sequence": n,               (numeric, required) The sequence number
        ::        },
        ::        ...
        ::      ]
        ::  (2. outputs                            (json array, required) a json array with outputs (key-value pairs), where none of the keys are duplicated.
        ::                                       That is, each address can only appear once and there can only be one 'data' object.
        ::                                       For compatibility reasons, a dictionary, which holds the key-value pairs directly, is also
        ::                                       accepted as second parameter.
        ::      [
        ::        {                              (json object)
        ::          "address": amount,           (numeric or string, required) A key-value pair. The key (string) is the bitcoin address, the value (float or string) is the amount in BTC
        ::        },
        ::        {                              (json object)
        ::          "data": "hex",               (string, required) A key-value pair. The key must be "data", the value is hex-encoded data
        ::        },
        ::        ...
        ::      ]
        ::  (3. locktime                           (numeric, optional, default=0) Raw locktime. Non-0 value also locktime-activates inputs
        ::  (4. options                            (json object, optional)
        ::      {
        ::        "changeAddress": "hex",        (string, optional, default=pool address) The bitcoin address to receive the change
        ::        "changePosition": n,           (numeric, optional, default=random) The index of the change output
        ::        "change-type": "str",          (string, optional, default=set by -changetype) The output type to use. Only valid if changeAddress is not specified. Options are "legacy", "p2sh-segwit", and "bech32".
        ::        "includeWatching": bool,       (boolean, optional, default=false) Also select inputs which are watch only
        ::        "lockUnspents": bool,          (boolean, optional, default=false) Lock selected unspent outputs
        ::        "feeRate": amount,             (numeric or string, optional, default=not set: makes wallet determine the fee) Set a specific fee rate in BTC/kB
        ::        "subtractFeeFromOutputs": [    (json array, optional, default=empty array) A json array of integers.
        ::                                       The fee will be equally deducted from the amount of each specified output.
        ::                                       Those recipients will receive less bitcoins than you enter in their corresponding amount field.
        ::                                       If no outputs are specified here, the sender pays the fee.
        ::          vout-index,                  (numeric) The zero-based output index, before a change output is added.
        ::          ...
        ::        ],
        ::        "replaceable": bool,           (boolean, optional, default=false) Marks this transaction as BIP125 replaceable.
        ::                                       Allows this transaction to be replaced by a transaction with higher fees
        ::        "conf-target": n,              (numeric, optional, default=Fallback to wallet's confirmation target) Confirmation target (in blocks)
        ::        "estimate-mode": "str",        (string, optional, default=UNSET) The fee estimate mode, must be one of:
        ::                                       "UNSET"
        ::                                       "ECONOMICAL"
        ::                                       "CONSERVATIVE"
        ::      }
        ::  (5. bip32derivs                        (boolean, optional, default=false) If true, includes the BIP 32 derivation paths for public keys if we know them
        ::
        ::  (Result:
        :: {
                ::      "psbt": "value",        (string)  The resulting raw transaction (base64-encoded string)
                ::      "fee":       n,         (numeric) Fee in BTC the resulting transaction pays
                ::      "changepos": n          (numeric) The position of the added change output, or -1
        :: }
        ::
        $:  %wallet-create-fundedpsbt
            inputs=(list tx-short)
            ::  FIXME:
            ::  list of addressess and JUST one "data" key?
            ::
            outputs=(list (pair @t ?(@t @ud)))
            locktime=(unit @ud)
            $=  options  %-  unit
            $:  change-address=(unit @t)
                change-position=(unit @ud)
                change-type=(unit ?(%legacy %p2sh-segwit %bech32))
                include-watching=(unit ?)
                lock-unspents=(unit ?)
                fee-rate=(unit @t)
                subtract-fee-from-outputs=(unit (list @ud))
                replaceable=(unit ?)
                conf-target=(unit @t)
                =estimate-mode
            ==
            bip32derivs=(unit ?)
        ==
        ::  Removes the wallet encryption key from memory, locking the wallet.
        ::  (After calling this method, you will need to call walletpassphrase again
        ::  (before being able to call any methods which require the wallet to be unlocked.
        ::
        [%wallet-lock ~]
        ::  Stores the wallet decryption key in memory for 'timeout' seconds.
        ::  (This is needed prior to performing transactions related to private keys such as sending bitcoins
        ::
        ::  (Note:
        ::  (Issuing the walletpassphrase command while the wallet is already unlocked will set a new unlock
        ::  (time that overrides the old one.
        ::
        ::  (Arguments:
        ::  (1. passphrase    (string, required) The wallet passphrase
        ::  (2. timeout       (numeric, required) The time to keep the decryption key in seconds; capped at 100000000 (~3 years).
        ::
        [%wallet-passphrase passphrase=@t timeout=@ud]
        ::  Changes the wallet passphrase from 'oldpassphrase' to 'newpassphrase'.
        ::
        ::  (Arguments:
        ::  (1. old-passphrase    (string, required) The current passphrase
        ::  (2. new-passphrase    (string, required) The new passphrase
        ::
        [%wallet-passphrase-change old-passphrase=(unit @t) new-passphrase=(unit @t)]
        ::  Update a PSBT with input information from our wallet and then sign inputs
        ::  (that we can sign for.
        ::
        ::  (Arguments:
        ::  (1. psbt           (string, required) The transaction base64 string
        ::  (2. sign           (boolean, optional, default=true) Also sign the transaction when updating
        ::  (3. sighashtype    (string, optional, default=ALL) The signature hash type to sign with if not specified by the PSBT. Must be one of
        ::                   "ALL"
        ::                   "NONE"
        ::                   "SINGLE"
        ::                   "ALL|ANYONECANPAY"
        ::                   "NONE|ANYONECANPAY"
        ::                   "SINGLE|ANYONECANPAY"
        ::  (4. bip32derivs    (boolean, optional, default=false) If true, includes the BIP 32 derivation paths for public keys if we know them
        ::
        $:  %wallet-process-psbt
            psbt=@t
            sign=(unit ?)
            =sig-hash-type
            bip32derivs=(unit ?)
        ==
    ::  ZMQ management
    ::
        ::  Returns information about the active ZeroMQ notifications.
        ::
        [%get-zmq-notifications ~]
       ::
    ==
  ::
  +$  response
    $%  ::  Others
        ::
        [%generate blocks=(list blockhash)]
        [%get-block-count count=@ud]
        ::  Wallet
        [%abandon-transaction ~]
        [%abort-rescan ~]
        ::  TODO:
        ::
        ::  [%add-multisig-address ~]
        [%backup-wallet ~]
        ::
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
        [%bump-fee txid=@t orig-fee=@t fee=@t errors=(list @t)]
        ::
        ::  %create-wallet:
        ::
        ::  Result:
        ::      {
        ::        "name" :    <wallet_name>,        (string) The wallet name if created successfully. If the wallet was created using a full path, the wallet_name will be the full path.
        ::        "warning" : <warning>,            (string) Warning message if wallet was not loaded cleanly.
        ::      }
        ::
        [%create-wallet name=@t warning=@t]
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
        $:  %get-addresses-by-label
            $=  addresses  %-  list
            [address=@t purpose=?(%'send' %'receive')]
        ==
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
        $:  %get-address-info
            address=@t
            script-pubkey=@t
            is-mine=?
            is-watchonly=?
            solvable=?
            desc=(unit @t)
            is-script=?
            is-change=?
            is-witness=?
            witness-version=@ud
            witness-program=(unit @t)
            script=(unit @t)
            hex=(unit @t)
            pubkeys=(unit (list @t))
            sigs-required=(unit @ud)
            pubkey=(unit @t)
            $=  embedded
            $:  script-pubkey=@t
               solvable=?
               desc=(unit @t)
               is-script=?
               is-change=?
               is-witness=?
               witness-version=@ud
               witness-program=(unit @t)
               script=(unit @t)
               hex=(unit @t)
               pubkeys=(unit (list @t))
               sigs-required=(unit @ud)
               pubkey=(unit @t)
               is-compressed=?
               label=@t
               hd-master-finger-print=(unit @t)
               labels=(list [label-name=@t purpose=@t])
            ==
            is-compressed=?
            label=@t
            timestamp=(unit @da)
            hd-key-path=(unit @t)
            hd-seed-id=(unit @t)
            hd-master-finger-print=(unit @t)
            labels=(list [label-name=@t purpose=@t])
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
        [%get-new-address address=@t]
        ::  %get-raw-change-address
        ::  "address"    (string) The new bitcoin address
        ::
        [%get-raw-change-address address=@t]
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
        $:  %get-transaction
            amount=@t
            fee=@t
            confirmations=@t
            blockhash=@t
            blockindex=@ud
            blocktime=@t
            txid=@t
            time=@t
            time-received=@t
            bip125-replaceable=(unit ?)
            $=  details  %-  list
            $:  address=@t
                =category
                amount=@t
                label=@t
                vout=@ud
                fee=@t
                abandoned=?
            ==
            hex=@t
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
            wallet-version=@t
            balance=@t
            unconfirmed-balance=@t
            immature-balance=@t
            tx-count=@t
            key-pool-oldest=@t
            key-pool-size=@t
            key-pool-size-hd-internal=@t
            unlocked-until=@t
            pay-tx-fee=@t
            hd-seed-id=(unit @t)
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
        [%import-multi ~]
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
           (list [address=@t amount=@t label=(unit @t)])
        ==
        ::
        [%list-labels labels=(list @t)]
        ::
        [%list-lock-unspent outputs=(list [txid=@t vout=@ud])]
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
        $:  %list-received-by-address
            involves-watch-only=(unit %&)
            address=@t
            amount=@t
            confirmations=@ud
            label=@t
            txids=(list @t)
        ==
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
        $:  %list-received-by-label
            involves-watch-only=(unit %&)
            amount=@t
            confirmations=@ud
            label=@t
        ==
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
            transactions=tx-response
            removed=(unit tx-response)
            lastblock=@t
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
        $:  %list-transactions
            address=@t
            =category
            amount=@t
            label=@t
            vout=@ud
            fee=@t
            confirmations=@t
            trusted=?
            blockhash=@t
            blockindex=@ud
            blocktime=@t
            txid=@t
            time=@t
            time-received=@t
            comment=@t
            bip125-replaceable=(unit ?)
            abandoned=?
        ==
        ::
        :: %list-unspent
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
        $:  %list-unspent  %-  list
            $:  txid=@t
                vout=@t
                address=@t
                label=@t
                scrip-pub-key=@t
                amount=@t
                confirmations=@ud
                redeem-script=@t
                witness-script=@t
                spendable=?
                solvable=?
                desc=@t
                safe=?
        ==  ==
        ::
        :: %list-wallet-dir:
        ::
        :: Response:
        ::    {  "wallets":
        ::       [  {"name":"test-wallet-2"}
        ::          ...
        ::       ]
        ::    }
        [%list-wallet-dir wallets=(list @t)]
        ::
        :: %list-wallets
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
        [%send-many txid=@t]
        ::
        ::  Result:
        :: "txid"                   (string) The transaction id for the send. Only 1 transaction is created regardless of
        ::
        ::
        [%send-to-address txid=@t]
        ::
        [%set-hd-seed ~]
        ::
        [%set-label ~]
        ::
        [%set-tx-fee ?]
        ::
        ::
        ::  Result:
        :: "signature"          (string) The signature of the message encoded in base 64
        ::
        [%sign-message signature=@t]
        ::
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
        $:  %sign-raw-transaction-with-wallet  %-  list
            $:  hex=@t
                complete=?
                $=  errors  %-  list
                $:  txid=@t
                    vout=@ud
                    script-sig=@t
                    sequence=@ud
                    error=@t
        ==  ==  ==
        ::
        [%unload-wallet ~]
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
        ::
        ::
        ::  ZMQ
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
                address=@t
                hwm=@t
        ==  ==
    ==
  --
--
