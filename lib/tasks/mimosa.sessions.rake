namespace :sessions do

  desc 'Count database sessions'
  task :count => :environment do
    count = CGI::Session::ActiveRecordStore::Session.count
    puts "Sessions stored: #{count}"
  end

  desc 'Clear database stored sessions older than two weeks'
  task :prune => :environment do
    CGI::Session::ActiveRecordStore::Session.delete all [
      "updated at < ?", 2.weeks.ageo
    ]
  end

end
