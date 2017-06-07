module FundsTransferComponent
  module Messages
    module Commands
      class Transfer
        include Messaging::Message

        attribute :funds_transfer_id, String
        attribute :withdrawal_account_id, String
        attribute :deposit_account_id, String
        attribute :amount, Numeric
        attribute :time, String
      end
    end
  end
end
