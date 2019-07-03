module FundsTransferComponent
  module Commands
    class Transfer
      include Messaging::StreamName
      include Messages::Events
      include Dependency

      category :funds_transfer

      dependency :write, Messaging::Postgres::Write
      dependency :clock, Clock::UTC

      def self.configure(receiver, attr_name: nil)
        attr_name ||= :transfer

        instance = build
        receiver.public_send(:"#{attr_name}=", instance)
        instance
      end

      def self.build
        instance = new
        Messaging::Postgres::Write.configure(instance)
        Clock::UTC.configure(instance)
        instance
      end

      def self.call(withdrawal_account_id:, deposit_account_id:, amount:, funds_transfer_id: nil, previous_message: nil)
        funds_transfer_id ||= Identifier::UUID::Random.get

        instance = build
        instance.(funds_transfer_id: funds_transfer_id, withdrawal_account_id: withdrawal_account_id, deposit_account_id: deposit_account_id, amount: amount, previous_message: previous_message)
      end

      def call(funds_transfer_id:, withdrawal_account_id:, deposit_account_id:, amount:, previous_message: nil)
        transfer = Messages::Commands::Transfer.new

        unless previous_message.nil?
          transfer.metadata.follow(previous_message.metadata)
        end

        transfer.funds_transfer_id = funds_transfer_id
        transfer.withdrawal_account_id = withdrawal_account_id
        transfer.deposit_account_id = deposit_account_id
        transfer.amount = amount
        transfer.time = clock.iso8601

        stream_name = command_stream_name(funds_transfer_id)

        write.(transfer, stream_name)

        transfer
      end
    end

    module Command
      module BuildMessage
        def build_message(message_class, previous_message)
          message = message_class.new

          unless previous_message.nil?
            message.metadata.follow(previous_message.metadata)
          end

          message
        end
      end
    end
  end
end

