class AddHide < ActiveRecord::Migration
  def change
    add_column :transactions, :hidden, :boolean, :null => false, :default => false
  end
end