require_relative '../automated_init'

context "Projection" do
  context "Cancelled" do
    funds_transfer = Controls::FundsTransfer::New.example

    assert(funds_transfer.id.nil?)
    assert(funds_transfer.cancelled_time.nil?)

    cancelled = Controls::Events::Cancelled.example

    funds_transfer_id = cancelled.funds_transfer_id or fail
    cancelled_time_iso8601 = cancelled.time or fail

    Projection.(funds_transfer, cancelled)

    test "ID is set" do
      assert(funds_transfer.id == funds_transfer_id)
    end

    test "Cancelled time is converted and set" do
      cancelled_time = Clock.parse(cancelled_time_iso8601)

      assert(funds_transfer.cancelled_time == cancelled_time)
    end
  end
end
