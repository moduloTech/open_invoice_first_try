# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
RSpec.describe WelcomeController, type: :controller do
  subject { get :index }

  it { is_expected.to have_http_status :ok }
end
