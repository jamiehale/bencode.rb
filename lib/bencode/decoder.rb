
module Bencode

  class Decoder

    def decode( s )
      raise BencodeException.new if s.empty?
      decode_s( InputBuffer.new( s ) )
    end

    private

      def decode_s( s )
        return decode_int( s ) if is_integer?( s )
        return decode_list( s ) if is_list?( s )
        return decode_dictionary( s ) if is_dictionary?( s )
        decode_string( s )
      end

      def decode_int( s )
        s.shift
        i = 0;
        negative = false
        if s.peek == '-'
          negative = true
          s.shift
        end
        ensure_no_leading_zero( s )
        while s.peek != 'e'
          ensure_proper_termination( s, 'integer' )
          i = i * 10 + s.shift.to_i
        end
        s.shift
        i * ( negative ? -1 : 1 )
      end

      def decode_list( s )
        s.shift
        result = []
        while s.peek != 'e'
          ensure_proper_termination( s, 'list' )
          result << decode_s( s )
        end
        s.shift
        result
      end

      def decode_dictionary( s )
        s.shift
        result = {}
        while s.peek != 'e'
          ensure_proper_termination( s, 'dictionary' )
          key = decode_s( s )
          raise BencodeException.new( 'Key must be a string' ) unless key.is_a?( String )
          value = decode_s( s )
          result[ key ] = value
        end
        s.shift
        result
      end

      def decode_string( s )
        length = extract_string_length( s )
        s.shift( length )
      end

      def extract_string_length( s )
        length = 0
        while s.peek != ':'
          length = length * 10 + s.peek.to_i
          s.shift
        end
        s.shift
        length
      end

      def ensure_no_leading_zero( s )
        raise BencodeException.new( 'Leading 0' ) if s.peek == '0' and s.length > 1 and s.peek( 1 ) != 'e'
      end

      def ensure_proper_termination( s, t )
        raise BencodeException.new( 'Unterminated #{t}' ) if s.empty?
      end

      def ensure_complete_string( s, length, i )
        raise BencodeException.new( "Incomplete string (expecting #{length} bytes but only got #{i}" ) if s.empty?
      end

      def is_integer?( s )
        s.peek == 'i'
      end

      def is_list?( s )
        s.peek == 'l'
      end

      def is_dictionary?( s )
        s.peek == 'd'
      end

  end

end

