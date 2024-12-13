class AppController < ApplicationController
    before_action :verificar_autenticacao
    def home
    end
    def extrato
    end
    def buscaCliente
        cliente = Cliente.find_by(cpf: params[:cpf])
        if cliente.present?
            flash[:nome_pix] = cliente.nome
            flash[:cpf] = params[:cpf]
            redirect_to home_path
        end 
    end
    def fazer_pix
        valor = params[:valor].to_f
        cpf = params[:cpf]

        conta_remetente = Conta.joins(:cliente).where(cliente: { id: session[:id] }, idTipoConta: 1).first

        if conta_remetente.saldo >= valor
            conta_destino = Conta.joins(:cliente).where(cliente: { cpf: cpf }, idTipoConta: 1).first
            ActiveRecord::Base.transaction do
                conta_remetente.update!(saldo: conta_remetente.saldo - valor)
                conta_destino.update!(saldo: conta_destino.saldo + valor)

                Extrato.create!(idRemetente: conta_remetente.id, idDestinatario: conta_destino.id, valor: valor, tipo: 'S')
            end
            redirect_to home_path
        else
            flash[:title] = 'Erro'
            flash[:message] = 'Você não tem saldo suficiente'
            flash[:classe] = 'danger'
            redirect_to home_path
        end
    end
    private
    def verificar_autenticacao
        unless session[:id]
            redirect_to root_path
        end
    end
 end
 