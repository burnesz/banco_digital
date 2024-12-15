class Agenda < ApplicationRecord
    self.table_name = 'agendas'
    belongs_to :conta, foreign_key: 'id_conta'

    validates :data, presence: true
    validates :descricao, presence: true
    validates :valor, presence: true
  end
  