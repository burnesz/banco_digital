class AddPdfToClientes < ActiveRecord::Migration[7.1]
  def change
    add_column :clientes, :pdf, :string
  end
end
