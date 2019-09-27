# frozen_string_literal: true

# Author: varaby_m@modulotech.fr
RSpec.shared_context :rest_version do
  let(:remote_version) { '0.0.5' }

  let(:version_json) do
    {
      version: remote_version,
      changes: {
        '0.0.5' => [
          'sample 5'
        ],
        '0.0.4' => [
          'sample 4'
        ],
        '0.0.3' => [
          'sample 3'
        ],
        '0.0.2' => [
          'sample 2'
        ]
      }
    }
  end

  let(:rest_response) do
    double(body: JSON.generate(version_json))
  end

  before(:each) do
    allow(RestClient).to receive(:get).and_return(rest_response)
  end
end
