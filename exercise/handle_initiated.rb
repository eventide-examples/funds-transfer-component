require_relative 'exercise_init'

funds_transfer_id = Identifier::UUID::Random.get

initiated = Messages::Events::Initiated.new
initiated.funds_transfer_id = funds_transfer_id
initiated.withdrawal_account_id = Identifier::UUID::Random.get
initiated.withdrawal_id = Identifier::UUID::Random.get
initiated.amount = 11
initiated.time = '2000-01-01T11:11:11.000Z'
initiated.processed_time = '2000-01-01T22:22:22.000Z'

pp initiated

stream_name = "fundsTransfer-#{funds_transfer_id}"

Messaging::Postgres::Write.(initiated, stream_name)

MessageStore::Postgres::Read.(stream_name) do |message_data|
  Handlers::Events.(message_data)
  pp message_data
end
