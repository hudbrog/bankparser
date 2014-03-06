class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.string :name
    end
    add_column :transactions, :category_id, :integer
  end

  def down
    drop_table :categories
    remove_column :transactions, :category_id
  end
end