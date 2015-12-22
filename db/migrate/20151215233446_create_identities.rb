class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :provider, index: true
      t.string :uid, index: true
      t.references :user, index: true

      t.timestamps null: false

      t.index [:provider, :uid], unique: true
    end
  end
end
