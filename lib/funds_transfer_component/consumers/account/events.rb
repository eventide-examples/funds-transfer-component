module FundsTransferComponent
  module Consumers
    module Account
      class Events
        include Consumer::Postgres

        identifier 'fundsTransfer'

        handler Handlers::Account::Events
      end
    end
  end
end
