module FundsTransferComponent
  module Controls
    module FundsTransfer
      def self.example
        funds_transfer = FundsTransferComponent::FundsTransfer.build

        funds_transfer.id = self.id
        funds_transfer.deposit_account_id = Deposit::Account.id
        funds_transfer.withdrawal_account_id = Withdrawal::Account.id
        funds_transfer.amount = self.amount

        funds_transfer.initiated_time = Time::Effective::Raw.example

        funds_transfer
      end

      def self.id
        ID.example(increment: id_increment)
      end

      def self.id_increment
        11
      end

      def self.amount
        Money.example
      end

      module New
        def self.example
          FundsTransferComponent::FundsTransfer.build
        end
      end

      module Initiated
        def self.example
          FundsTransfer.example
        end
      end
    end
  end
end
