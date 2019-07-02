require_relative 'exercise_init'

funds_transfer_id = Identifier::UUID::Random.get

deposited = Messages::Events::Deposited.new
deposited.funds_transfer_id = funds_transfer_id
deposited.deposit_id = Identifier::UUID::Random.get
deposited.account_id = Identifier::UUID::Random.get
deposited.amount = 11
deposited.time = '2000-01-01T11:11:11.000Z'
deposited.processed_time = '2000-01-01T22:22:22.000Z'

pp deposited

stream_name = "fundsTransfer-#{funds_transfer_id}"

Messaging::Postgres::Write.(deposited, stream_name)

MessageStore::Postgres::Read.(stream_name) do |message_data|
  Handlers::Events.(message_data)
  pp message_data
end
