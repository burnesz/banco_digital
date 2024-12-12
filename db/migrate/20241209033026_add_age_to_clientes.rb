class AddAgeToClientes < ActiveRecord::Migration[7.1]
  def change
    add_column :clientes, :senha, :string
  end
end
