module FundsTransferComponent
  module Handlers
    class Events
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName
      include Messages::Commands
      include Messages::Events

      dependency :withdraw, Account::Client::Withdraw

      def configure
        Account::Client::Withdraw.configure(self)
      end

      category :funds_transfer

      handle Initiated do |initiated|
        # TODO Send Withdraw command to the Account component using account client
      end
    end
  end
end
