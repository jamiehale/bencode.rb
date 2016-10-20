module Bencode

  class Encoder

    def encode( o )
      return encode_integer( o ) if o.instance_of? Fixnum
      return encode_string( o ) if o.instance_of? String
      return encode_array( o ) if o.instance_of? Array
      return encode_hash( o ) if o.instance_of? Hash
    end

    private

      def encode_integer( i )
        "i#{i}e"
      end

      def encode_string( s )
        "#{s.length}#{s}"
      end

      def encode_array( a )
        result = 'l'
        a.each { |v| result << encode( v ) }
        result << 'e'
        result
      end

      def encode_hash( h )
        result = 'd'
        h.each do |k,v|
          raise BencodeException.new( 'Hash keys must be strings' ) unless k.instance_of? String
          result << encode( k )
          result << encode( v )
        end
        result << 'e'
        result
      end

  end

end
