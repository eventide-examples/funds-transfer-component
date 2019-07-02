module FundsTransferComponent
  module Controls
    module Commands
      module Transfer
        def self.example(id: nil, withdrawal_account_id: nil, deposit_account_id: nil, amount: nil)
          id ||= FundsTransfer.id
          withdrawal_account_id ||= Withdrawal::Account.id
          deposit_account_id ||= Deposit::Account.id
          amount ||= Money.example

          transfer = FundsTransferComponent::Messages::Commands::Transfer.build

          transfer.funds_transfer_id = id
          transfer.withdrawal_account_id = withdrawal_account_id
          transfer.deposit_account_id = deposit_account_id
          transfer.amount = amount
          transfer.time = Time::Effective.example

          transfer
        end
      end
    end
  end
end
