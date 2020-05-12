class SetDriverStatusDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :drivers, :available, from: false, to: true
  end
end
