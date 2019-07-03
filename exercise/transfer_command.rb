require_relative './exercise_init'

withdrawal_account_id = Identifier::UUID::Random.get
deposit_account_id = Identifier::UUID::Random.get

class SomeMessage
  include Messaging::Message
end

some_message = SomeMessage.new

metadata = some_message.metadata
metadata.source_message_stream_name = 'someMessage-some_id'
metadata.source_message_position = 111

transfer = FundsTransferComponent::Commands::Transfer.(
  withdrawal_account_id: withdrawal_account_id,
  deposit_account_id: deposit_account_id,
  amount: 11,
  previous_message: some_message
)

funds_transfer_command_stream_name = "fundsTransfer:command-#{transfer.funds_transfer_id}"

MessageStore::Postgres::Read.(funds_transfer_command_stream_name) do |message_data|
  pp message_data
end
