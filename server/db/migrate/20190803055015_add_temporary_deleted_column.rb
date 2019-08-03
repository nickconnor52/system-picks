class AddTemporaryDeletedColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :matchups, :deleted_temp, :datetime
  end
end
