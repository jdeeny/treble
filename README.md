# treble

Treble provides friendly object oriented MIDI support for Love2D. Treble maintains
state for each monitored mini input channel and provides instant access to this
data. Optionally, an output channel can be used to push changes out to the device.

Each `Treble` instance monitors a single MIDI channel. You may need an array of
`Treble` objects for devices that operate as more than one channel.

Treble tracks the state of the channel so the data can be referenced later. When
messages are received, the state is changed and a callback is called. Changes can
be made to the state and they will be transmitted on the output channel.
