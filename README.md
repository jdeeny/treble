# treble

Treble provides friendly object oriented MIDI support for Love2D. Treble maintains
state for each monitored mini input channel and provides instant access to this
data. Optionally, an output channel can be used to push changes out to the device.

Each `Treble` instance monitors a set of midi controls.

Treble tracks the state of the channel so the data can be referenced later. When
messages are received, the state is changed and a callback is called. Changes can
be made to the state and they will be transmitted on the output channel.

## Initialization
The example here is for the WORLDE Easycontrol.9.

First, initialize the instance. The `get_io_ports` is a helper to find the input/output port given a match string.

```
worlde = treble:new(treble.get_io_ports('WORLDE')) 
```
Then you want to setup and load the controls.

```
worlde:load_controls({
  fader1 =  {control=3,  type='fader', on_change=function(value) print("Fader1 is now "..value) end},
  fader2 =  {control=4,  type='fader'},
  fader3 =  {control=5,  type='fader'},
  fader4 =  {control=6,  type='fader'},
  fader5 =  {control=7,  type='fader'},
  fader6 =  {control=8,  type='fader'},
  fader7 =  {control=9,  type='fader'},
  fader8 =  {control=10, type='fader'},
  fader9 =  {control=11, type='fader'},
  knob1 =   {control=14, type='knob'},
  knob2 =   {control=15, type='knob'},
  knob3 =   {control=16, type='knob'},
  knob4 =   {control=17, type='knob', on_change=function(value) print("Knob4 is now "..value) end},
  knob5 =   {control=18, type='knob'},
  knob6 =   {control=19, type='knob'},
  knob7 =   {control=20, type='knob'},
  knob8 =   {control=21, type='knob'},
  knob9 =   {control=22, type='knob'},
  button1 = {control=23, type='button', on_press=function() print("Button1 was pressed") end},
  button2 = {control=24, type='button'},
  button3 = {control=25, type='button'},
  button4 = {control=26, type='button'},
  button5 = {control=27, type='button'},
  button6 = {control=28, type='button'},
  button7 = {control=29, type='button'},
  button8 = {control=30, type='button'},
  button9 = {control=31, type='button', on_release=function() print("Button9 was released") end},
})
```

### Types

#### `button`
A button can take on either a value of `0` or `1`. 

Supports callbacks of:
* `on_press` -> `function () end`
* `on_release` -> `function () end`

#### `knob`
A knob can have values from `0` to `127`.

Supports callbacks of:
* `on_change` -> `function(value) end`

#### `fader`
A fader can have values from `0` to `127`.

Supports callbacks of:
* `on_change` -> `function(value) end`

## Usage
To get the current value of the control input do
```
worlde:get('button2')
```

