class CreateContas < ActiveRecord::Migration[7.1]
  def change
    create_table :contas do |t|
      t.string :numeroConta
      t.decimal :saldo
      t.integer :idCliente
      t.integer :idTipoConta
      t.integer :idAgencia

      t.timestamps
    end
  end
end
