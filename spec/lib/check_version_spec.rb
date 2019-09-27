# frozen_string_literal: true

require 'check_version'
require 'support/rest_version'

# Author: varaby_m@modulotech.fr
RSpec.describe CheckVersion, type: :model do
  include_context :rest_version
  let(:version) { '0.0.3' }

  before(:each) do
    stub_const('CheckVersion::LOCAL_VERSION', Gem::Version.new(version))
  end

  describe '#outdated?' do
    subject { CheckVersion.new.outdated? }

    it { is_expected.to be true }

    context 'when up-to-date' do
      let(:version) { '0.0.5' }

      it { is_expected.to be false }
    end
  end

  describe '#remote_version' do
    subject { CheckVersion.new.remote_version }

    it { is_expected.to eq(Gem::Version.new(remote_version)) }
  end

  describe '#missing_changes' do
    subject { CheckVersion.new.missing_changes }

    it { is_expected.to be_an_instance_of Hash }

    it 'include versions after current' do
      expect(subject.keys).to contain_exactly('0.0.4', '0.0.5')
    end

    context 'when current version is latest' do
      let(:version) { '0.0.5' }

      it { is_expected.to be_empty }
    end
  end
end
