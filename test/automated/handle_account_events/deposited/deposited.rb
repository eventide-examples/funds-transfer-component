require_relative '../../automated_init'

context "Handle Account Events" do
  context "Account Deposited" do
    context "Deposited" do
      handler = Handlers::Account::Events.new

      processed_time = Controls::Time::Processed::Raw.example

      handler.clock.now = processed_time

      account_deposited = Account::Client::Controls::Events::Deposited.example

      funds_transfer_id = Controls::FundsTransfer.id
      funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"
      account_deposited.metadata.correlation_stream_name = funds_transfer_stream_name

      account_id = account_deposited.account_id or fail
      amount = account_deposited.amount or fail
      effective_time = account_deposited.time or fail

      handler.(account_deposited)

      writer = handler.write

      deposited = writer.one_message do |event|
        event.instance_of?(Messages::Events::Deposited)
      end

      test "Deposited event is written" do
        refute(deposited.nil?)
      end

      test "Written to the funds transfer stream" do
        written_to_stream = writer.written?(deposited) do |stream_name|
          stream_name == funds_transfer_stream_name
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "funds_transfer_id" do
          assert(deposited.funds_transfer_id == funds_transfer_id)
        end

        test "account_id" do
          assert(deposited.account_id == account_id)
        end

        test "amount" do
          assert(deposited.amount == amount)
        end

        test "time" do
          assert(deposited.time == effective_time)
        end

        test "processed_time" do
          processed_time_iso8601 = Clock.iso8601(processed_time)

          assert(deposited.processed_time == processed_time_iso8601)
        end
      end
    end
  end
end
