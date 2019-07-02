require_relative 'exercise_init'

funds_transfer_id = Identifier::UUID::Random.get
withdrawal_account_id = Identifier::UUID::Random.get
withdrawal_id = Identifier::UUID::Random.get
amount = 11

initiated = Messages::Events::Initiated.new
initiated.funds_transfer_id = funds_transfer_id
initiated.withdrawal_account_id = withdrawal_account_id
initiated.withdrawal_id = withdrawal_id
initiated.deposit_account_id = Identifier::UUID::Random.get
initiated.deposit_id = Identifier::UUID::Random.get
initiated.amount = amount
initiated.time = '2000-01-01T11:11:11.000Z'
initiated.processed_time = '2000-01-01T22:22:22.000Z'

pp initiated

withdrawn = Messages::Events::Withdrawn.new
withdrawn.funds_transfer_id = funds_transfer_id
withdrawn.withdrawal_id = withdrawal_id
withdrawn.account_id = withdrawal_account_id
withdrawn.amount = amount
withdrawn.time = '2000-01-01T11:11:11.000Z'
withdrawn.processed_time = '2000-01-01T22:22:22.000Z'

pp withdrawn

stream_name = "fundsTransfer-#{funds_transfer_id}"

Messaging::Postgres::Write.([initiated, withdrawn], stream_name)

MessageStore::Postgres::Read.(stream_name) do |message_data|
  Handlers::Events.(message_data)
  pp message_data
end
