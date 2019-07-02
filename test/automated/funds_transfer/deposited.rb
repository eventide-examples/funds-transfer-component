require_relative '../automated_init'

context "Funds Transfer" do
  context "Has Deposited Time" do
    funds_transfer = Controls::FundsTransfer.example

    refute(funds_transfer.deposited_time.nil?)

    test "Is deposited" do
      assert(funds_transfer.deposited?)
    end
  end

  context "Does Not Have Deposited Time" do
    funds_transfer = Controls::FundsTransfer::New.example

    assert(funds_transfer.deposited_time.nil?)

    test "Is not deposited" do
      refute(funds_transfer.deposited?)
    end
  end
end
