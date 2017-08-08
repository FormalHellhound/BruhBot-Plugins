module BruhBot
  module Plugins
    # Eightball plugin module
    module Eightball
      extend Discordrb::Commands::CommandContainer

      # Load 8ball config file
      eightball_conf = Yajl::Parser.parse(
        File.new("#{__dir__}/config.json", 'r')
      )

      command(
        %s(8ball), min_args: 1,
        description: 'Consult the magic 8ball',
        usage: '8ball <question>'
      ) do |event|
        # Output a random message from the eightball array in the config file.
        event.respond ":8ball: #{eightball_conf['eightball'].sample}"
      end
      # End of the 8ball command.
    end
    # End of the Eightball module.
  end
end
