require 'spec_helper'

describe 'test environment' do
  describe Commander::UI do
    describe '.enable_paging' do
      it 'returns early because of no tty' do
        expect(Commander::UI.enable_paging(:on_no_tty => lambda { :no_tty })).to eq(:no_tty)
      end
    end
  end
end
