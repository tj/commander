require 'spec_helper'
require 'commander/methods'

describe Commander::Methods do
  it 'includes Commander::UI' do
    expect(subject.ancestors).to include(Commander::UI)
  end

  it 'includes Commander::UI::AskForClass' do
    expect(subject.ancestors).to include(Commander::UI::AskForClass)
  end

  it 'includes Commander::Delegates' do
    expect(subject.ancestors).to include(Commander::Delegates)
  end

  it 'does not change the Object ancestors' do
    expect(Object.ancestors).not_to include(Commander::UI)
  end
end
