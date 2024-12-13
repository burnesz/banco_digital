class Extrato < ApplicationRecord
  belongs_to :remetente, class_name: 'Conta', foreign_key: 'idRemetente'
  belongs_to :destinatario, class_name: 'Conta', foreign_key: 'idDestinatario'

  validates :valor, numericality: { greater_than: 0 }
  validates :tipo, inclusion: { in: ['S', 'E'], message: "must be 'S' for saída or 'E' for entrada" }
end
