# frozen_string_literal: true

RSpec.describe OpenInvoice::Invoices::List do
  let!(:invoices) { FactoryBot.create_list(:invoice, 2) }
  let(:page) { 1 }

  subject { OpenInvoice::Invoices::List.call(page).to_a }

  it { is_expected.to be_an_instance_of Array }
  it { expect(subject.size).to eq 2 }

  context 'when page change' do
    let(:page) { 2 }

    it { is_expected.to be_empty }
  end

end
