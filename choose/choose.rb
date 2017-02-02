module BruhBot
  module Plugins
    # Choose plugin
    module Choose
      extend Discordrb::Commands::CommandContainer

      require 'roles.rb' if BruhBot::Plugins.const_defined?(:Permissions)

      # Load choose config file
      choose_conf = Yajl::Parser.parse(File.new("#{__dir__}/config.json", 'r'))

      command(
        :choose, min_args: 2, permitted_roles: choose_roles,
        description: 'Make the bot choose something randomly.',
        usage: 'choose <choice>, <choice>'
      ) do |event, *choices|

        # Output a message from the choicemessage array in the config file,
        # and insert a random choice from the ones provided
        event.respond choose_conf['choice_message'].sample % {
          choice: choices.join(' ').split(', ').sample
        }
      end
    end
  end
end
