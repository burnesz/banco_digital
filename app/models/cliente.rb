class Cliente < ApplicationRecord
    mount_uploader :pdf, PdfUploader
    self.table_name = 'clientes'
    belongs_to :agencia, foreign_key: 'idAgencia'
    has_many :contas, foreign_key: 'idCliente'

    validates :nome, presence: true
    validates :cpf, presence: true, uniqueness: true
    validates :senha, presence: true
end
