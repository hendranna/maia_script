class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :lastname
      t.string :firstname

      t.timestamps
    end
  end
end
