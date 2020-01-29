require 'support/admin_api_auth'

RSpec.describe OpenInvoice::Adm::RecipientsController, type: :controller do
  include_context :admin_tokens

  routes { OpenInvoice::Engine.routes }
  render_views

  describe '#index' do
    let!(:recipient) { FactoryBot.create(:recipient) }
    let!(:recipient2) { FactoryBot.create(:recipient, email: 'other@email') }
    let!(:invoice) do
      FactoryBot.create(:invoice).tap do |inv|
        inv.recipients << recipient2
      end
    end

    subject(:subject_request) do
      @request.headers[:Authentication] = token
      get :index, params: { invoice_id: invoice.id }, format: :json
    end

    include_examples :no_admin_token

    it { is_expected.to have_http_status :ok }

    describe 'response#body' do
      subject(:body) do
        subject_request
        JSON.parse(response.body, object_class: HashWithIndifferentAccess)
      end

      it { is_expected.to be_an_instance_of Array }
      it { is_expected.not_to be_empty }

      describe 'invoice from response' do
        subject do
          body.map { |r| r[:email] }
        end

        it { is_expected.to match_array [recipient2.email] }
      end

      context 'when no recipients' do
        before(:each) { recipient2.destroy! }

        it { is_expected.to be_empty }
      end
    end
  end
end
