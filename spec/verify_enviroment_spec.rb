require 'spec_helper'

describe 'test environment' do
  describe Commander::UI do
    describe '.enable_paging' do
      it 'is mocked' do
        expect(Commander::UI.enable_paging).to eq(:mocked)
      end
    end
  end
end
