class CreateCreateAgendas < ActiveRecord::Migration[7.1]
  def change
    create_table :create_agendas do |t|
      t.string :descricao
      t.float :valor

      t.timestamps
    end
  end
end
