class MakeHintUnique < ActiveRecord::Migration
  def change
    add_index :hints, :regex, :unique => true
  end
end