require_relative '../../automated_init'

context "Handle Commands" do
  context "Transfer" do
    context "Expected Version" do
      handler = Handlers::Commands.new

      transfer = Controls::Commands::Transfer.example

      handler.(transfer)

      writer = handler.write

      initiated = writer.one_message do |event|
        event.instance_of?(Messages::Events::Initiated)
      end

      test "Is no stream" do
        written_to_stream = writer.written?(initiated) do |_, expected_version|
          expected_version == :no_stream
        end

        assert(written_to_stream)
      end
    end
  end
end
