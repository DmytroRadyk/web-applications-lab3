class CreateCastles < ActiveRecord::Migration[7.2]
  def change
    create_table :castles do |t|
      t.string :name
      t.string :region
      t.string :location
      t.text :description
      t.integer :built_year
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
