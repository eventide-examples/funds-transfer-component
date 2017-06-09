require_relative 'exercise_init'

funds_transfer_id = Identifier::UUID::Random.get
account_id = Identifier::UUID::Random.get

account_withdrawn = Account::Client::Messages::Events::Withdrawn.new

funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"
account_withdrawn.metadata.correlation_stream_name = funds_transfer_stream_name

account_stream_name = "account-#{account_id}"

account_withdrawn.withdrawal_id = Identifier::UUID::Random.get
account_withdrawn.account_id = Identifier::UUID::Random.get
account_withdrawn.amount = 11
account_withdrawn.time = '2000-01-01T11:11:11.000Z'
account_withdrawn.processed_time = '2000-01-01T22:22:22.000Z'

pp account_withdrawn

Messaging::Postgres::Write.(account_withdrawn, account_stream_name)

MessageStore::Postgres::Read.(account_stream_name) do |message_data|
  Handlers::Account::Events.(message_data)
  pp message_data
end
