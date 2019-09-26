# frozen_string_literal: true

require 'support/auth'

# Author: varaby_m@modulotech.fr
RSpec.describe RecipientsController, type: :controller do
  let(:invoice) { FactoryBot.create(:invoice) }
  let(:email) { 'new@user.mail' }
  let(:name) { 'new name' }
  let(:invoice_id) { invoice.id }
  let!(:existing) { FactoryBot.create(:recipient) }
  let(:existing_w_link) { FactoryBot.create(:recipient, email: 'some@other.mail') }
  let!(:existing_link) { FactoryBot.create(:link, invoice: invoice, recipient: existing_w_link) }

  let(:recipients) do
    [
      { name: name, email: email },
      { email: existing.email },
      { email: existing_w_link.email }
    ]
  end
  let(:params) { { recipients: recipients, invoice_id: invoice_id } }

  subject do
    post(:create, params: params)
  end

  it { is_expected.to have_http_status :found }
  it { expect { subject }.not_to(change { invoice.links.count }) }

  context 'when logged_in' do
    include_context :login_admin

    it { is_expected.to have_http_status :found }
    it { expect { subject }.to(change { OpenInvoice::Link.count }.by(2)) }
    it { expect { subject }.to(change { OpenInvoice::Recipient.count }.by(1)) }
    it { expect { subject }.to(change { flash[:success] }.from(nil)) }

    context 'when invoice_id missing' do
      let(:invoice_id) { nil }

      it { is_expected.to have_http_status :found }
      it { expect { subject }.to change { flash[:danger] }.from(nil) }
    end

    context 'when invoice_id missing' do
      let(:recipients) { [] }

      it { is_expected.to have_http_status :found }
      it { expect { subject }.to(change { flash[:alert] }.from(nil)) }
    end
  end
end
