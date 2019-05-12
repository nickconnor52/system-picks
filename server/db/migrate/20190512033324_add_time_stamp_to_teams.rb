class AddTimeStampToTeams < ActiveRecord::Migration[5.1]
  def change
    change_table(:teams) do |t|
      # add new column but allow null values
      add_timestamps :teams, null: true

      # backfill existing record with created_at and updated_at
      # values making clear that the records are faked
      creation_date = DateTime.new(2018, 8, 1)
      Team.update_all(created_at: creation_date, updated_at: creation_date)

      # change not null constraints
      change_column_null :teams, :created_at, false
      change_column_null :teams, :updated_at, false
    end
  end
end
