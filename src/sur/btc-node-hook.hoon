|%
::  %address: base58check encoded public key (20 bytes)
::
++  address  @uc
++  blockhash  @ux
::  Helper types
::
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
+$  category  ?(%send %receive %generate %immature %orphan)
::
+$  purpose  ?(%send %receive)
::
+$  address-type  ?(%legacy %p2sh-segwit %bech32)
::
+$  bip125-replaceable  ?(%yes %no %unknown)
::
+$  bip32-derivs  %-  unit  %-  list
  $:  pubkey=@ux
      $:  master-fingerprint=@t
          path=@t
  ==  ==
::
::  redeem/witness script
::
+$  script
  $:  asm=@t
      hex=@ux
      type=@t
  ==
::
+$  script-pubkey
  $:  asm=@t
      hex=@ux
      type=@t
      =address
  ==
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
+$  partially-signed-transaction
  $:  inputs=(list input)
      outputs=output
      locktime=(unit @ud)
      replaceable=(unit ?)
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
+$  btc-node-hook-action  request:btc-rpc
::
++  btc-rpc
  |%
  +$  request
    $%
    ::  Control
    ::
        [%help command=(unit @t)]
    ::  Generating
    ::
        [%generate blocks=@ud max-tries=(unit @ud)]
        [%get-blockchain-info ~]
    ::  Blockchain
    ::
        [%get-block-count ~]
    ::  Raw Transactions
    ::
        :: %analyzepsbt: Analyzes and provides information about the current status of a PSBT and its inputs
        ::
        :: Arguments:
        :: 1. psbt    (string, required) A base64 string of a PSBT
        ::
        [%analyze-psbt psbt=@t]
        :: %combinepsbt: Combine multiple partially signed Bitcoin transactions into one transaction.
        :: Implements the Combiner role.
        ::
        :: Arguments:
        :: 1. txs            (json array, required) A json array of base64 strings of partially signed transactions
        ::      [
        ::        "psbt",    (string) A base64 string of a PSBT
        ::        ...
        ::      ]
        ::
        [%combine-psbt txs=(list @t)]
        :: %combinerawtransaction:Combine multiple partially signed transactions into one transaction.
        :: The combined transaction may be another partially signed transaction or a
        :: fully signed transaction.
        :: Arguments:
        :: 1. txs                 (json array, required) A json array of hex strings of partially signed transactions
        ::      [
        ::        "hexstring",    (string) A transaction hash
        ::        ...
        ::      ]
        ::
        ::
        [%combine-raw-transaction txs=(list @ux)]
        :: %converttopsbt: Converts a network serialized transaction to a PSBT. This should be used only with createrawtransaction and fundrawtransaction
        :: createpsbt and walletcreatefundedpsbt should be used for new applications.
        ::
        :: Arguments:
        :: 1. hexstring        (string, required) The hex string of a raw transaction
        :: 2. permitsigdata    (boolean, optional, default=false) If true, any signatures in the input will be discarded and conversion.
        ::                     will continue. If false, RPC will fail if any signatures are present.
        :: 3. iswitness        (boolean, optional, default=depends on heuristic tests) Whether the transaction hex is a serialized witness transaction.
        ::                     If iswitness is not present, heuristic tests will be used in decoding. If true, only witness deserializaion
        ::                     will be tried. If false, only non-witness deserialization will be tried. Only has an effect if
        ::                     permitsigdata is true.
        ::
        $:  %convert-to-psbt
            hex-string=@ux
            permit-sig-data=(unit ?)
            is-witness=(unit ?)
        ==
        :: %createpsbt: Creates a transaction in the Partially Signed Transaction format.
        :: Implements the Creator role.
        ::
        :: Arguments:
        :: 1. inputs                      (json array, required) A json array of json objects
        ::      [
        ::        {                       (json object)
        ::          "txid": "hex",        (string, required) The transaction id
        ::          "vout": n,            (numeric, required) The output number
        ::          "sequence": n,        (numeric, optional, default=depends on the value of the 'replaceable' and 'locktime' arguments) The sequence number
        ::        },
        ::        ...
        ::      ]
        :: 2. outputs                     (json array, required) a json array with outputs (key-value pairs), where none of the keys are duplicated.
        ::                                That is, each address can only appear once and there can only be one 'data' object.
        ::                                For compatibility reasons, a dictionary, which holds the key-value pairs directly, is also
        ::                                accepted as second parameter.
        ::      [
        ::        {                       (json object)
        ::          "address": amount,    (numeric or string, required) A key-value pair. The key (string) is the bitcoin address, the value (float or string) is the amount in BTC
        ::        },
        ::        {                       (json object)
        ::          "data": "hex",        (string, required) A key-value pair. The key must be "data", the value is hex-encoded data
        ::        },
        ::        ...
        ::      ]
        :: 3. locktime                    (numeric, optional, default=0) Raw locktime. Non-0 value also locktime-activates inputs
        :: 4. replaceable                 (boolean, optional, default=false) Marks this transaction as BIP125 replaceable.
        ::                                Allows this transaction to be replaced by a transaction with higher fees. If provided, it is an error if explicit sequence numbers are incompatible.
        ::
        [%create-psbt partially-signed-transaction]
        :: %createrawtransaction: Create a transaction spending the given inputs and creating new outputs.
        :: Outputs can be addresses or data.
        :: Returns hex-encoded raw transaction.
        :: Note that the transaction's inputs are not signed, and
        :: it is not stored in the wallet or transmitted to the network.
        ::
        :: Arguments:
        :: 1. inputs                      (json array, required) A json array of json objects
        ::      [
        ::        {                       (json object)
        ::          "txid": "hex",        (string, required) The transaction id
        ::          "vout": n,            (numeric, required) The output number
        ::          "sequence": n,        (numeric, optional, default=depends on the value of the 'replaceable' and 'locktime' arguments) The sequence number
        ::        },
        ::        ...
        ::      ]
        :: 2. outputs                     (json array, required) a json array with outputs (key-value pairs), where none of the keys are duplicated.
        ::                                That is, each address can only appear once and there can only be one 'data' object.
        ::                                For compatibility reasons, a dictionary, which holds the key-value pairs directly, is also
        ::                                accepted as second parameter.
        ::      [
        ::        {                       (json object)
        ::          "address": amount,    (numeric or string, required) A key-value pair. The key (string) is the bitcoin address, the value (float or string) is the amount in BTC
        ::        },
        ::        {                       (json object)
        ::          "data": "hex",        (string, required) A key-value pair. The key must be "data", the value is hex-encoded data
        ::        },
        ::        ...
        ::      ]
        :: 3. locktime                    (numeric, optional, default=0) Raw locktime. Non-0 value also locktime-activates inputs
        :: 4. replaceable                 (boolean, optional, default=false) Marks this transaction as BIP125-replaceable.
        ::                                Allows this transaction to be replaced by a transaction with higher fees. If provided, it is an error if explicit sequence numbers are incompatible.
        ::
        ::
        [%create-raw-transaction partially-signed-transaction]
        :: %decodepsbt: Return a JSON object representing the serialized, base64-encoded partially signed Bitcoin transaction.
        ::
        :: Arguments:
        :: 1. psbt    (string, required) The PSBT base64 string
        ::
        [%decode-psbt psbt=@t]
        :: %decoderawtransaction: Return a JSON object representing the serialized, hex-encoded transaction.
        ::
        :: Arguments:
        :: 1. hexstring    (string, required) The transaction hex string
        :: 2. iswitness    (boolean, optional, default=depends on heuristic tests) Whether the transaction hex is a serialized witness transaction
        ::                 If iswitness is not present, heuristic tests will be used in decoding
        ::
        [%decode-raw-transaction hex-string=@ux is-witness=(unit ?)]
        :: %decodescript: Decode a hex-encoded script.
        ::
        :: Arguments:
        :: 1. hexstring    (string, required) the hex-encoded script
        ::
        [%decode-script hex-string=@ux]
        :: %finalizepsbt: Finalize the inputs of a PSBT. If the transaction is fully signed, it will produce a
        :: network serialized transaction which can be broadcast with sendrawtransaction. Otherwise a PSBT will be
        :: created which has the final_scriptSig and final_scriptWitness fields filled for inputs that are complete.
        :: Implements the Finalizer and Extractor roles.
        ::
        :: Arguments:
        :: 1. psbt       (string, required) A base64 string of a PSBT
        :: 2. extract    (boolean, optional, default=true) If true and the transaction is complete,
        ::               extract and return the complete transaction in normal network serialization instead of the PSBT.
        ::
        ::
        [%finalize-psbt psbt=@t extract=(unit ?)]
        :: %fundrawtransaction: Add inputs to a transaction until it has enough in value to meet its out value.
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
        :: Arguments:
        :: 1. hexstring                          (string, required) The hex string of the raw transaction
        :: 2. options                            (json object, optional) for backward compatibility: passing in a true instead of an object will result in {"includeWatching":true}
        ::      {
        ::        "changeAddress": "str",        (string, optional, default=pool address) The bitcoin address to receive the change
        ::        "changePosition": n,           (numeric, optional, default=random) The index of the change output
        ::        "change_type": "str",          (string, optional, default=set by -changetype) The output type to use. Only valid if changeAddress is not specified. Options are "legacy", "p2sh-segwit", and "bech32".
        ::        "includeWatching": bool,       (boolean, optional, default=false) Also select inputs which are watch only
        ::        "lockUnspents": bool,          (boolean, optional, default=false) Lock selected unspent outputs
        ::        "feeRate": amount,             (numeric or string, optional, default=not set: makes wallet determine the fee) Set a specific fee rate in BTC/kB
        ::        "subtractFeeFromOutputs": [    (json array, optional, default=empty array) A json array of integers.
        ::                                       The fee will be equally deducted from the amount of each specified output.
        ::                                       Those recipients will receive less bitcoins than you enter in their corresponding amount field.
        ::                                       If no outputs are specified here, the sender pays the fee.
        ::          vout_index,                  (numeric) The zero-based output index, before a change output is added.
        ::          ...
        ::        ],
        ::        "replaceable": bool,           (boolean, optional, default=fallback to wallet's default) Marks this transaction as BIP125 replaceable.
        ::                                       Allows this transaction to be replaced by a transaction with higher fees
        ::        "conf_target": n,              (numeric, optional, default=fallback to wallet's default) Confirmation target (in blocks)
        ::        "estimate_mode": "str",        (string, optional, default=UNSET) The fee estimate mode, must be one of:
        ::                                       "UNSET"
        ::                                       "ECONOMICAL"
        ::                                       "CONSERVATIVE"
        ::      }
        :: 3. iswitness                          (boolean, optional, default=depends on heuristic tests) Whether the transaction hex is a serialized witness transaction
        ::                                       If iswitness is not present, heuristic tests will be used in decoding
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
        :: %getrawtransaction: Return the raw transaction data.
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
        :: Arguments:
        :: 1. txid         (string, required) The transaction id
        :: 2. verbose      (boolean, optional, default=false) If false, return a string, otherwise return a json object
        :: 3. blockhash    (string, optional) The block in which to look for the transaction
        ::
        [%get-raw-transaction txid=@ux verbose=(unit ?) blockhash=(unit @ux)]
        :: %joinpsbts: Joins multiple distinct PSBTs with different inputs and outputs into one PSBT with inputs and outputs from all of the PSBTs
        :: No input in any of the PSBTs can be in more than one of the PSBTs.
        ::
        :: Arguments:
        :: 1. txs            (json array, required) A json array of base64 strings of partially signed transactions
        ::      [
        ::        "psbt",    (string, required) A base64 string of a PSBT
        ::        ...
        ::      ]
        ::
        [%join-psbts txs=(list @t)]
        :: %sendrawtransaction: Submits raw transaction (serialized, hex-encoded) to local node and network.
        ::
        :: Also see createrawtransaction and signrawtransactionwithkey calls.
        ::
        :: Arguments:
        :: 1. hexstring        (string, required) The hex string of the raw transaction
        :: 2. allowhighfees    (boolean, optional, default=false) Allow high fees
        ::
        ::
        [%send-raw-transaction hex-string=@ux allow-high-fees=(unit ?)]
        :: %signrawtransactionwithkey: Sign inputs for raw transaction (serialized, hex-encoded).
        :: The second argument is an array of base58-encoded private
        :: keys that will be the only keys used to sign the transaction.
        :: The third optional argument (may be null) is an array of previous transaction outputs that
        :: this transaction depends on but may not yet be in the block chain.
        ::
        :: Arguments:
        :: 1. hexstring                        (string, required) The transaction hex string
        :: 2. privkeys                         (json array, required) A json array of base58-encoded private keys for signing
        ::      [
        ::        "privatekey",                (string) private key in base58-encoding
        ::        ...
        ::      ]
        :: 3. prevtxs                          (json array, optional) A json array of previous dependent transaction outputs
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
        :: 4. sighashtype                      (string, optional, default=ALL) The signature hash type. Must be one of:
        ::                                     "ALL"
        ::                                     "NONE"
        ::                                     "SINGLE"
        ::                                     "ALL|ANYONECANPAY"
        ::                                     "NONE|ANYONECANPAY"
        ::                                     "SINGLE|ANYONECANPAY"
        ::
        ::
        ::
        $:  %sign-raw-transaction-with-key
            hex-string=@ux
            priv-keys=(list @t)
            prev-txs=(unit (list prev-tx))
            =sig-hash-type
        ==
        :: %testmempoolaccept: Returns result of mempool acceptance tests indicating if raw transaction (serialized, hex-encoded) would be accepted by mempool.
        ::
        :: This checks if the transaction violates the consensus or policy rules.
        ::
        :: See sendrawtransaction call.
        ::
        :: Arguments:
        :: 1. rawtxs           (json array, required) An array of hex strings of raw transactions.
        ::                     Length must be one for now.
        ::      [
        ::        "rawtx",     (string)
        ::        ...
        ::      ]
        :: 2. allowhighfees    (boolean, optional, default=false) Allow high fees
        ::
        [%test-mempool-accept raw-txs=(list @ux) allow-high-fees=(unit ?)]
        :: %utxoupdatepsbt: Updates a PSBT with witness UTXOs retrieved from the UTXO set or the mempool.
        ::
        :: Arguments:
        :: 1. psbt    (string, required) A base64 string of a PSBT
        ::
        [%utxo-update-psbt psbt=@t]
    ::  Util
    ::
        ::  %createmultisig: Creates a multi-signature address with n signature
        ::  of m keys required. It returns a json object with the address and
        ::  redeemScript.
        ::
        ::  Arguments:
        :: 1. nrequired       (numeric, required) The number of required signatures out of the n keys.
        :: 2. keys            (json array, required) A json array of hex-encoded public keys.
        ::      [
        ::        "key",      (string) The hex-encoded public key
        ::        ...
        ::      ]
        :: 3. address_type    (string, optional, default=legacy) The address type to use. Options are "legacy", "p2sh-segwit", and "bech32".
        ::
        ::
        [%create-multi-sig n-required=@ud keys=(list @ux) address-type=(unit address-type)]
        ::  %deriveaddresses: Derives one or more addresses corresponding to an
        ::  output descriptor. Examples of output descriptors are:
        ::  Examples of output descriptors are:
        ::     pkh(<pubkey>)                        P2PKH outputs for the given pubkey
        ::     wpkh(<pubkey>)                       Native segwit P2PKH outputs for the given pubkey
        ::     sh(multi(<n>,<pubkey>,<pubkey>,...)) P2SH-multisig outputs for the given threshold and pubkeys
        ::     raw(<hex script>)                    Outputs whose scriptPubKey equals the specified hex scripts
        ::
        :: In the above, <pubkey> either refers to a fixed public key in hexadecimal notation, or to an xpub/xprv optionally followed by one
        :: or more path elements separated by "/", where "h" represents a hardened child key.
        :: For more information on output descriptors, see the documentation in the doc/descriptors.md file.
        ::
        :: Arguments:
        :: 1. descriptor    (string, required) The descriptor.
        :: 2. range         (numeric or array, optional) If a ranged descriptor is used, this specifies the end or the range (in [begin,end] notation) to derive.
        ::
        ::
        [%derive-addresses descriptor=@t range=(unit ?(@ud [@ud @ud]))]
        ::  %estimatesmartfee: Estimates the approximate fee per kilobyte needed for a transaction to begin
        :: confirmation within conf_target blocks if possible and return the number of blocks
        :: for which the estimate is valid. Uses virtual transaction size as defined
        :: in BIP 141 (witness data is discounted).
        ::
        ::  Arguments:
        :: 1. conf_target      (numeric, required) Confirmation target in blocks (1 - 1008)
        :: 2. estimate_mode    (string, optional, default=CONSERVATIVE) The fee estimate mode.
        ::                     Whether to return a more conservative estimate which also satisfies
        ::                     a longer history. A conservative estimate potentially returns a
        ::                     higher feerate and is more likely to be sufficient for the desired
        ::                     target, but is not as responsive to short term drops in the
        ::                     prevailing fee market.  Must be one of:
        ::                     "UNSET"
        ::                     "ECONOMICAL"
        ::                     "CONSERVATIVE"
        ::
        [%estimate-smart-fee conf-target=@ud =estimate-mode]
        ::  %getdescriptorinfo: Analyses a descriptor.
        ::
        :: Arguments:
        :: 1. descriptor    (string, required) The descriptor.
        ::
        [%get-descriptor-info descriptor=@t]
        ::  %signmessagewithprivkey: Sign a message with the private key of an address
        ::
        :: Arguments:
        :: 1. privkey    (string, required) The private key to sign the message with.
        :: 2. message    (string, required) The message to create a signature of.
        ::
        [%sign-message-with-privkey privkey=@t message=@t]
        ::  %validateaddress: Return information about the given bitcoin address.
        ::
        :: Arguments:
        :: 1. address    (string, required) The bitcoin address to validate
        ::
        [%validate-address =address]
        ::  %verifymessage: Verify a signed message
        ::
        :: Arguments:
        :: 1. address      (string, required) The bitcoin address to use for the signature.
        :: 2. signature    (string, required) The signature provided by the signer in base 64 encoding (see signmessage).
        :: 3. message      (string, required) The message that was signed.
        ::
        ::
        [%verify-message =address signature=@t message=@t]
    ::  Wallet
    ::
        ::  %abandon-transaction: Mark in-wallet transaction as abandoned.
        ::
        ::    %txid: The transaction id
        ::
        [%abandon-transaction txid=@ux]
        ::  %abort-rescan: Stops current wallet rescan triggered by an
        ::  RPC call, e.g. by an importprivkey call.
        ::
        [%abort-rescan ~]
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
        ::
        $:  %add-multisig-address
            n-required=@ud
            keys=(list address)
            label=(unit @t)
            =address-type
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
        ::  Reveals the private key corresponding to 'address'.
        ::  (Then the importprivkey can be used with this output
        ::
        ::  (Arguments:
        ::  (1. address    (string, required) The bitcoin address for the private key
        ::
        [%dump-privkey =address]
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
        [%get-address-info wallet=@t =address]
        ::  Returns the total available balance.
        ::  (The available balance is what the wallet considers currently spendable, and is
        ::  (thus affected by options which limit spendability such as -spendzeroconfchange.
        ::
        ::  (Arguments:
        ::  (1. dummy                (string, optional) Remains for backward compatibility. Must be excluded or set to "*".
        ::  (2. minconf              (numeric, optional, default=0) Only include transactions confirmed at least this many times.
        ::  (3. include-watch-only    (boolean, optional, default=false) Also include balance in watch-only addresses (see 'importaddress')
        ::
        [%get-balance wallet=@t dummy=(unit @t) minconf=(unit @ud) include-watch-only=(unit ?)]
        ::  Returns a new Bitcoin address for receiving payments.
        ::  (If 'label' is specified, it is added to the address book
        ::  (so payments received with the address will be associated with 'label'.
        ::
        ::  (Arguments:
        ::  (1. label           (string, optional, default="") The label name for the address to be linked to. It can also be set to the empty string "" to represent the default label. The label does not need to exist, it will be created if there is no label by the given name.
        ::  (2. address-type    (string, optional, default=set by -addresstype) The address type to use. Options are "legacy", "p2sh-segwit", and "bech32".
        ::
        [%get-new-address label=(unit @t) address-type=(unit address-type)]
        ::  Returns a new Bitcoin address, for receiving change.
        ::  (This is for use with raw transactions, NOT normal use.
        ::
        ::  (Arguments:
        ::  (1. address-type    (string, optional, default=set by -changetype) The address type to use. Options are "legacy", "p2sh-segwit", and "bech32".
        ::
        [%get-raw-change-address address-type=(unit address-type)]
        ::  Returns the total amount received by the given address in transactions with at least minconf confirmations.
        ::
        ::  (Arguments:
        ::  (1. address    (string, required) The bitcoin address for transactions.
        ::  (2. minconf    (numeric, optional, default=1) Only include transactions confirmed at least this many times.
        ::
        [%get-received-by-address =address minconf=@ud]
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
        [%get-transaction txid=@ux include-watch-only=(unit ?)]
        ::  Returns the server's total unconfirmed balance
        ::
        [%get-unconfirmed-balance ~]
        ::  Returns an object containing various wallet state info.
        ::
        ::  %name: does not figure on the spec, but it's necessary if
        ::  multiple wallets exist.
        ::  This is used by the RPC via the option: -rpcwallet=''
        ::
        [%get-wallet-info name=@t]
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
        [%import-address =address label=(unit @t) rescan=(unit ?) p2sh=(unit ?)]
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
        [%import-pubkey pubkey=@ux label=(unit @t) rescan=(unit ?)]
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
        [%list-labels purpose=(unit purpose)]
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
            blockhash=(unit blockhash)
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
        [%lock-unspent unlock=? transactions=(unit (list [txid=@ux vout=@ud]))]
        ::  Deletes the specified transaction from the wallet. Meant for use with pruned wallets and as a companion to importprunedfunds. This will affect wallet balances.
        ::
        ::  (Arguments:
        ::  (1. txid    (string, required) The hex-encoded id of the transaction you are deleting
        ::
        [%remove-pruned-funds txid=@ux]
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
            amounts=(list [=address amount=@t])
            minconf=(unit @ud)
            comment=(unit @t)
            subtract-fee-from=(unit (list address))
            :: subtract-fee-from=(unit (list address))
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
        ::  (5. subtractfeefromamount    (boolean, optional, default=false) The fee will be deducted from the amount being sent.
        ::                             The recipient will receive less bitcoins than you enter in the amount field.
        ::  (6. replaceable              (boolean, optional, default=fallback to wallet's default) Allow this transaction to be replaced by a transaction with higher fees via BIP 125
        ::  (7. conf-target              (numeric, optional, default=fallback to wallet's default) Confirmation target (in blocks)
        ::  (8. estimate-mode            (string, optional, default=UNSET) The fee estimate mode, must be one of:
        ::                             "UNSET"
        ::                             "ECONOMICAL"
        ::                             "CONSERVATIVE"
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
        [%set-label =address label=@t]
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
        [%sign-message =address message=@t]
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
        [%sign-raw-transaction-with-wallet raw-tx]
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
            bip32-derivs=(unit ?)
        ==
    ::  ZMQ management
    ::
        ::  Returns information about the active ZeroMQ notifications.
        ::
        [%get-zmq-notifications ~]
    ==
  ::
  +$  response
    $%
    ::  Generating
    ::
        [%generate blocks=(list blockhash)]
        [%get-block-count count=@ud]
    ::  Raw Transactions
    ::
        :: %analyzepsbt: Analyzes and provides information about the current status of a PSBT and its inputs
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
                $=  missing  %-  list  %-  unit
                $:  pubkeys=(list (unit @ux))
                    signatures=(list (unit @ux))
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
        :: %combinepsbt: Combine multiple partially signed Bitcoin transactions into one transaction.
        :: Implements the Combiner role.
        ::
        :: Result:
        ::   "psbt"          (string) The base64-encoded partially signed transaction
        ::
        [%combine-psbt psbt=@t]
        :: %combinerawtransaction:Combine multiple partially signed transactions into one transaction.
        :: The combined transaction may be another partially signed transaction or a
        :: fully signed transaction.
        ::
        :: Result:
        :: "hex"            (string) The hex-encoded raw transaction with signature(s)
        ::
        [%combine-raw-transaction hex=@ux]
        :: %converttopsbt: Converts a network serialized transaction to a PSBT. This should be used only with createrawtransaction and fundrawtransaction
        :: createpsbt and walletcreatefundedpsbt should be used for new applications.
        ::
        :: Result:
        ::   "psbt"        (string)  The resulting raw transaction (base64-encoded string)
        ::
        [%convert-to-psbt psbt=@t]
        :: %createpsbt: Creates a transaction in the Partially Signed Transaction format.
        :: Implements the Creator role.
        ::
        :: Result:
        ::   "psbt"        (string)  The resulting raw transaction (base64-encoded string)
        ::
        [%create-psbt psbt=@t]
        :: %createrawtransaction: Create a transaction spending the given inputs and creating new outputs.
        :: Outputs can be addresses or data.
        :: Returns hex-encoded raw transaction.
        :: Note that the transaction's inputs are not signed, and
        :: it is not stored in the wallet or transmitted to the network.
        ::
        :: Result:
        :: "transaction"              (string) hex string of the transaction
        ::
        [%create-raw-transaction transaction=@ux]
        :: %decodepsbt: Return a JSON object representing the serialized, base64-encoded partially signed Bitcoin transaction.
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
            unknown=(list [@t @t])
            $=  inputs  %-  list
            $:  non-witness-utxo=(unit [amount=@t =script-pubkey])
                witness-utxo=(unit [amount=@t =script-pubkey])
                $=  partial-signatures  %-  unit  %-  list
                $:  pubkey=@ux
                    signature=@t
                ==
                =sig-hash-type
                redeem-script=(unit script)
                witness-script=(unit script)
                =bip32-derivs
                final-script-sig=(unit [asm=@t hex=@ux])
                final-script-witness=(unit (list @ux))
                unknown=(list [@t @t])
            ==
            $=  outputs
            $:  redeem-script=(unit script)
                witness-script=(unit script)
                =bip32-derivs
                unknown=(list [@t @t])
            ==
            fee=(unit @t)
        ==
        :: %decoderawtransaction: Return a JSON object representing the serialized, hex-encoded transaction.
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
        :: %decodescript: Decode a hex-encoded script.
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
        :: %finalizepsbt: Finalize the inputs of a PSBT. If the transaction is fully signed, it will produce a
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
        :: %fundrawtransaction: Add inputs to a transaction until it has enough in value to meet its out value.
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
        [%fund-raw-transaction hex=@ux fee=@t change-pos=@ud]
        :: %getrawtransaction: Return the raw transaction data.
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
        $:  %get-raw-transaction  $=  data
            $?  @ux
                $:  in-active-chain=?
                    hex=@ux
                    txid=@ux
                    hash=@ux
                    size=@ud
                    vsize=@ud
                    weight=@ud
                    version=@ud
                    locktime=@ud
                    vin=(list vin)
                    vout=(list vout)
                    =blockhash
                    confirmations=@ud
                    blocktime=@ud
                    time=@ud
        ==  ==  ==
        :: %joinpsbts: Joins multiple distinct PSBTs with different inputs and outputs into one PSBT with inputs and outputs from all of the PSBTs
        :: No input in any of the PSBTs can be in more than one of the PSBTs.
        ::
        :: Result:
        ::   "psbt"          (string) The base64-encoded partially signed transaction
        ::
        [%join-psbts psbt=@t]
        :: %sendrawtransaction: Submits raw transaction (serialized, hex-encoded) to local node and network.
        ::
        :: Also see createrawtransaction and signrawtransactionwithkey calls.
        ::
        :: Result:
        :: "hex"             (string) The transaction hash in hex
        ::
        [%send-raw-transaction hex=@ux]
        :: %signrawtransactionwithkey: Sign inputs for raw transaction (serialized, hex-encoded).
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
        [%sign-raw-transaction-with-key ~]
        :: %testmempoolaccept: Returns result of mempool acceptance tests indicating if raw transaction (serialized, hex-encoded) would be accepted by mempool.
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
        [%test-mempool-accept txid=@ux allowed=? reject-reason=(unit @t)]
        :: %utxoupdatepsbt: Updates a PSBT with witness UTXOs retrieved from the UTXO set or the mempool.
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
        $:  %get-addresses-by-label
            $=  addresses  %-  list
            [=address =purpose]
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
        $:  %sign-raw-transaction-with-wallet
            hex=@ux
            complete=?
            $=  errors  %-  list
            $:  txid=@ux
                vout=@ud
                script-sig=@ux
                sequence=@ud
                error=@t
        ==  ==
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
        ==  ==
    ==
  --
--
