/-  *btc-node-hook, sole
/+  sole, *test, lib=btc-node-json
::
/=  app  /:  /===/app/btc-node-hook
             /!noun/
::
/=  http-client-raw  /:  /===/sys/vane/iris  /!noun/
::
!:
::
=/  test-pit=vase  !>(..zuse)
=/  http-client-gate  (http-client-raw test-pit)
::
=/  endpoint  'http://127.0.0.1:18443/'
=/  headers=header-list:http
  :~  ['Accept' 'application/json']
      ['Content-Type' 'text/plain']
      ['Authorization' 'Basic dXJiaXRjb2luZXI6dXJiaXRjb2luZXI']
  ==
=/  app-state=state-zero:app  [%0 endpoint headers]
::
|%
::  Others
::
++  test-get-request-to-iris  ^-  tang
  =/  op  %get-blockchain-info
  =/  action=btc-node-hook-action:lib  [op ~]
  =/  expected-body  [op (method:btc-rpc:lib op) %list ~]
  =^  request  app
    (~(poke-noun app *bowl:gall app-state) action)
  =/  expected-request
    ^-  (list move:app)
    :~  :*  ost.bol.app
            %request
            /~2000.1.1
            :*  %'POST'
                endpoint.app-state
                headers.app-state
                %-  some
                  %-  as-octt:mimes:html
                    (en-json:html (request-to-json:rpc:jstd expected-body))
            ==
            *outbound-config:iris
    ==  ==
  ;:  weld
    %+  expect-eq
      !>  expected-request
      !>  request
  ==
::
++  test-get-wallet-info  ^-  tang
  =/  op  %get-wallet-info
  =/  action=request:btc-rpc  [op '']
  ::
  :: =^  request  app
  ::   (~(poke-noun app *bowl:gall app-state) action)
  =/  request=request:rpc:jstd
    (request-to-rpc:btc-rpc:lib action)
  ::
  =^  response  http-client-gate
    %-  http-client-call
      :*  http-client-gate
          now=(add ~1111.1.1 ~s1)
          scry=*sley
          request
      ==
  %+  expect-eq
    !>  [op (method:btc-rpc:lib op) %list ~]
    !>  (request-to-rpc:btc-rpc:lib action)
::  Utils
::
++  http-client-call
  |=  $:  http-client-gate=_http-client-gate
          now=@da
          scry=sley
          body=request:rpc:jstd
      ==
  ^-  (quip move:http-client-gate _http-client-gate)
  ::
  =/  http-client-core
    (http-client-gate our=~nul now=now eny=`@uvJ`0xdead.beef scry=scry)
  ::
  =/  req=request:http
    :*  %'POST'
        endpoint.app-state
        headers.app-state
        %-  some
          %-  as-octt:mimes:html
          (en-json:html (request-to-json:rpc:jstd body))
    ==
  =/  call-args=[=duct type=* wrapped-task=(hobo task:able:iris)]
    :*  duct=~[/~2000.1.1]  ~
        %request
        req
        *outbound-config:iris
    ==
  =^  moves  http-client-gate  (call:http-client-core call-args)
  ::
  [moves http-client-gate]
--
