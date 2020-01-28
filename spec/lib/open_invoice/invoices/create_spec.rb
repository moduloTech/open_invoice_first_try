# frozen_string_literal: true

RSpec.describe OpenInvoice::Invoices::Create do
  let(:file) do
    Rack::Test::UploadedFile.new(File.open(Rails.root.join('../files/blank.pdf')),
                                 'application/pdf', original_filename: 'blank.pdf')
  end
  let(:invoice_params) do
    { subject:             'asd',
      invoice_number:      '2020-1',
      amount_vat_included: '12.3',
      amount_vat_excluded: '10',
      secure_key:          '123',
      original_file:       file }
  end
  let(:params) do
    ActionController::Parameters.new(invoice_params)
  end

  subject(:invoice) { OpenInvoice::Invoices::Create.call(params) }

  it { is_expected.to be_an_instance_of OpenInvoice::Invoice }
  it { expect(invoice.persisted?).to be true }
  it { expect { invoice }.to change { OpenInvoice::Invoice.count }.by(1) }

  context 'when invalid' do
    let(:file) { nil }

    it { is_expected.to be_an_instance_of OpenInvoice::Invoice }
    it { expect(invoice.persisted?).to be false }
    it { expect { invoice }.not_to(change { OpenInvoice::Invoice.count }) }
  end
end
