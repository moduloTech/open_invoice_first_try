require 'support/admin_api_auth'

RSpec.describe OpenInvoice::Adm::InvoicesController, type: :controller do
  include_context :admin_tokens

  routes { OpenInvoice::Engine.routes }
  render_views

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

  subject(:subject_request) do
    @request.headers[:Authentication] = token
    post :create, params: { invoice: invoice_params }, format: :json
  end

  include_examples :no_admin_token

  it { is_expected.to have_http_status :created }

  context 'when invalid attributes' do
    let!(:invalid_params) { invoice_params.delete(:original_file) }

    it { is_expected.to have_http_status :unprocessable_entity }
  end

  describe 'response#body' do
    subject do
      subject_request
      JSON.parse(response.body, object_class: HashWithIndifferentAccess)
    end

    it 'contains id of new invoice' do
      expect(subject[:id]).to be_present
    end

    context 'when invalid attributes' do
      let!(:invalid_params) { invoice_params.delete(:original_file) }

      it 'contains errors' do
        expect(subject[:error]).to be_present
      end
    end
  end
end
