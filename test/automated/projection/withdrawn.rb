require_relative '../automated_init'

context "Projection" do
  context "Withdrawn" do
    funds_transfer = Controls::FundsTransfer::New.example

    assert(funds_transfer.id.nil?)
    assert(funds_transfer.initiated_time.nil?)

    withdrawn = Controls::Events::Withdrawn.example

    funds_transfer_id = withdrawn.funds_transfer_id or fail
    withdrawn_time_iso8601 = withdrawn.time or fail

    Projection.(funds_transfer, withdrawn)

    test "ID is set" do
      assert(funds_transfer.id == funds_transfer_id)
    end

    test "Initiated time is converted and set" do
      withdrawn_time = Clock.parse(withdrawn_time_iso8601)

      assert(funds_transfer.withdrawn_time == withdrawn_time)
    end
  end
end
