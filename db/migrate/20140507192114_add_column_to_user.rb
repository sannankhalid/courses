class AddColumnToUser < ActiveRecord::Migration
  def change
  	add_column :users,:user_type,:string
  end
end
