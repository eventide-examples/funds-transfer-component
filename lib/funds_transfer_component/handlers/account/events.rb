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
      end
    end
  end
end
