
module Bencode

  describe InputBuffer do

    describe 'an empty buffer' do

      let( :buffer ) { InputBuffer.new() }

      it 'is empty' do
        expect( buffer ).to be_empty
      end

      it 'throws if we ask for the next character' do
        expect{ buffer.peek }.to raise_error( BencodeException )
      end

      it 'throws if we ask for the length' do
        expect{ buffer.length }.to raise_error( BencodeException )
      end

    end

    describe 'a non-empty buffer' do

      let( :buffer ) { InputBuffer.new( 'abcde' ) }

      it 'is not empty' do
        expect( buffer ).not_to be_empty
      end

      it 'allows us to ask for the next character' do
        expect( buffer.peek ).to eq( 'a' )
      end

      it 'allows us to peek to another character' do
        expect( buffer.peek( 1 ) ).to eq( 'b' )
      end

      it 'throws if we peek too far' do
        expect{ buffer.peek( 100 ) }.to raise_error( BencodeException )
      end

      it 'knows its length' do
        expect( buffer.length ).to eq( 5 )
      end

      describe 'shifting' do

        it 'allows us to shift the next character' do
          expect( buffer.shift ).to eq( 'a' )
        end

        it 'removes the shifted character from the buffer' do
          buffer.shift
          expect( buffer.to_s ).to eq( 'bcde' )
        end

        it 'allows us to shift multiple characters' do
          expect( buffer.shift( 3 ) ).to eq( 'abc' )
        end

        it 'removes all shifted characters from the buffer' do
          buffer.shift( 3 )
          expect( buffer.to_s ).to eq( 'de' )
        end

        describe 'an empty buffer' do

          let( :buffer ) { InputBuffer.new() }

          it 'throws' do
            expect{ buffer.shift }.to raise_error( BencodeException )
          end

        end

      end

    end

  end

end

