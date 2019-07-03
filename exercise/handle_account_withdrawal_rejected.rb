require_relative 'exercise_init'

funds_transfer_id = Identifier::UUID::Random.get
account_id = Identifier::UUID::Random.get

account_withdrawal_rejected = Account::Client::Messages::Events::WithdrawalRejected.new

funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"
account_withdrawal_rejected.metadata.correlation_stream_name = funds_transfer_stream_name

account_stream_name = "account-#{account_id}"

account_withdrawal_rejected.withdrawal_id = Identifier::UUID::Random.get
account_withdrawal_rejected.account_id = Identifier::UUID::Random.get
account_withdrawal_rejected.amount = 11
account_withdrawal_rejected.time = '2000-01-01T11:11:11.000Z'

pp account_withdrawal_rejected

Messaging::Postgres::Write.(account_withdrawal_rejected, account_stream_name)

MessageStore::Postgres::Read.(account_stream_name) do |message_data|
  Handlers::Account::Events.(message_data)
  pp message_data
end
