require 'support/admin_api_auth'

RSpec.describe OpenInvoice::Adm::SendsController, type: :controller do
  include_context :admin_tokens

  routes { OpenInvoice::Engine.routes }

  let(:invoice) { FactoryBot.create(:invoice) }
  let(:recipient) { FactoryBot.create(:recipient) }
  let(:recipients) do
    [
      { name: 'asd', email: 'asd@asd' },
      { email: recipient.email }
    ]
  end

  subject(:subject_request) do
    @request.headers[:Authentication] = token
    post :create, params: { invoice_id: invoice.id, recipients: recipients }, format: :json
  end

  include_examples :no_admin_token

  it { is_expected.to have_http_status :ok }

  it 'creates links recipients to invoice' do
    expect { subject_request }.to change { invoice.recipients.reload.count }.from(0).to(2)
  end

  it 'sends email to each recipient' do
    2.times do
      expect(OpenInvoice::InvoiceMailer).to(
        receive(:recipient_added).with(invoice, OpenInvoice::Recipient, false)
          .and_call_original
      )
    end

    subject_request
  end

  it 'creates recipient for missing email' do
    expect { subject_request }.to(
      change { OpenInvoice::Recipient.exists?(email: 'asd@asd') }.from(false)
    )
  end

  it 'reuses existing recipient by email' do
    recipient # trigger existing recipient creation
    expect { subject_request }.to change { OpenInvoice::Recipient.count }.by(1)
    expect(invoice.recipients.reload).to include(recipient)
  end
end
