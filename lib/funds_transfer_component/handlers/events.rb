module FundsTransferComponent
  module Handlers
    class Events
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName
      include Messages::Commands
      include Messages::Events

      dependency :clock, Clock::UTC
      dependency :store, Store
      dependency :write, Messaging::Postgres::Write
      dependency :withdraw, ::Account::Client::Withdraw
      dependency :deposit, ::Account::Client::Deposit

      def configure
        Clock::UTC.configure(self)
        Store.configure(self)
        Messaging::Postgres::Write.configure(self)
        ::Account::Client::Withdraw.configure(self)
        ::Account::Client::Deposit.configure(self)
      end

      category :funds_transfer

      handle Initiated do |initiated|
        funds_transfer_id = initiated.funds_transfer_id
        account_id = initiated.withdrawal_account_id
        withdrawal_id = initiated.withdrawal_id
        amount = initiated.amount

        withdraw.(
          withdrawal_id: withdrawal_id,
          account_id: account_id,
          amount: amount,
          previous_message: initiated
        )
      end

      handle Withdrawn do |withdrawn|
        funds_transfer_id = withdrawn.funds_transfer_id

        funds_transfer = store.fetch(funds_transfer_id)

        account_id = funds_transfer.deposit_account_id
        deposit_id = funds_transfer.deposit_id
        amount = funds_transfer.amount

        deposit.(
          deposit_id: deposit_id,
          account_id: account_id,
          amount: amount,
          previous_message: withdrawn
        )
      end

      handle Deposited do |deposited|
        funds_transfer_id = deposited.funds_transfer_id

        funds_transfer, version = store.fetch(funds_transfer_id, include: :version)

        if funds_transfer.transferred?
          logger.info(tag: :ignored) { "Event ignored (Event: #{deposited.message_type}, Funds Transfer ID: #{funds_transfer_id}, Withdrawal Account ID: #{funds_transfer.withdrawal_account_id}, Deposit Account ID: #{funds_transfer.deposit_account_id})" }
          return
        end

        transferred = Transferred.follow(deposited, exclude: :account_id)

        SetAttributes.(transferred, funds_transfer, copy: [
          :withdrawal_account_id,
          :deposit_account_id,
          :withdrawal_id,
          :deposit_id
        ])

        transferred.processed_time = clock.iso8601

        stream_name = stream_name(transferred.funds_transfer_id)

        write.(transferred, stream_name, expected_version: version)
      end
    end
  end
end
