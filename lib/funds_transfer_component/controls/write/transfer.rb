module FundsTransferComponent
  module Controls
    module Write
      module Transfer
        def self.call(id: nil, withdrawal_account_id: nil, deposit_account_id: nil, amount: nil)
          id ||= FundsTransfer.id
          withdrawal_account_id ||= Withdrawal::Account.id
          deposit_account_id ||= Deposit::Account.id
          amount ||= Money.example

          transfer = Commands::Transfer.example(
            id: id,
            withdrawal_account_id: withdrawal_account_id,
            deposit_account_id: deposit_account_id,
            amount: amount
          )

          stream_name = Messaging::StreamName.command_stream_name(id, 'fundsTransfer')

          Messaging::Postgres::Write.(transfer, stream_name)
        end
      end
    end
  end
end
