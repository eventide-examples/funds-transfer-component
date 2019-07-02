module FundsTransferComponent
  module Messages
    module Events
      class Initiated
        include Messaging::Message

        attribute :funds_transfer_id, String
        attribute :withdrawal_account_id, String
        attribute :deposit_account_id, String
        attribute :withdrawal_id, String
        attribute :deposit_id, String
        attribute :amount, Numeric
        attribute :time, String
        attribute :processed_time, String
      end
    end
  end
end
