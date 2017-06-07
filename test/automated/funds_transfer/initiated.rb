require_relative '../automated_init'

context "Funds Transfer" do
  context "Has Initiated Time" do
    funds_transfer = Controls::FundsTransfer::Initiated.example

    refute(funds_transfer.initiated_time.nil?)

    test "Is initiated" do
      assert(funds_transfer.initiated?)
    end
  end

  context "Does Not Have Initiated Time" do
    funds_transfer = Controls::FundsTransfer::New.example

    assert(funds_transfer.initiated_time.nil?)

    test "Is not initiated" do
      refute(funds_transfer.initiated?)
    end
  end
end
