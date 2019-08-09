class ChangeDefPercentageColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :stats, "def_3rd_per", "def_3rd_pct"
  end
end
