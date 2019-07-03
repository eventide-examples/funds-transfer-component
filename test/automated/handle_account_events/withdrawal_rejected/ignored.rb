require_relative '../../automated_init'

context "Handle Account Events" do
  context "Withdrawal Rejected" do
    context "Cancelled" do
      handler = Handlers::Account::Events.new

      withdrawal_rejected = Account::Client::Controls::Events::WithdrawalRejected.example

      funds_transfer_id = Controls::FundsTransfer.id
      funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"
      withdrawal_rejected.metadata.correlation_stream_name = funds_transfer_stream_name

      funds_transfer = Controls::FundsTransfer.example
      assert(funds_transfer.cancelled?)

      handler.store.add(funds_transfer.id, funds_transfer)

      handler.(withdrawal_rejected)

      writer = handler.write

      cancelled = writer.one_message do |event|
        event.instance_of?(Messages::Events::Cancelled)
      end

      test "Cancelled event is not written" do
        assert(cancelled.nil?)
      end
    end
  end
end
