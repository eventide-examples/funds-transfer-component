module FundsTransferComponent
  module Controls
    module Events
      module Transferred
        def self.example
          transferred = FundsTransferComponent::Messages::Events::Transferred.build

          transferred.funds_transfer_id = FundsTransfer.id
          transferred.withdrawal_account_id = Withdrawal::Account.id
          transferred.deposit_account_id = Deposit::Account.id
          transferred.withdrawal_id = Withdrawal.id
          transferred.deposit_id = Deposit.id
          transferred.amount = Money.example

          transferred.time = Time::Effective.example
          transferred.processed_time = Time::Processed.example

          transferred
        end
      end
    end
  end
end
