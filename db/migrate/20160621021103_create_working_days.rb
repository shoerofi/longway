class CreateWorkingDays < ActiveRecord::Migration
  def change
    create_table :working_days do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end