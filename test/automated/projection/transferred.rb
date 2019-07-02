require_relative '../automated_init'

context "Projection" do
  context "Transferred" do
    funds_transfer = Controls::FundsTransfer::New.example

    assert(funds_transfer.id.nil?)
    assert(funds_transfer.transferred_time.nil?)

    transferred = Controls::Events::Transferred.example

    funds_transfer_id = transferred.funds_transfer_id or fail
    transferred_time_iso8601 = transferred.time or fail

    Projection.(funds_transfer, transferred)

    test "ID is set" do
      assert(funds_transfer.id == funds_transfer_id)
    end

    test "Transferred time is converted and set" do
      transferred_time = Clock.parse(transferred_time_iso8601)

      assert(funds_transfer.transferred_time == transferred_time)
    end
  end
end
