module Bencode

  class InputBuffer

    def initialize( s = nil )
      @s = s
    end

    def empty?
      return true if @s.nil?
      @s.empty?
    end

    def peek( offset = 0 )
      ensure_buffer_is_not_empty
      ensure_buffer_is_large_enough( offset + 1 )
      return @s[ offset ]
    end

    def shift( count = 1 )
      ensure_buffer_is_not_empty
      ensure_buffer_is_large_enough( count )
      result = @s[ 0..( count - 1 ) ]
      @s = @s[ count..-1 ]
      result
    end

    def length
      ensure_buffer_is_not_empty
      @s.length
    end

    def to_s
      @s
    end

    private

      def ensure_buffer_is_large_enough( count )
        raise BencodeException.new( "Buffer is not large enough (need #{count} but only have #{@s.length}" ) if @s.length < count
      end

      def ensure_buffer_is_not_empty
        raise BencodeException.new( 'Buffer is empty' ) if empty?
      end
    
  end

end

