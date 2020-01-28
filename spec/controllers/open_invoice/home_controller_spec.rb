# frozen_string_literal: true

RSpec.describe OpenInvoice::HomeController, type: :controller do
  routes { OpenInvoice::Engine.routes }

  subject { get :index }

  it { is_expected.to have_http_status :ok }
end
