db = SQLite3::Database.new 'db/server.db'

if BruhBot.conf['first_run'] == 1 ||
   BruhBot.db_version < BruhBot.git_db_version
  db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'wiki')
end

wiki_string = db.execute(
  'SELECT roles FROM perms WHERE command = ?', 'wiki'
)[0][0]
wiki_roles = wiki_string.split(',').map(&:to_i) unless wiki_string.nil? # else update_roles = []

db.close if db