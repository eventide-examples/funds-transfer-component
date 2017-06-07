require_relative 'exercise_init'

funds_transfer_id = Identifier::UUID::Random.get

transfer = Messages::Commands::Transfer.new
transfer.funds_transfer_id = funds_transfer_id
transfer.withdrawal_account_id = Identifier::UUID::Random.get
transfer.deposit_account_id = Identifier::UUID::Random.get
transfer.amount = 11
transfer.time = '2000-01-01T11:11:11.000Z'

pp transfer

command_stream_name = "fundsTransfer:command-#{funds_transfer_id}"

Messaging::Postgres::Write.(transfer, command_stream_name)

MessageStore::Postgres::Read.(command_stream_name) do |message_data|
  Handlers::Commands.(message_data)
  pp message_data
end
