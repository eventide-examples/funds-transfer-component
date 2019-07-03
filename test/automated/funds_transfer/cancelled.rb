require_relative '../automated_init'

context "Funds Transfer" do
  context "Has Cancelled Time" do
    funds_transfer = Controls::FundsTransfer.example

    refute(funds_transfer.cancelled_time.nil?)

    test "Is cancelled" do
      assert(funds_transfer.cancelled?)
    end
  end

  context "Does Not Have Cancelled Time" do
    funds_transfer = Controls::FundsTransfer::New.example

    assert(funds_transfer.cancelled_time.nil?)

    test "Is not cancelled" do
      refute(funds_transfer.cancelled?)
    end
  end
end
