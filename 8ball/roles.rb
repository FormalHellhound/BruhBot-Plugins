db = SQLite3::Database.new 'db/server.db'
if BruhBot.conf['first_run'] == 1 ||
   BruhBot.db_version < BruhBot.git_db_version
  db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', '8ball')
end

eightball_string = db.execute(
  'SELECT roles FROM perms WHERE command = ?', 'update'
)[0][0]
eightball_roles = eightball_string.split(',').map(&:to_i) unless eightball_string.nil? # else update_roles = []

db.close if db