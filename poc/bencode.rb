
class BencodeException < Exception
end

class BencodeDecoder

  def decode_s( s )
    raise BencodeException.new if s.empty?
    decode( s.chars )
  end

  def decode( s )
    return decode_int( s ) if is_integer?( s )
    return decode_list( s ) if is_list?( s )
    return decode_dictionary( s ) if is_dictionary?( s )
    decode_string( s )
  end

  private

    def decode_int( s )
      s.shift
      i = 0;
      negative = false
      if s[ 0 ] == '-'
        negative = true
        s.shift
      end
      ensure_no_leading_zero( s )
      while s[ 0 ] != 'e'
        ensure_proper_termination( s, 'integer' )
        i = i * 10 + s.shift.to_i
      end
      s.shift
      i * ( negative ? -1 : 1 )
    end

    def decode_list( s )
      s.shift
      result = []
      while s[ 0 ] != 'e'
        ensure_proper_termination( s, 'list' )
        result << decode( s )
      end
      s.shift
      result
    end

    def decode_dictionary( s )
      s.shift
      result = {}
      while s[ 0 ] != 'e'
        ensure_proper_termination( s, 'dictionary' )
        key = decode( s )
        raise BencodeException.new( 'Key must be a string' ) unless key.is_a?( String )
        value = decode( s )
        result[ key ] = value
      end
      s.shift
      result
    end

    def decode_string( s )
      length = extract_string_length( s )
      result = ""
      length.times do
        result += s.shift
      end
      result
    end

    def extract_string_length( s )
      length = 0
      while s[ 0 ] != ':'
        length = length * 10 + s[ 0 ].to_i
        s.shift
      end
      s.shift
      length
    end

    def ensure_no_leading_zero( s )
      if s[ 0 ] == '0'
        raise BencodeException.new( 'Leading 0' ) if s.length > 1 and s[ 1 ] != 'e'
      end
    end

    def ensure_proper_termination( s, t )
      raise BencodeException.new( 'Unterminated #{t}' ) if s.empty?
    end

    def is_integer?( s )
      s[ 0 ] == 'i'
    end

    def is_list?( s )
      s[ 0 ] == 'l'
    end

    def is_dictionary?( s )
      s[ 0 ] == 'd'
    end

end

describe BencodeDecoder do

  let( :decoder ) { BencodeDecoder.new() }

  it 'throws for empty input' do
    expect{ decoder.decode_s( '' ) }.to raise_error( BencodeException )
  end

  it 'throws for an unterminated integer' do
    expect{ decoder.decode_s( 'i123' ) }.to raise_error( BencodeException )
  end

  it 'throws for unnecessary leading 0' do
    expect{ decoder.decode_s( 'i03e' ) }.to raise_error( BencodeException )
  end

  it 'throws for an unterminated list' do
    expect{ decoder.decode_s( 'li0ei1e' ) }.to raise_error( BencodeException )
  end

  it 'throws for a non-string key in a dictionary' do
    expect{ decoder.decode_s( 'di0ei1ee' ) }.to raise_error( BencodeException )
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
      expect( decoder.decode_s( s ) ).to eq( v )
    end
  end

end

