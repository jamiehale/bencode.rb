# Bencode.rb

This is a little Ruby gem for working with bittorrent bencoded files.

    Bencode::Encoder.new().encode( <object to be encoded> )
    Bencode::Decoder.new().decode( <bencoded string> )

It requires nothing for runtime, and RSpec for testing.

