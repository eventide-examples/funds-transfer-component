require_relative '../../automated_init'

context "Handle Account Events" do
  context "Account Withdrawn" do
    context "Expected Version" do
      handler = Handlers::Account::Events.new

      account_withdrawn = Account::Client::Controls::Events::Withdrawn.example

      funds_transfer_id = Controls::FundsTransfer.id
      funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"
      account_withdrawn.metadata.correlation_stream_name = funds_transfer_stream_name

      funds_transfer = Controls::FundsTransfer::Initiated.example
      refute(funds_transfer.withdrawn?)

      version = Controls::Version.example

      handler.store.add(funds_transfer_id, funds_transfer, version)

      handler.(account_withdrawn)

      writer = handler.write

      withdrawn = writer.one_message do |event|
        event.instance_of?(Messages::Events::Withdrawn)
      end

      test "Is entity version" do
        written_to_stream = writer.written?(withdrawn) do |_, expected_version|
          expected_version == version
        end

        assert(written_to_stream)
      end
    end
  end
end
