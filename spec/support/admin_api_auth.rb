RSpec.shared_examples :no_admin_token do
  context 'when no admin token' do
    let(:token) { nil }

    it { is_expected.to have_http_status :unauthorized }
  end

  context 'when no token is expired' do
    let!(:auth_token) { admin_token.update(expires_at: 1.day.ago) }

    it { is_expected.to have_http_status :unauthorized }
  end
end

RSpec.shared_context :admin_tokens do
  let(:admin_token) { FactoryBot.create(:admin_token) }
  let(:token) { admin_token.token }
end
