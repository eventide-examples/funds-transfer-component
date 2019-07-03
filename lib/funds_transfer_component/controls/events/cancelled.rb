module FundsTransferComponent
  module Controls
    module Events
      module Cancelled
        def self.example
          cancelled = FundsTransferComponent::Messages::Events::Cancelled.build

          cancelled.funds_transfer_id = FundsTransfer.id
          cancelled.withdrawal_account_id = Withdrawal::Account.id
          cancelled.deposit_account_id = Deposit::Account.id
          cancelled.withdrawal_id = Withdrawal.id
          cancelled.amount = Money.example

          cancelled.time = Time::Effective.example

          cancelled
        end
      end
    end
  end
end
