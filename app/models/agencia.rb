class Agencia < ApplicationRecord
    self.table_name = 'agencias'
    has_many :clientes
    has_many :contas
  
    validates :nome, presence: true
    validates :endereco, presence: true
  end
  