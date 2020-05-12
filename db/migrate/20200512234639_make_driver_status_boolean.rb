class MakeDriverStatusBoolean < ActiveRecord::Migration[6.0]
  def change
    change_column :drivers, :available, 'boolean USING CAST(available AS boolean)'
  end
end
