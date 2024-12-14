class ChangeValorToBeFloatInExtratos < ActiveRecord::Migration[7.1]
  def change
    change_column :extratos, :valor, :float
  end
end
