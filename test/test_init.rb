ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= '_min'

puts RUBY_DESCRIPTION

require_relative '../init.rb'

require 'test_bench'; TestBench.activate

require 'pp'

require 'funds_transfer_component/controls'

module FundsTransferComponent; end
include FundsTransferComponent
