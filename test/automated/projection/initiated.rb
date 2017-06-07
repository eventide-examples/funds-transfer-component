require_relative '../automated_init'

context "Projection" do
  context "Initiated" do
    funds_transfer = Controls::FundsTransfer::New.example

    assert(funds_transfer.id.nil?)
    assert(funds_transfer.withdrawal_account_id.nil?)
    assert(funds_transfer.deposit_account_id.nil?)
    assert(funds_transfer.amount.nil?)
    assert(funds_transfer.initiated_time.nil?)

    initiated = Controls::Events::Initiated.example

    funds_transfer_id = initiated.funds_transfer_id or fail
    withdrawal_account_id = initiated.withdrawal_account_id or fail
    deposit_account_id = initiated.deposit_account_id or fail
    amount = initiated.amount or fail
    initiated_time_iso8601 = initiated.time or fail

    Projection.(funds_transfer, initiated)

    test "ID is set" do
      assert(funds_transfer.id == funds_transfer_id)
    end

    test "Withdrawal account ID" do
      assert(funds_transfer.withdrawal_account_id == withdrawal_account_id)
    end

    test "Deposit account ID" do
      assert(funds_transfer.deposit_account_id == deposit_account_id)
    end

    test "Amount" do
      assert(funds_transfer.amount == amount)
    end

    test "Initiated time is converted and set" do
      initiated_time = Clock.parse(initiated_time_iso8601)

      assert(funds_transfer.initiated_time == initiated_time)
    end
  end
end
