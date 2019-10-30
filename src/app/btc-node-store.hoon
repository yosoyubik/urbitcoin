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
  ?+  -.action  ~|  [%unsupported-action -.action]  !!
    %add-wallet     (handle-add +.action)
    %list-wallets   handle-list-wallet
    %update-wallet  (handle-update-wallet +.action)
  ==
::
++  handle-add
  |=  [name=@t warning=(unit @t)]
  ^-  (quip move _this)
  ?:  (~(has by wallets) name)
    ~&  "This wallet already exists"
    [~ this]
  :-  ~
  =/  new-wallet=wallet  [name ~]
  ~&  "Wallet {<name>} added succesfully"
  %=    this
    wallets  (~(put by wallets) [name new-wallet])
  ==
::
++  handle-list-wallet
  ^-  (quip move _this)
  ~&  [%local-wallets ~(tap by wallets)]
  ::  TODO: connect to %sole to print to console
  [~ this]
::
++  handle-update-wallet
  |=  [name=@t attrs=wallet-attr]
  ^-  (quip move _this)
  =/  w=wallet  [name (some attrs)]
  :-  ~
  ?:  (~(has by wallets) name.w)
    ~&  "The wallet exists. Updating..."
    this(wallets (~(jab by wallets) name.w |=(* w)))
  ~&  "The wallet doesn't exist. Creating..."
  this(wallets (~(put by wallets) [name.w w]))
::
--
