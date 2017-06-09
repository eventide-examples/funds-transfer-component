require_relative '../automated_init'

context "Funds Transfer" do
  context "Has Withdrawn Time" do
    funds_transfer = Controls::FundsTransfer.example

    refute(funds_transfer.withdrawn_time.nil?)

    test "Is withdrawn" do
      assert(funds_transfer.withdrawn?)
    end
  end

  context "Does Not Have Withdrawn Time" do
    funds_transfer = Controls::FundsTransfer::New.example

    assert(funds_transfer.withdrawn_time.nil?)

    test "Is not withdrawn" do
      refute(funds_transfer.withdrawn?)
    end
  end
end
