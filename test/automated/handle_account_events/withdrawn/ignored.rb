require_relative '../../automated_init'

context "Handle Account Events" do
  context "Account Withdrawn" do
    context "Ignored" do
      handler = Handlers::Account::Events.new

      account_withdrawn = Account::Client::Controls::Events::Withdrawn.example

      funds_transfer_id = Controls::FundsTransfer.id
      funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"
      account_withdrawn.metadata.correlation_stream_name = funds_transfer_stream_name

      funds_transfer = Controls::FundsTransfer.example
      assert(funds_transfer.withdrawn?)

      handler.store.add(funds_transfer.id, funds_transfer)

      handler.(account_withdrawn)

      writer = handler.write

      withdrawn = writer.one_message do |event|
        event.instance_of?(Messages::Events::Withdrawn)
      end

      test "Withdrawn event is not written" do
        assert(withdrawn.nil?)
      end
    end
  end
end
