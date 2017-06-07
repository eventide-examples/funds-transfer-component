module FundsTransferComponent
  module Controls
    module Commands
      module Transfer
        def self.example
          transfer = FundsTransferComponent::Messages::Commands::Transfer.build

          transfer.funds_transfer_id = FundsTransfer.id
          transfer.deposit_account_id = Deposit::Account.id
          transfer.withdrawal_account_id = Withdrawal::Account.id
          transfer.amount = Money.example
          transfer.time = Time::Effective.example

          transfer
        end
      end
    end
  end
end
