class RemoveDeviseFromClientes < ActiveRecord::Migration[7.1]
  def change
    remove_column :clientes, :email, :string, if_exists: true
    remove_column :clientes, :encrypted_password, :string, if_exists: true
    remove_column :clientes, :reset_password_token, :string, if_exists: true
    remove_column :clientes, :reset_password_sent_at, :datetime, if_exists: true
    remove_column :clientes, :remember_created_at, :datetime, if_exists: true
    remove_index :clientes, name: 'index_clientes_on_email', if_exists: true
    remove_index :clientes, name: 'index_clientes_on_reset_password_token', if_exists: true
  end
end
