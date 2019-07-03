require_relative '../automated_init'

context "Transfer Command" do
  funds_transfer_id = Controls::FundsTransfer.id
  withdrawal_account_id = Controls::Withdrawal::Account.id
  deposit_account_id = Controls::Deposit::Account.id
  amount = Controls::Money.example
  effective_time = Controls::Time::Effective::Raw.example

  transfer = Commands::Transfer.new
  transfer.clock.now = effective_time

  transfer.(funds_transfer_id: funds_transfer_id, withdrawal_account_id: withdrawal_account_id, deposit_account_id: deposit_account_id, amount: amount)

  write = transfer.write

  transfer_message = write.one_message do |written|
    written.instance_of?(Messages::Commands::Transfer)
  end

  test "Transfer command is written" do
    refute(transfer_message.nil?)
  end

  test "Written to the funds transfer command stream" do
    written_to_stream = write.written?(transfer_message) do |stream_name|
      stream_name == "fundsTransfer:command-#{funds_transfer_id}"
    end

    assert(written_to_stream)
  end

  context "Attributes" do
    test "funds_transfer_id" do
      assert(transfer_message.funds_transfer_id == funds_transfer_id)
    end

    test "withdrawal_account_id" do
      assert(transfer_message.withdrawal_account_id == withdrawal_account_id)
    end

    test "deposit_account_id" do
      assert(transfer_message.deposit_account_id == deposit_account_id)
    end

    test "amount" do
      assert(transfer_message.amount == amount)
    end

    test "time" do
      effective_time_iso8601 = Clock.iso8601(effective_time)

      assert(transfer_message.time == effective_time_iso8601)
    end
  end
end
