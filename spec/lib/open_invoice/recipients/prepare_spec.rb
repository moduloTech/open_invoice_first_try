# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
RSpec.describe OpenInvoice::Recipients::Prepare, type: :model do
  describe '::call' do
    let(:email) { 'new@user.mail' }
    let(:name) { 'new name' }
    let!(:existing) { FactoryBot.create(:recipient) }
    let(:recipients) do
      [
        { name: name, email: email },
        { email: existing.email }
      ]
    end

    subject { described_class.call(recipients) }

    it { is_expected.to be_an_instance_of Array }
    it { expect { subject }.to change { OpenInvoice::Recipient.count }.by(1) }

    it 'creates new recipient' do
      new_recipi, old_recipi = subject

      expect(old_recipi).to eq(existing)
      expect(new_recipi.name).to eq(name)
      expect(new_recipi.email).to eq(email)
    end
  end
end
