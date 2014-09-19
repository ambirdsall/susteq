class ChangeTransactionsTable < ActiveRecord::Migration
  def change
    change_column :transactions, :rfid_id, :string
  end
end
