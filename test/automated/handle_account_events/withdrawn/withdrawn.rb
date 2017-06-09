require_relative '../../automated_init'

context "Handle Account Events" do
  context "Account Withdrawn" do
    context "Withdrawn" do
      handler = Handlers::Account::Events.new

      processed_time = Controls::Time::Processed::Raw.example

      handler.clock.now = processed_time

      account_withdrawn = Account::Client::Controls::Events::Withdrawn.example

      funds_transfer_id = Controls::FundsTransfer.id
      funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"
      account_withdrawn.metadata.correlation_stream_name = funds_transfer_stream_name

      withdrawal_id = account_withdrawn.withdrawal_id or fail
      account_id = account_withdrawn.account_id or fail
      amount = account_withdrawn.amount or fail
      effective_time = account_withdrawn.time or fail

      handler.(account_withdrawn)

      writer = handler.write

      withdrawn = writer.one_message do |event|
        event.instance_of?(Messages::Events::Withdrawn)
      end

      test "Withdrawn event is written" do
        refute(withdrawn.nil?)
      end

      test "Written to the funds transfer stream" do
        written_to_stream = writer.written?(withdrawn) do |stream_name|
          stream_name == funds_transfer_stream_name
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "funds_transfer_id" do
          assert(withdrawn.funds_transfer_id == funds_transfer_id)
        end

        test "account_id" do
          assert(withdrawn.account_id == account_id)
        end

        test "amount" do
          assert(withdrawn.amount == amount)
        end

        test "time" do
          assert(withdrawn.time == effective_time)
        end

        test "processed_time" do
          processed_time_iso8601 = Clock.iso8601(processed_time)

          assert(withdrawn.processed_time == processed_time_iso8601)
        end
      end
    end
  end
end
