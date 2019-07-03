require_relative '../../automated_init'

context "Handle Account Events" do
  context "Withdrawal Rejected" do
    context "Cancelled" do
      handler = Handlers::Account::Events.new

      withdrawal_rejected = Account::Client::Controls::Events::WithdrawalRejected.example

      funds_transfer_id = Controls::FundsTransfer.id
      funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"
      withdrawal_rejected.metadata.correlation_stream_name = funds_transfer_stream_name

      effective_time = withdrawal_rejected.time or fail

      withdrawal_id = withdrawal_rejected.withdrawal_id or fail
      withdrawal_account_id = withdrawal_rejected.account_id or fail
      amount = withdrawal_rejected.amount or fail

      funds_transfer = Controls::FundsTransfer::Initiated.example

      deposit_account_id = funds_transfer.deposit_account_id or fail

      handler.store.add(funds_transfer_id, funds_transfer)

      handler.(withdrawal_rejected)

      writer = handler.write

      cancelled = writer.one_message do |event|
        event.instance_of?(Messages::Events::Cancelled)
      end

      test "Cancelled event is written" do
        refute(cancelled.nil?)
      end

      test "Written to the funds transfer stream" do
        written_to_stream = writer.written?(cancelled) do |stream_name|
          stream_name == funds_transfer_stream_name
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "funds_transfer_id" do
          assert(cancelled.funds_transfer_id == funds_transfer_id)
        end

        test "withdrawal_account_id" do
          assert(cancelled.withdrawal_account_id == withdrawal_account_id)
        end

        test "deposit_account_id" do
          assert(cancelled.deposit_account_id == deposit_account_id)
        end

        test "withdrawal_id" do
          assert(cancelled.withdrawal_id == withdrawal_id)
        end

        test "amount" do
          assert(cancelled.amount == amount)
        end

        test "time" do
          assert(cancelled.time == effective_time)
        end
      end
    end
  end
end
