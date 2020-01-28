# frozen_string_literal: true

RSpec.describe OpenInvoice::Recipients::Assign, type: :model do
  include ActiveJob::TestHelper

  describe '::call' do
    let!(:rec1) { FactoryBot.create(:recipient) }
    let!(:rec2) { FactoryBot.create(:recipient, email: 'jane.doe@mail.test') }
    let!(:invoice) { FactoryBot.create(:invoice).tap { |inv| inv.recipients << rec1 } }
    let(:recipients) { [rec1, rec2] }
    let(:notify) { true }
    let(:list_recipients) { false }

    subject(:base) do
      described_class.call(invoice, recipients, notify: notify, list_recipients: list_recipients)
    end

    it { expect { subject }.to change { OpenInvoice::Link.count }.by(1) }
    it { expect { subject }.to change { enqueued_jobs.size }.by(2) }

    context 'when notify reset' do
      let(:notify) { false }

      it { expect { subject }.not_to(change { enqueued_jobs.size }) }
    end

    describe 'list_recipients:' do
      let(:list_recipients) { true }

      it 'passes recipient list to mailer' do
        2.times do
          expect(OpenInvoice::InvoiceMailer).to(
            receive(:recipient_added).with(invoice, OpenInvoice::Recipient, Array).and_call_original
          )
        end

        subject
      end

      context 'when list_recipient reset' do
        let(:list_recipients) { false }

        it 'does not pass recipient list to mailer' do
          2.times do
            expect(OpenInvoice::InvoiceMailer).to(
              receive(:recipient_added).with(invoice, OpenInvoice::Recipient, false)
                .and_call_original
            )
          end

          subject
        end
      end

      context 'when single recipient' do
        let(:recipients) { [rec2] }

        it 'does not pass recipient list to mailer' do
          expect(OpenInvoice::InvoiceMailer).to(
            receive(:recipient_added).with(invoice, OpenInvoice::Recipient, false)
              .and_call_original
          )

          subject
        end
      end
    end
  end
end
