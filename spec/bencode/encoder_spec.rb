module Bencode

  describe Encoder do

    let( :encoder ) { Encoder.new() }

    it 'throws if a hash key is not a string' do
      expect{ encoder.encode( { 12 => 19 } ) }.to raise_error( BencodeException )
    end

    [
      [ 0, 'i0e' ],
      [ 1, 'i1e' ],
      [ -1, 'i-1e' ],
      [ 256, 'i256e' ],
      [ 'abc', '3abc' ],
      [ '', '0' ],
      [ [], 'le' ],
      [ [ 0 ], 'li0ee' ],
      [ [ [ 0, 1, 2 ], [ 3, 4 ] ], 'lli0ei1ei2eeli3ei4eee' ],
      [ {}, 'de' ],
      [ { 'abc' => 123 }, 'd3abci123ee' ],
      [ { 'abc' => { 'def' => 'ghi', 'klm' => [ 1, 2 ] }, 'nop' => -14 }, 'd3abcd3def3ghi3klmli1ei2eee3nopi-14ee' ],
    ].each do |v,e|
      it "encodes #{v} as #{e}" do
        expect( encoder.encode( v ) ).to eq( e )
      end
    end

  end

end

