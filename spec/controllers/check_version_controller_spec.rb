# frozen_string_literal: true

require 'support/auth'
require 'support/rest_version'

RSpec.describe CheckVersionController, type: :controller do
  include_context :login_admin
  include_context :rest_version

  describe '#index' do
    let(:format) { :json }
    subject { get :index, params: { format: format } }

    it { is_expected.to have_http_status :ok }

    context 'when incorrect format' do
      let(:format) { :html }

      it { is_expected.to have_http_status :found }
      it { expect { subject }.to change { flash[:danger] }.from(nil) }
    end

    context 'when not authenticated' do
      before(:each) { sign_out admin }

      it { is_expected.to have_http_status :unauthorized }
    end
  end
end
