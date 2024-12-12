class CreateAgencias < ActiveRecord::Migration[7.1]
  def change
    create_table :agencias do |t|
      t.string :nome
      t.string :endereco

      t.timestamps
    end
  end
end
