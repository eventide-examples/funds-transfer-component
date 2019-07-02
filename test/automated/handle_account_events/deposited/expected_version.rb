require_relative '../../automated_init'

context "Handle Account Events" do
  context "Account Deposited" do
    context "Expected Version" do
      handler = Handlers::Account::Events.new

      account_deposited = Account::Client::Controls::Events::Deposited.example

      funds_transfer_id = Controls::FundsTransfer.id
      funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"
      account_deposited.metadata.correlation_stream_name = funds_transfer_stream_name

      funds_transfer = Controls::FundsTransfer::Withdrawn.example
      refute(funds_transfer.deposited?)

      version = Controls::Version.example

      handler.store.add(funds_transfer_id, funds_transfer, version)

      handler.(account_deposited)

      writer = handler.write

      deposited = writer.one_message do |event|
        event.instance_of?(Messages::Events::Deposited)
      end

      test "Is entity version" do
        written_to_stream = writer.written?(deposited) do |_, expected_version|
          expected_version == version
        end

        assert(written_to_stream)
      end
    end
  end
end
