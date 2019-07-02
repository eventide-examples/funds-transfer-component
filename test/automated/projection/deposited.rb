require_relative '../automated_init'

context "Projection" do
  context "Deposited" do
    funds_transfer = Controls::FundsTransfer::New.example

    assert(funds_transfer.id.nil?)
    assert(funds_transfer.deposited_time.nil?)

    deposited = Controls::Events::Deposited.example

    funds_transfer_id = deposited.funds_transfer_id or fail
    deposited_time_iso8601 = deposited.time or fail

    Projection.(funds_transfer, deposited)

    test "ID is set" do
      assert(funds_transfer.id == funds_transfer_id)
    end

    test "Deposited time is converted and set" do
      deposited_time = Clock.parse(deposited_time_iso8601)

      assert(funds_transfer.deposited_time == deposited_time)
    end
  end
end
