# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
RSpec.describe OpenInvoice::InvoicesController, type: :controller do
  routes { OpenInvoice::Engine.routes }

  describe '#show' do
    let(:invoice) { FactoryBot.create(:invoice) }
    let(:recipient) { FactoryBot.create(:recipient) }
    let!(:link) { FactoryBot.create(:link, invoice: invoice, recipient: recipient) }
    let(:id) { invoice.id }
    let(:recipient_id) { recipient.id }
    let(:format) { :html }
    let(:session) { { open_invoice: {} } }

    subject do
      get(:show, params:  { invoice_id: id, recipient_id: recipient_id, format: format },
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

    context 'when incorrect recipient_id' do
      let(:recipient_id) { 1 }

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

      context 'when incorrect recipient_id' do
        let(:recipient_id) { 1 }

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

      context 'when incorrect recipient_id' do
        let(:recipient_id) { 1 }

        it { is_expected.to have_http_status :found }
      end

      context 'when visit pdf after html within same session' do
        before(:each) do
          get(:show, params:  { invoice_id: id, recipient_id: recipient_id, format: :html },
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
    subject { get :index, session: session }

    it { is_expected.to have_http_status :ok }
  end
end
