module FundsTransferComponent
  module Handlers
    class Commands
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName
      include Messages::Commands
      include Messages::Events

      dependency :write, Messaging::Postgres::Write
      dependency :clock, Clock::UTC
      dependency :store, Store
      dependency :identifier, Identifier::UUID::Random

      def configure
        Messaging::Postgres::Write.configure(self)
        Clock::UTC.configure(self)
        Store.configure(self)
        Identifier::UUID::Random.configure(self)
      end

      category :funds_transfer

      handle Transfer do |transfer|
        funds_transfer_id = transfer.funds_transfer_id

        funds_transfer = store.fetch(funds_transfer_id)

        if funds_transfer.initiated?
          logger.info(tag: :ignored) { "Command ignored (Command: #{transfer.message_type}, Funds Transfer ID: #{funds_transfer_id}, Withdrawal Account ID: #{transfer.withdrawal_account_id}, Deposit Account ID: #{transfer.deposit_account_id})" }
          return
        end

        initiated = Initiated.follow(transfer)

        initiated.processed_time = clock.iso8601

        stream_name = stream_name(initiated.funds_transfer_id)

        write.initial(initiated, stream_name)
      end
    end
  end
end
