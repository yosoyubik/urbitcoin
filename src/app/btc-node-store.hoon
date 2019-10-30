::  btc-node-store: data store for state received from a bitcoin full node
::
/-  *btc-node-store
/+  *btc-node-json
::
|%
+$  move  [bone card]
::
+$  card
  $%  [%quit ~]
  ==
::
+$  state
  $%  [%0 state-zero]
  ==
::
+$  state-zero
  $:  =wallets
  ==
--
::
|_  [bol=bowl:gall state]
::
++  this  .
::
++  prep
  |=  old=(unit state)
  ^-  (quip move _this)
  ?~  old
    [~ this]
  [~ this(+<+ u.old)]
::
++  poke-btc-node-store-action
  |=  action=btc-node-store-action
  ^-  (quip move _this)
  ?.  =(src.bol our.bol)
    [~ this]
  (handle-add action)
::
++  handle-add
  |=  action=btc-node-store-action
  ^-  (quip move _this)
  ?+    -.action  ~|  [%unsupported-action -.action]  !!
  ::
      %add-wallet
    ?:  (~(has by wallets) name.action)
      ~&  "This wallet already exists"
      [~ this]
    :-  ~
    =/  new-wallet=wallet  [name.action warning.action ~]
    ~&  "Wallet {<name.action>} added succesfully"
    %=    this
      wallets  (~(put by wallets) [name.action new-wallet])
    ==
  ::
      %list-wallets
    ~&  [%local-wallets ~(tap by wallets)]
    ::  TODO: connect to %sole to print to console
    [~ this]
  ==
::
--
