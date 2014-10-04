#!/usr/bin/env ruby

require 'active_record'
require 'logger'

ActiveRecord::Base.logger = Logger.new('debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read('database.yml'))
ActiveRecord::Base.establish_connection :development


class Schema < ActiveRecord::Migration
  def setup
    create_table :tweets, id: false do |t|
      t.integer :id
      t.string :text
      t.datetime :created_at
      t.index :created_at
    end
  end

  def teardown
    drop_table :tweets
  end
end

Schema.migrate(ARGV[0])
