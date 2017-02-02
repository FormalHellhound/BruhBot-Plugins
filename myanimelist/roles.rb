db = SQLite3::Database.new 'db/server.db'

if BruhBot.conf['first_run'] == 1 ||
   BruhBot.db_version < BruhBot.git_db_version
  db.execute('INSERT OR IGNORE INTO perms (command) '\
             'VALUES (?), (?)', 'anime', 'manga')
end

anime_string = db.execute(
  'SELECT roles FROM perms WHERE command = ?', 'anime'
)[0][0]
anime_roles = anime_string.split(',').map(&:to_i) unless anime_string.nil? # else update_roles = []

manga_string = db.execute(
  'SELECT roles FROM perms WHERE command = ?', 'manga'
)[0][0]
manga_roles = manga_string.split(',').map(&:to_i) unless manga_string.nil? # else update_roles = []

db.close if db