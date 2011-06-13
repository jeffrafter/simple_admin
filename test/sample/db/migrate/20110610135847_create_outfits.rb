class CreateOutfits < ActiveRecord::Migration
  def change
    create_table :outfits do |t|
      t.string :kind
      t.integer :thing_id

      t.timestamps
    end
  end
end
