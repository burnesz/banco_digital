class AddIdContaToAgenda < ActiveRecord::Migration[7.1]
  def change
    add_column :agendas, :id_conta, :integer
  end
end
