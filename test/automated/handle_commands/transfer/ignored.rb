require_relative '../../automated_init'

context "Handle Commands" do
  context "Transfer" do
    context "Ignored" do
      handler = Handlers::Commands.new

      transfer = Controls::Commands::Transfer.example

      funds_transfer = Controls::FundsTransfer::Initiated.example
      assert(funds_transfer.initiated?)

      handler.store.add(funds_transfer.id, funds_transfer)

      handler.(transfer)

      writer = handler.write

      initiated = writer.one_message do |event|
        event.instance_of?(Messages::Events::Initiated)
      end

      test "Initiated event is not written" do
        assert(initiated.nil?)
      end
    end
  end
end
