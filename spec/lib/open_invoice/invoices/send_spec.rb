# frozen_string_literal: true

RSpec.describe OpenInvoice::Invoices::Send do
  let(:invoice) { FactoryBot.create(:invoice) }
  let(:recipient) { FactoryBot.create(:recipient) }
  let(:recipients) do
    [
      { name: 'asd', email: 'asd@asd' },
      { email: recipient.email }
    ]
  end

  subject { OpenInvoice::Invoices::Send.call(invoice, recipients) }


  it 'creates links recipients to invoice' do
    expect { subject }.to change { invoice.recipients.reload.count }.from(0).to(2)
  end

  it 'sends email to each recipient' do
    2.times do
      expect(OpenInvoice::InvoiceMailer).to(
        receive(:recipient_added).with(invoice, OpenInvoice::Recipient, false)
          .and_call_original
      )
    end

    subject
  end

  it 'creates recipient for missing email' do
    expect { subject }.to(
      change { OpenInvoice::Recipient.exists?(email: 'asd@asd') }.from(false)
    )
  end

  it 'reuses existing recipient by email' do
    recipient # trigger existing recipient creation
    expect { subject }.to change { OpenInvoice::Recipient.count }.by(1)
    expect(invoice.recipients.reload).to include(recipient)
  end
end
