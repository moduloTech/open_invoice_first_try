# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
RSpec.describe OpenInvoice::InvoicesController, type: :controller do
  routes { OpenInvoice::Engine.routes }

  describe '#show' do
    let(:id) { 1 }

    subject { get(:show, params: { id: id }) }

    it { is_expected.to have_http_status :found }

  end

end
