# frozen_string_literal: true

RSpec.describe WelcomeController, type: :controller do
  subject { get :index }

  it { is_expected.to have_http_status :ok }
end
