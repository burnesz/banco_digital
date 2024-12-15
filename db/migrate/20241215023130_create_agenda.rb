class CreateAgenda < ActiveRecord::Migration[7.1]
  def change
    create_table :agendas do |t|
      t.date :data
      t.string :descricao
      t.float :valor

      t.timestamps
    end
  end
end
