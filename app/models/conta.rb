class Conta < ApplicationRecord
    self.table_name = 'contas'
    belongs_to :cliente, foreign_key: 'idCliente'
    belongs_to :tipo_conta, foreign_key: 'idTipoConta'
    belongs_to :agencia, foreign_key: 'idAgencia'

    validates :numeroConta, presence: true, uniqueness: true
    validates :saldo, presence: true, numericality: { greater_than_or_equal_to: 0 }
  end