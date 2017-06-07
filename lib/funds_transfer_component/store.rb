module FundsTransferComponent
  class Store
    include EntityStore

    category :funds_transfer
    entity FundsTransfer
    projection Projection
    reader MessageStore::Postgres::Read
  end
end
