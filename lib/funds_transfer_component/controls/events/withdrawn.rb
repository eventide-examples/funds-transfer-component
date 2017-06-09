module FundsTransferComponent
  module Controls
    module Events
      module Withdrawn
        def self.example
          withdrawn = FundsTransferComponent::Messages::Events::Withdrawn.build

          withdrawn.funds_transfer_id = FundsTransfer.id
          withdrawn.withdrawal_id = Withdrawal.id
          withdrawn.account_id = Withdrawal::Account.id
          withdrawn.amount = Money.example
          withdrawn.time = Time::Effective.example
          withdrawn.processed_time = Time::Processed.example

          withdrawn
        end
      end
    end
  end
end
