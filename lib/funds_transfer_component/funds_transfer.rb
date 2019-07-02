module FundsTransferComponent
  class FundsTransfer
    include Schema::DataStructure

    attribute :id, String
    attribute :withdrawal_account_id, String
    attribute :deposit_account_id, String
    attribute :withdrawal_id, String
    attribute :deposit_id, String
    attribute :amount, Numeric
    attribute :initiated_time, Time
    attribute :withdrawn_time, Time
    attribute :deposited_time, Time

    def initiated?
      !initiated_time.nil?
    end

    def withdrawn?
      !withdrawn_time.nil?
    end

    def deposited?
      !deposited_time.nil?
    end
  end
end
