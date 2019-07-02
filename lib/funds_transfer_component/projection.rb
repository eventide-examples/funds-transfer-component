module FundsTransferComponent
  class Projection
    include EntityProjection
    include Messages::Events

    entity_name :funds_transfer

    apply Initiated do |initiated|
      SetAttributes.(funds_transfer, initiated, copy: [
        { :funds_transfer_id => :id },
        :withdrawal_account_id,
        :deposit_account_id,
        :withdrawal_id,
        :deposit_id,
        :amount
      ])

      initiated_time = Clock.parse(initiated.time)

      funds_transfer.initiated_time = initiated_time
    end

    apply Withdrawn do |withdrawn|
      funds_transfer.id = withdrawn.funds_transfer_id

      withdrawn_time = Clock.parse(withdrawn.time)
      funds_transfer.withdrawn_time = withdrawn_time
    end

    apply Deposited do |deposited|
      funds_transfer.id = deposited.funds_transfer_id

      deposited_time = Clock.parse(deposited.time)
      funds_transfer.deposited_time = deposited_time
    end

    apply Transferred do |transferred|
      funds_transfer.id = transferred.funds_transfer_id

      transferred_time = Clock.parse(transferred.time)
      funds_transfer.transferred_time = transferred_time
    end
  end
end
