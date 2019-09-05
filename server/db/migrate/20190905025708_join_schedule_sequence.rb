class JoinScheduleSequence < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      ALTER SEQUENCE schedule_id_seq OWNED BY schedules.schedule_id;
      ALTER TABLE schedules ALTER COLUMN schedule_id SET DEFAULT nextval('schedule_id_seq');
    SQL
  end

  def down
    execute <<-SQL
      ALTER SEQUENCE schedule_id_seq OWNED BY NONE;
      ALTER TABLE schedules ALTER COLUMN schedule_id SET NOT NULL;
    SQL
  end
end
