require_relative '../../automated_init'

context "Handle Events" do
  context "Initiated" do
    context "Withdraw" do
      handler = Handlers::Events.new

      withdraw_client = Account::Client::Withdraw.new
      handler.withdraw = withdraw_client

      initiated = Controls::Events::Initiated.example

      funds_transfer_id = initiated.funds_transfer_id or fail
      withdrawal_account_id = initiated.withdrawal_account_id or fail
      withdrawal_id = initiated.withdrawal_id or fail
      amount = initiated.amount or fail

      initiated.metadata.correlation_stream_name = 'someCorrelationStream'

      account_command_stream_name = "account:command-#{withdrawal_account_id}"
      funds_transfer_command_stream_name = "fundsTransfer:command-#{funds_transfer_id}"

      handler.(initiated)

      writer = withdraw_client.write

      withdraw = writer.one_message do |event|
        event.instance_of?(Account::Client::Messages::Commands::Withdraw)
      end

      test "Withdraw command is written" do
        refute(withdraw.nil?)
      end

      test "Written to the account command stream" do
        written_to_stream = writer.written?(withdraw) do |stream_name|
          stream_name == account_command_stream_name
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "withdrawal_id" do
          assert(withdraw.withdrawal_id == withdrawal_id)
        end

        test "account_id" do
          assert(withdraw.account_id == withdrawal_account_id)
        end

        test "amount" do
          assert(withdraw.amount == amount)
        end
      end

      context "Metadata" do
        test "Follows previous message" do
          assert(withdraw.metadata.correlation_stream_name == initiated.metadata.correlation_stream_name)
        end
      end
    end
  end
end
