require_relative '../../automated_init'

context "Handle Commands" do
  context "Transfer" do
    context "Withdrawal ID" do
      withdrawal_id = Controls::Withdrawal.id

      handler = Handlers::Commands.new

      transfer = Controls::Commands::Transfer.example

      handler.identifier.set(withdrawal_id)

      handler.(transfer)

      writer = handler.write

      initiated = writer.one_message do |event|
        event.instance_of?(Messages::Events::Initiated)
      end

      refute(initiated.nil?)

      test "Assigned" do
        assert(initiated.withdrawal_id == withdrawal_id)
      end
    end
  end
end
