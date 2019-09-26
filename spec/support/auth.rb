# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
RSpec.shared_context :auth do
  let(:admin) { FactoryBot.create(:admin) }
end

RSpec.shared_context :login_admin do
  include_context :auth

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:admin]
    sign_in admin
  end
end
