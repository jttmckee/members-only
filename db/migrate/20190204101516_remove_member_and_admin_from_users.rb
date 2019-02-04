class RemoveMemberAndAdminFromUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.remove :admin, :boolean
      t.remove :member, :boolean
    end
  end
end
