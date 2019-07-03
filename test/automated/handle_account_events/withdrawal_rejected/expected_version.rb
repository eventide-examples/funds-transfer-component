require_relative '../../automated_init'

context "Handle Account Events" do
  context "Withdrawal Rejected" do
    context "Cancelled" do
      handler = Handlers::Account::Events.new

      withdrawal_rejected = Account::Client::Controls::Events::WithdrawalRejected.example

      funds_transfer_id = Controls::FundsTransfer.id
      funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"
      withdrawal_rejected.metadata.correlation_stream_name = funds_transfer_stream_name

      funds_transfer = Controls::FundsTransfer::Initiated.example
      refute(funds_transfer.cancelled?)

      version = Controls::Version.example

      handler.store.add(funds_transfer_id, funds_transfer, version)

      handler.(withdrawal_rejected)

      writer = handler.write

      cancelled = writer.one_message do |event|
        event.instance_of?(Messages::Events::Cancelled)
      end

      test "Is entity version" do
        written_to_stream = writer.written?(cancelled) do |_, expected_version|
          expected_version == version
        end

        assert(written_to_stream)
      end
    end
  end
end
