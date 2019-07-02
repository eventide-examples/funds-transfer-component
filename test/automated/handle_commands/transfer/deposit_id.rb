require_relative '../../automated_init'

context "Handle Commands" do
  context "Transfer" do
    context "Deposit ID" do
      deposit_id = Controls::Deposit.id

      handler = Handlers::Commands.new

      transfer = Controls::Commands::Transfer.example

      handler.identifier.set(deposit_id)

      handler.(transfer)

      writer = handler.write

      initiated = writer.one_message do |event|
        event.instance_of?(Messages::Events::Initiated)
      end

      refute(initiated.nil?)

      test "Assigned" do
        assert(initiated.deposit_id == deposit_id)
      end
    end
  end
end
