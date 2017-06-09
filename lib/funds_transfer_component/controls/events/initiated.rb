module FundsTransferComponent
  module Controls
    module Events
      module Initiated
        def self.example
          initiated = FundsTransferComponent::Messages::Events::Initiated.build

          initiated.funds_transfer_id = FundsTransfer.id
          initiated.withdrawal_account_id = Withdrawal::Account.id
          initiated.deposit_account_id = Deposit::Account.id
          initiated.withdrawal_id = Withdrawal.id
          initiated.amount = Money.example

          initiated.time = Time::Effective.example
          initiated.processed_time = Time::Processed.example

          initiated
        end
      end
    end
  end
end
