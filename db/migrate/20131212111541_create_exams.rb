class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.integer :patient_id

      t.timestamps
    end
  end
end
