class AdjustDeletedAtToDateTime < ActiveRecord::Migration[5.1]
  def change
    remove_column :matchups, :deleted_at
    rename_column :matchups, :deleted_temp, :deleted_at
  end
end
