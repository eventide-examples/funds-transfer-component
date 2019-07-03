require_relative '../automated_init'

context "Transfer Command" do
  context "Previous Message" do
    previous_message = Controls::Message.example

    funds_transfer_id = Controls::FundsTransfer.id
    withdrawal_account_id = Controls::Withdrawal::Account.id
    deposit_account_id = Controls::Deposit::Account.id
    amount = Controls::Money.example

    transfer = Commands::Transfer.new

    transfer.(previous_message: previous_message, funds_transfer_id: funds_transfer_id, withdrawal_account_id: withdrawal_account_id, deposit_account_id: deposit_account_id, amount: amount)

    write = transfer.write

    transfer_message = write.one_message do |written|
      written.instance_of?(Messages::Commands::Transfer)
    end

    refute(transfer_message.nil?)

    test "Transfer message follows previous message" do
      assert(transfer_message.follows?(previous_message))
    end
  end
end
