require_relative '../../automated_init'

context "Handle Commands" do
  context "Transfer" do
    context "Initiated" do
      handler = Handlers::Commands.new

      processed_time = Controls::Time::Processed::Raw.example

      handler.clock.now = processed_time

      transfer = Controls::Commands::Transfer.example

      funds_transfer_id = transfer.funds_transfer_id or fail
      withdrawal_account_id = transfer.withdrawal_account_id or fail
      deposit_account_id = transfer.deposit_account_id or fail
      amount = transfer.amount or fail
      effective_time = transfer.time or fail

      funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"

      handler.(transfer)

      writer = handler.write

      initiated = writer.one_message do |event|
        event.instance_of?(Messages::Events::Initiated)
      end

      test "Initiated event is written" do
        refute(initiated.nil?)
      end

      test "Written to the funds transfer stream" do
        written_to_stream = writer.written?(initiated) do |stream_name|
          stream_name == funds_transfer_stream_name
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "funds_transfer_id" do
          assert(initiated.funds_transfer_id == funds_transfer_id)
        end

        test "withdrawal_account_id" do
          assert(initiated.withdrawal_account_id == withdrawal_account_id)
        end

        test "withdrawal_id" do
          refute(initiated.withdrawal_id.nil?)
        end

        test "deposit_account_id" do
          assert(initiated.deposit_account_id == deposit_account_id)
        end

        test "amount" do
          assert(initiated.amount == amount)
        end

        test "time" do
          assert(initiated.time == effective_time)
        end

        test "processed_time" do
          processed_time_iso8601 = Clock.iso8601(processed_time)

          assert(initiated.processed_time == processed_time_iso8601)
        end
      end

      context "Metadata" do
        test "correlation_stream_name" do
          assert(initiated.metadata.correlation_stream_name == funds_transfer_stream_name)
        end
      end
    end
  end
end
