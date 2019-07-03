require_relative '../automated_init'

context "Transfer Command" do
  context "Optional Funds Transfer ID" do
    withdrawal_account_id = Controls::Withdrawal::Account.id
    deposit_account_id = Controls::Deposit::Account.id
    amount = Controls::Money.example

    context "Omitted" do
      transfer = Commands::Transfer.(withdrawal_account_id: withdrawal_account_id, deposit_account_id: deposit_account_id, amount: amount)

      test "An ID is assigned" do
        refute(transfer.funds_transfer_id.nil?)
      end
    end

    context "Supplied" do
      funds_transfer_id = Controls::FundsTransfer.id

      transfer = Commands::Transfer.(
        funds_transfer_id: funds_transfer_id,
        withdrawal_account_id: withdrawal_account_id,
        deposit_account_id: deposit_account_id,
        amount: amount
      )

      test "ID is assigned to supplied ID" do
        assert(transfer.funds_transfer_id == funds_transfer_id)
      end
    end
  end
end
