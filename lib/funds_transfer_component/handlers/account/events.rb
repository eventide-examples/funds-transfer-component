module FundsTransferComponent
  module Handlers
    module Account
      class Events
        include Log::Dependency
        include Messaging::Handle
        include Messaging::StreamName
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

        handle ::Account::Client::Messages::Events::Withdrawn do |account_withdrawn|
          correlation_stream_name = account_withdrawn.metadata.correlation_stream_name
          funds_transfer_id = Messaging::StreamName.get_id(correlation_stream_name)

          funds_transfer, version = store.fetch(funds_transfer_id, include: :version)

          if funds_transfer.withdrawn?
            logger.info(tag: :ignored) { "Event ignored (Event: #{account_withdrawn.class.name}, Funds Transfer ID: #{funds_transfer_id}, Withdrawal Account ID: #{account_withdrawn.account_id})" }
            return
          end

          withdrawn = Withdrawn.follow(account_withdrawn, exclude: :sequence)

          withdrawn.funds_transfer_id = funds_transfer_id

          withdrawn.processed_time = clock.iso8601

          stream_name = stream_name(funds_transfer_id)

          write.(withdrawn, stream_name, expected_version: version)
        end

        handle ::Account::Client::Messages::Events::Deposited do |account_deposited|
          correlation_stream_name = account_deposited.metadata.correlation_stream_name
          funds_transfer_id = Messaging::StreamName.get_id(correlation_stream_name)

          funds_transfer, version = store.fetch(funds_transfer_id, include: :version)

          if funds_transfer.deposited?
            logger.info(tag: :ignored) { "Event ignored (Event: #{account_deposited.class.name}, Funds Transfer ID: #{funds_transfer_id}, Deposit Account ID: #{account_deposited.account_id})" }
            return
          end

          deposited = Deposited.follow(account_deposited, exclude: :sequence)

          deposited.funds_transfer_id = funds_transfer_id

          deposited.processed_time = clock.iso8601

          stream_name = stream_name(funds_transfer_id)

          write.(deposited, stream_name, expected_version: version)
        end

        handle ::Account::Client::Messages::Events::WithdrawalRejected do |withdrawal_rejected|
          correlation_stream_name = withdrawal_rejected.metadata.correlation_stream_name
          funds_transfer_id = Messaging::StreamName.get_id(correlation_stream_name)

          funds_transfer, version = store.fetch(funds_transfer_id, include: :version)

          if funds_transfer.cancelled?
            logger.info(tag: :ignored) { "Event ignored (Event: #{withdrawal_rejected.class.name}, Funds Transfer ID: #{funds_transfer_id}, Deposit Account ID: #{withdrawal_rejected.account_id})" }
            return
          end

          cancelled = Cancelled.follow(withdrawal_rejected, copy: [
            :withdrawal_id,
            { :account_id => :withdrawal_account_id },
            :amount,
            :time
          ])

          cancelled.funds_transfer_id = funds_transfer_id

          cancelled.deposit_account_id = funds_transfer.deposit_account_id

          stream_name = stream_name(funds_transfer_id)

          write.(cancelled, stream_name, expected_version: version)
        end
      end
    end
  end
end
