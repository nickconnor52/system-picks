class UpdateNameOfDeletedAtColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :matchups, :deleted, :deleted_at
  end
end
