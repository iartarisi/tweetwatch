task :_database do
  require_relative 'lib/schema'
  require 'active_record'

  ActiveRecord::Base.establish_connection :development
end

task :db_setup => :_database do
  Schema.migrate(:setup)
end

task :db_teardown => :_database do
  Schema.migrate(:teardown)
end

task :track_tweets do
  sh %{bundle exec ruby -Ilib bin/tweetwatch}
end

task :server do
  sh %{bundle exec puma -Ilib config.ru -p 9292}
end
