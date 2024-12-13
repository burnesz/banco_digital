class CreateExtratos < ActiveRecord::Migration[7.1]
  def change
    create_table :extratos do |t|
      t.integer :idRemetente
      t.integer :idDestinatario
      t.decimal :valor
      t.string :tipo

      t.timestamps
    end
  end
end
