
module Bencode

  describe Decoder do

    let( :decoder ) { Decoder.new() }

    it 'throws for empty input' do
      expect{ decoder.decode( '' ) }.to raise_error( BencodeException )
    end

    it 'throws for an unterminated integer' do
      expect{ decoder.decode( 'i123' ) }.to raise_error( BencodeException )
    end

    it 'throws for unnecessary leading 0' do
      expect{ decoder.decode( 'i03e' ) }.to raise_error( BencodeException )
    end

    it 'throws for an unterminated list' do
      expect{ decoder.decode( 'li0ei1e' ) }.to raise_error( BencodeException )
    end

    it 'throws for a non-string key in a dictionary' do
      expect{ decoder.decode( 'di0ei1ee' ) }.to raise_error( BencodeException )
    end

    [
      [ 'i0e', 0 ],
      [ 'i1e', 1 ],
      [ 'i-1e', -1 ],
      [ 'i12e', 12 ],
      [ 'i-256e', -256 ],
      [ 'le', [] ],
      [ 'li0ee', [ 0 ] ],
      [ 'li1ee', [ 1 ] ],
      [ 'li0ei1ee', [ 0, 1 ] ],
      [ 'lli0eeli1eee', [ [ 0 ], [ 1 ] ] ],
      [ '4:spam', 'spam' ],
      [ '12:abcdefghijkl', 'abcdefghijkl' ],
      [ 'de', {} ],
      [ 'd4:spami0ee', { 'spam' => 0 } ],
      [ 'd4:spamd3:abcli0ei1ei2eeee', { 'spam' => { 'abc' => [ 0, 1, 2 ] } } ]
    ].each do |s,v|
      it "handles the literal #{s}" do
        expect( decoder.decode( s ) ).to eq( v )
      end
    end

  end

end

