module BruhBot
  module Plugins
    # URL shortener plugin
    module Short
      require 'googl'
      require_relative 'roles.rb' if BruhBot::Plugins.const_defined?(:Permissions)

      extend Discordrb::Commands::CommandContainer

      command(
        :short, min_args: 1, max_args: 1,
        permitted_roles: Roles.short_roles,
        description: 'Shorten a URL with Googl.',
        usage: 'short <URL>'
      ) do |event, url|
        event.message.delete
        url = Googl.shorten(
          url, BruhBot.api['googl_ip'], BruhBot.api['googl_api_key']
        )
        event.respond url.short_url
      end
    end
  end
end
