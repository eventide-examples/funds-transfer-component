require_relative './interactive_init'

funds_transfer_id = Identifier::UUID::Random.get

withdrawal_account_id = '123'
deposit_account_id = '456'

amount = 11

Controls::Write::Transfer.(
  id: funds_transfer_id,
  withdrawal_account_id: withdrawal_account_id,
  deposit_account_id: deposit_account_id,
  amount: amount
)
