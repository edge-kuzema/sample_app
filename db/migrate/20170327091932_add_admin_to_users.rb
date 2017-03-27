class AddAdminToUsers < ActiveRecord::Migration[5.0]

  #пользователи по умолчанию не будут являться администраторами
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
