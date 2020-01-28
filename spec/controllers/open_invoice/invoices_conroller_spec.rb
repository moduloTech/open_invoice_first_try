# frozen_string_literal: true

RSpec.describe OpenInvoice::InvoicesController, type: :controller do
  routes { OpenInvoice::Engine.routes }

  describe '#show' do
    let(:invoice) { FactoryBot.create(:invoice) }
    let(:recipient) { FactoryBot.create(:recipient) }
    let!(:link) { FactoryBot.create(:link, invoice: invoice, recipient: recipient) }
    let(:id) { invoice.id }
    let(:public_id) { recipient.public_id }
    let(:format) { :html }
    let(:session) { { open_invoice: {} } }

    subject do
      get(:show, params:  { invoice_id: id, public_id: public_id, format: format },
                 session: session)
    end

    it { is_expected.to have_http_status :ok }
    it { expect { subject }.to change { invoice.visits.count }.by(1) }
    it { expect { subject }.to change { session[:open_invoice][:skip_pdf_visit] }.to(true) }

    context 'when link missing' do
      before(:each) { link.destroy! }

      it { is_expected.to have_http_status :found }

      context 'when authorized' do
        let(:session) { { open_invoice: { recipient_id: recipient.id } } }

        it { is_expected.to have_http_status :found }
      end
    end

    context 'when incorrect id' do
      let(:id) { 1 }

      it { is_expected.to have_http_status :found }
    end

    context 'when incorrect public_id' do
      let(:public_id) { 1 }

      it { is_expected.to have_http_status :found }
    end

    context 'when json format' do
      let(:format) { :json }

      it { is_expected.to have_http_status :ok }
      it { expect { subject }.to change { invoice.visits.count }.by(1) }

      context 'when link missing' do
        before(:each) { link.destroy! }

        it { is_expected.to have_http_status :unauthorized }

        context 'when authorized' do
          let(:session) { { open_invoice: { recipient_id: recipient.id } } }

          it { is_expected.to have_http_status :not_found }
        end
      end

      context 'when incorrect id' do
        let(:id) { 1 }

        it { is_expected.to have_http_status :unauthorized }
      end

      context 'when incorrect public_id' do
        let(:public_id) { 1 }

        it { is_expected.to have_http_status :unauthorized }
      end
    end

    context 'when pdf format' do
      let(:format) { :pdf }

      it { is_expected.to have_http_status :ok }
      it { expect { subject }.to change { invoice.visits.count }.by(1) }

      context 'when link missing' do
        before(:each) { link.destroy! }

        it { is_expected.to have_http_status :found }

        context 'when authorized' do
          let(:session) { { open_invoice: { recipient_id: recipient.id } } }

          it { is_expected.to have_http_status :found }
        end
      end

      context 'when incorrect id' do
        let(:id) { 1 }

        it { is_expected.to have_http_status :found }
      end

      context 'when incorrect public_id' do
        let(:public_id) { 1 }

        it { is_expected.to have_http_status :found }
      end

      context 'when visit pdf after html within same session' do
        before(:each) do
          get(:show, params:  { invoice_id: id, public_id: public_id, format: :html },
                     session: session)
        end

        it { expect { subject }.not_to(change { invoice.visits.count }) }
        it { expect { subject }.to change { session[:open_invoice][:skip_pdf_visit] }.to(nil) }
      end
    end
  end

  describe '#index' do
    let!(:invoice) { FactoryBot.create(:invoice) }
    let!(:invoice2) { FactoryBot.create(:invoice) }
    let(:recipient) { FactoryBot.create(:recipient) }
    let(:session) { { open_invoice: { recipient_id: recipient.id } } }
    let(:headers) { {} }
    subject do
      @request.headers.merge!(headers)
      get :index, session: session, format: :json
    end

    it { is_expected.to have_http_status :ok }

    context 'when no session' do
      let(:session) { nil }

      it { is_expected.to have_http_status :unauthorized }

      context 'with recipients.api_token' do
        let(:headers) { { Authentication: recipient.api_token } }

        it { is_expected.to have_http_status :ok }
      end
    end
  end
end
