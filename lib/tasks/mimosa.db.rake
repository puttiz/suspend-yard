
namespace :db do
  desc 'Print the current database migration version number'
  task :version => :environment do
    puts ActiveRecord::Migrator.current_version
  end

# http://quotedprintable.com/2007/6/29/rake-db-rollback
  desc 'Rolls the schema back to the previous version. Specify the number of steps with STEP=n'
  task :rollback => :environment do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    version = ActiveRecord::Migrator.current_version - step
    ActiveRecord::Migrator.migrate('db/migrate/', version)
  end
end

