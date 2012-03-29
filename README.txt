MODWIRE README
By Tucker Stone, Mike Mogenson, and Jessica Noble
=================================================

Mike:  When a key is pressed, the noteOn: function is called in ViewController.m.  Right now, all it does is print a key number to the console.  I'd say have that function do some math and then send the midi number to your stuff to play the note.

Also, when the key is no longer pressed, the noteOff: function is called.  Don't know what to do about that yet…
