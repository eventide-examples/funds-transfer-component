module FundsTransferComponent
  module Controls
    module FundsTransfer
      def self.example
        funds_transfer = FundsTransferComponent::FundsTransfer.build

        funds_transfer.id = self.id
        funds_transfer.deposit_account_id = Deposit::Account.id
        funds_transfer.withdrawal_account_id = Withdrawal::Account.id
        funds_transfer.withdrawal_id = Withdrawal.id
        funds_transfer.deposit_id = Deposit.id
        funds_transfer.amount = self.amount

        funds_transfer.initiated_time = Time::Effective::Raw.example
        funds_transfer.withdrawn_time = Time::Effective::Raw.example
        funds_transfer.deposited_time = Time::Effective::Raw.example
        funds_transfer.transferred_time = Time::Effective::Raw.example
        funds_transfer.cancelled_time = Time::Effective::Raw.example

        funds_transfer
      end

      def self.id
        ID.example(increment: id_increment)
      end

      def self.id_increment
        1111
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
          funds_transfer = FundsTransfer.example
          funds_transfer.withdrawn_time = nil
          funds_transfer.deposited_time = nil
          funds_transfer.transferred_time = nil
          funds_transfer.cancelled_time = nil
          funds_transfer
        end
      end

      module Withdrawn
        def self.example
          funds_transfer = FundsTransfer.example
          funds_transfer.deposited_time = nil
          funds_transfer.transferred_time = nil
          funds_transfer.cancelled_time = nil
          funds_transfer
        end
      end

      module Deposited
        def self.example
          funds_transfer = FundsTransfer.example
          funds_transfer.transferred_time = nil
          funds_transfer.cancelled_time = nil
          funds_transfer
        end
      end
    end
  end
end
