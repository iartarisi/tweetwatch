require 'active_record'

ActiveRecord::Base.configurations = YAML::load(IO.read('database.yml'))


class Schema < ActiveRecord::Migration
  def setup
    create_table :tweets do |t|
      t.integer :tweet_id, null: false, limit: 8  # 64bit int
      t.string :text
      t.datetime :created_at
      t.index :created_at
    end
  end

  def teardown
    drop_table :tweets
  end
end

class Tweet < ActiveRecord::Base
end
