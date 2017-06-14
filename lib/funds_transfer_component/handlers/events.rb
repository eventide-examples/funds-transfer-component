module FundsTransferComponent
  module Handlers
    class Events
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName
      include Messages::Commands
      include Messages::Events

      dependency :withdraw, ::Account::Client::Withdraw

      def configure
        ::Account::Client::Withdraw.configure(self)
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
        # TODO Send Deposit command to the Account component using account client
      end
    end
  end
end
