module FundsTransferComponent
  module Controls
    module Withdrawal
      def self.id
        ID.example(increment: id_increment)
      end

      def self.id_increment
        11111
      end

      module Account
        def self.id
          ID.example(increment: id_increment)
        end

        def self.id_increment
          1111
        end
      end
    end
  end
end
