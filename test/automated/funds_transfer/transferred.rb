require_relative '../automated_init'

context "Funds Transfer" do
  context "Has Transferred Time" do
    funds_transfer = Controls::FundsTransfer.example

    refute(funds_transfer.transferred_time.nil?)

    test "Is transferred" do
      assert(funds_transfer.transferred?)
    end
  end

  context "Does Not Have Transferred Time" do
    funds_transfer = Controls::FundsTransfer::New.example

    assert(funds_transfer.transferred_time.nil?)

    test "Is not transferred" do
      refute(funds_transfer.transferred?)
    end
  end
end
