require_relative '../../automated_init'

context "Handle Events" do
  context "Deposited" do
    context "Ignored" do
      handler = Handlers::Events.new

      deposited = FundsTransferComponent::Controls::Events::Deposited.example

      funds_transfer_id = Controls::FundsTransfer.id
      funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"
      deposited.metadata.correlation_stream_name = funds_transfer_stream_name

      funds_transfer = Controls::FundsTransfer.example
      assert(funds_transfer.transferred?)

      handler.store.add(funds_transfer.id, funds_transfer)

      handler.(deposited)

      writer = handler.write

      transferred = writer.one_message do |event|
        event.instance_of?(Messages::Events::Transferred)
      end

      test "Transferred event is not written" do
        assert(transferred.nil?)
      end
    end
  end
end
