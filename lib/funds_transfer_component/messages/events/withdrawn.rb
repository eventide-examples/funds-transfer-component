module FundsTransferComponent
  module Messages
    module Events
      class Withdrawn
        include Messaging::Message

        attribute :funds_transfer_id, String
        attribute :withdrawal_id, String
        attribute :account_id, String
        attribute :amount, Numeric
        attribute :time, String
        attribute :processed_time, String
      end
    end
  end
end
