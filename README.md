# agl-service-canlowlevel-joystick-ctl_stub

This controller mimics CAN joystick events, as emited by alg-service-can-low-level, but using a cheap gamepad as input.

This allows controlling the OpenCPN's autopilot binding used in CES 2020 SEANASIM demo.

It depends on ["buttons" binding](https://github.com/iotbzh/agl-service-buttons-binding) that listens to generic game controllers (for instance, Playstation's DualShock, XBox, ...).

If you need to tweak the mapping (axis, buttons), it is defined in both :

`src/plugins/canlow-joystick-stub-api.lua`

and

conf.d/etc/canlow--joystick-stub.json


## Native build

```bash
mkdir build && cd build
cmake ..
make
```

## Manual tests

Beforehand, please launch [buttons](https://github.com/iotbzh/agl-service-buttons-binding) binding :

```bash
afb-daemon -vvv --port=1234  --ws-server=unix:/tmp/linux-joystick --no-ldpath --workdir=. --roothttp=../htdocs --token= --binding=package/lib/afb-buttons.so
```

Now you can launch
```bash
afb-daemon -vvv --ws-server=unix:/tmp/canlow-joystick-stub --ws-client=unix:/tmp/linux-joystick --port=2345 --name=afb-canlow-joystick-stub --no-ldpath --token= --binding=build/package/lib/afb-agl-service-canlowlevel-joystick-ctl_stub.so
```

