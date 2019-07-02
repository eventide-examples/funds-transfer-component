require_relative '../../automated_init'

context "Handle Events" do
  context "Deposited" do
    context "Expected Version" do
      handler = Handlers::Events.new

      deposited = FundsTransferComponent::Controls::Events::Deposited.example

      funds_transfer_id = Controls::FundsTransfer.id
      funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"
      deposited.metadata.correlation_stream_name = funds_transfer_stream_name

      funds_transfer = Controls::FundsTransfer::Deposited.example
      refute(funds_transfer.transferred?)

      version = Controls::Version.example

      handler.store.add(funds_transfer_id, funds_transfer, version)

      handler.(deposited)

      writer = handler.write

      transferred = writer.one_message do |event|
        event.instance_of?(Messages::Events::Transferred)
      end

      test "Is entity version" do
        written_to_stream = writer.written?(transferred) do |_, expected_version|
          expected_version == version
        end

        assert(written_to_stream)
      end
    end
  end
end
