module BruhBot
  module Plugins
    # Leveling plugin
    module Levels
      require './roles.rb' if BruhBot::Plugins.const_defined?(:Permissions)
      if BruhBot.conf['first_run'] == 1 ||
         BruhBot.db_version < BruhBot.git_db_version
        require "#{__dir__}/database.rb"
      end

      extend Discordrb::EventContainer

      levels_config = Yajl::Parser.parse(
        File.new("#{__dir__}/config.json", 'r')
      )

      BruhBot.bot.ready do |event|
        db = SQLite3::Database.new 'db/server.db'
        event.bot.servers.keys.each do |s|
          event.bot.server(s).members.each do |m|
            db.execute('INSERT OR IGNORE INTO levels (userid, level, xp) '\
                       'VALUES (?, ?, ?)', m.id, 1, 0)
          end
        end
        db.close if db
      end

      member_join do |event|
        break if event.channel.private?
        db = SQLite3::Database.new 'db/server.db'

        db.execute('INSERT OR IGNORE INTO levels (userid, level, xp) '\
                   'VALUES (?, ?, ?)', event.user.id, 1, 0)
      end

      ##########################################################################

      message do |event|
        break if event.channel.private?
        db = SQLite3::Database.new 'db/server.db'

        #db.execute('INSERT OR IGNORE INTO levels (userid, level, xp) VALUES (?, ?, ?)', [event.user.id, 1, 0])
        db.results_as_hash = true

        hash = db.execute('SELECT * FROM levels '\
                          'WHERE userid = (?)', event.user.id)[0]

        mlength = event.message.content.length.round_to(5)
        totalxp = hash['xp'] + mlength
        requiredxp = hash['level'] * 2 * 500

        db.results_as_hash = false

        if totalxp < requiredxp

          db.execute('UPDATE levels SET xp = (?) '\
                     'WHERE userid = (?)', totalxp, event.user.id)

        elsif totalxp >= requiredxp

          finalxp = (totalxp - requiredxp)
          level = (hash['level'] + 1)
          db.execute('UPDATE levels Set level = (?), xp = (?) '\
                     'WHERE userid = (?)', level, finalxp, event.user.id)

          unless levels_config[level].nil?
            member = event.server.member(event.user.id)
            member.add_role(levels_config[level])
          end
        end
        db.close if db
      end

      # COMMANDS

      extend Discordrb::Commands::CommandContainer

      command(
        :level, max_args: 0,
        permitted_roles: Roles.level_roles,
        description: 'Check your level',
        usage: 'level'
      ) do |event|
        break event.respond BruhBot.conf['dm_error'] if event.channel.private?
        db = SQLite3::Database.new 'db/server.db'
        level = db.execute('SELECT level FROM levels '\
                           'WHERE userid = (?)', event.user.id)[0][0]
        event.respond("Your level is #{level}")
      end
    end
  end
end
