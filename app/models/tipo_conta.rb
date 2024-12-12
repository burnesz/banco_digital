class TipoConta < ApplicationRecord
    self.table_name = 'tipo_contas'
    has_many :contas
  
    validates :descricao, presence: true
  end
  