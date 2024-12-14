class AppController < ApplicationController
    before_action :verificar_autenticacao
    def home
        @extratos = buscar_extratos(3)
    end
      
    def extrato
        @extratos = buscar_extratos.page(params[:page]).per(5)
    end
    def buscaCliente
        cliente = Cliente.find_by(cpf: params[:cpf])
        if cliente.present? && cliente.id != session[:id]
            @nome_pix = cliente.nome
            flash[:cpf] = params[:cpf]
            render :home
        else
            flash[:title] = 'Erro'
            flash[:message] = 'CPF não encontrado'
            flash[:classe] = 'danger'
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
    def buscar_extratos(limite = nil)
        query = Extrato
                  .select(
                    'extratos.created_at AS data',
                    'cr.nome AS nome_remetente',
                    'cd.nome AS nome_destinatario',
                    'extratos.valor AS valor'
                  )
                  .joins(
                    'INNER JOIN contas cr_ct ON extratos.idRemetente = cr_ct.id',
                    'INNER JOIN clientes cr ON cr_ct.idCliente = cr.id',
                    'INNER JOIN contas cd_ct ON extratos.idDestinatario = cd_ct.id',
                    'INNER JOIN clientes cd ON cd_ct.idCliente = cd.id'
                  )
                  .where('extratos.idRemetente = ? OR extratos.idDestinatario = ?', session[:id_conta], session[:id_conta])
        limite ? query.limit(limite) : query
      end
 end
 