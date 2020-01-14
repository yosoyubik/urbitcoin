::  Sends a command to the BTC hook app
::
/-  *btc-node-hook
::
:-  %say
|=  $:  [now=@da eny=@uvJ =beak]
        [[comm=btc-node-hook-command ~] ~]
    ==
:-  %btc-node-hook-command
?+  -.comm  ~|  [%unsupported-command -.comm]  !!
    %credentials
    ::  If bitcoind running with
    ::    -regtest
    ::    -rpcuser=urbitcoiner
    ::    -rpcport=18443
    ::    -rpcpassword=urbitcoiner
    ::  use:
    ::  :*  %credentials
    ::      'http://127.0.0.1:18443/'
    ::      :~  ['Content-Type' 'application/json']
    ::          ['Authorization' 'Basic dXJiaXRjb2luZXI6dXJiaXRjb2luZXI']
    ::  ==  ==
    ::
  [%credentials +.comm]
==
