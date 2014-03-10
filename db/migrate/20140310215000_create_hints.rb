class CreateHints < ActiveRecord::Migration
  def up
    create_table :hints do |t|
      t.string  :regex
      t.integer :category_id
    end
  end

  def down
    drop_table :hints
  end
end