class AddScheduleSequenceTable < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      CREATE SEQUENCE schedule_id_seq;
    SQL
  end

  def down
    execute <<-SQL
      DROP SEQUENCE schedule_id_seq;
    SQL
  end
end
