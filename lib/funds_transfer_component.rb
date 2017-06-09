require 'eventide/postgres'
require 'account/client'

require 'funds_transfer_component/messages/commands/transfer'

require 'funds_transfer_component/messages/events/initiated'
require 'funds_transfer_component/messages/events/withdrawn'

require 'funds_transfer_component/funds_transfer'
require 'funds_transfer_component/projection'
require 'funds_transfer_component/store'

require 'funds_transfer_component/handlers/commands'
require 'funds_transfer_component/handlers/events'
require 'funds_transfer_component/handlers/account/events'

require 'funds_transfer_component/consumers/commands'
require 'funds_transfer_component/consumers/events'
require 'funds_transfer_component/consumers/account/events'

require 'funds_transfer_component/start'
