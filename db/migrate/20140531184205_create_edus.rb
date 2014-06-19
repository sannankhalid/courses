class CreateEdus < ActiveRecord::Migration
  def change
    create_table :edus do |t|
      t.string :current_education_level
      t.string :resume

      t.timestamps
    end
  end
end
