require_relative 'exercise_init'

funds_transfer_id = Identifier::UUID::Random.get
account_id = Identifier::UUID::Random.get

account_deposited = Account::Client::Messages::Events::Deposited.new

funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"
account_deposited.metadata.correlation_stream_name = funds_transfer_stream_name

account_stream_name = "account-#{account_id}"

account_deposited.deposit_id = Identifier::UUID::Random.get
account_deposited.account_id = Identifier::UUID::Random.get
account_deposited.amount = 11
account_deposited.time = '2000-01-01T11:11:11.000Z'
account_deposited.processed_time = '2000-01-01T22:22:22.000Z'

pp account_deposited

Messaging::Postgres::Write.(account_deposited, account_stream_name)

MessageStore::Postgres::Read.(account_stream_name) do |message_data|
  Handlers::Account::Events.(message_data)
  pp message_data
end
