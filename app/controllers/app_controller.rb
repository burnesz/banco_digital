class AppController < ApplicationController
    before_action :verificar_autenticacao
    def agendamento
        if params[:acao] == ''
            begin
                Agenda.create!(data: params[:data], descricao: params[:descricao], valor: params[:valor], id_conta: session[:id_conta])    
            rescue ActiveRecord::RecordInvalid => e
                flash[:title] = 'Erro'
                flash[:message] = 'Preencha todos os campos'
                flash[:classe] = 'danger'
            ensure
                redirect_to agenda_path
            end
        elsif params[:acao] == 'editar'
            agenda = Agenda.find_by(id: params[:id])
            begin
                agenda = Agenda.find_by(id: params[:id])
                agenda.update!(data: params[:data], descricao: params[:descricao], valor: params[:valor]) 
            rescue ActiveRecord::RecordInvalid => e
                flash[:title] = 'Erro'
                flash[:message] = 'Algo deu errado'
                flash[:classe] = 'danger'
            ensure
                redirect_to agenda_path
            end
        elsif params[:acao] == 'excluir'
            agenda = Agenda.find_by(id: params[:id])
            agenda.destroy
            redirect_to agenda_path
        end
    end
    def agenda
        @agendas = Agenda.where('agendas.id_conta = ?', session[:id_conta]).all.page(params[:page]).per(5)
    end
    def pdf_extrato
        if params[:categoria]
            @extratos = query_extrato_where(params)
        else
            @extratos = all_extratos
        end

        pdf = Prawn::Document.new
        pdf.text 'Extrato Transações', size: 20, style: :bold, align: :center
        pdf.move_down 20
      
        dados = [
          ["Data", "Nome Remetente", "Nome Destinatario", "Valor"]
        ]
        @extratos.each do |extrato|
            dados << [extrato.data.strftime('%d/%m/%Y %H:%M:%S'), extrato.nome_remetente, extrato.nome_destinatario, extrato.valor]
        end
        puts dados.inspect
    
        pdf.table(dados, header: true, width: pdf.bounds.width) do |t|
          t.row(0).font_style = :bold 
          t.row(0).background_color = 'cccccc' 
          t.cells.padding = 8 
          t.cells.border_width = 0 

          t.rows(1..-1).background_color = 'f0f0f0'
        end
      
        send_data(pdf.render, filename: "extrato.pdf", type: "application/pdf", disposition: "inline")
    end
    def csv_extrato

        @extratos = all_extratos
    
        csv_data = CSV.generate(headers: true) do |csv|

          csv << ["Data", "Nome Remetente", "Nome Destinatario", "Valor"]
          
          @extratos.each do |extrato|
            csv << [extrato.data.strftime('%d/%m/%Y %H:%M:%S'), extrato.nome_remetente, extrato.nome_destinatario, extrato.valor]
          end
        end
    
        send_data(csv_data, filename: "relatorio_trasacaoes.csv", type: 'text/csv')
    end

    def home

        @extratos = all_extratos(3)
        @conta = Conta.find(session[:id_conta])
        @tipo_conta = TipoConta.find(@conta.idTipoConta)

    end
    
    def conta

        @cliente = Cliente.find_by(id: session[:id])
        @conta_c = Conta.find_by(idCliente: session[:id], idTipoConta: 1)
        @conta_p = Conta.find_by(idCliente: session[:id], idTipoConta: 2)
        @agencia = Agencia.find_by(id: @conta_c.idAgencia)

    end
      
    def extrato

        if params[:categoria]
            @extratos = query_extrato_where(params)
        else
            @extratos = all_extratos.page(params[:page]).per(5)
        end
        
    end
    def buscaCliente
        cliente = Cliente.find_by(cpf: params[:cpf])
        if cliente.present? && cliente.id != session[:id]
            flash[:cpf] = params[:cpf]
            redirect_to home_path(nome_pix: cliente.nome)
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
            ActiveRecord::Base.transaction do
                conta_destino = Conta.joins(:cliente).where(cliente: { cpf: cpf }, idTipoConta: 1).first
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

    def fazer_deposito
        valor = params[:valor].to_f
        conta_remetente = Conta.joins(:cliente).where(cliente: { id: session[:id] }, idTipoConta: 1).first

        if conta_remetente.saldo >= valor
            ActiveRecord::Base.transaction do
                conta_destino = Conta.joins(:cliente).where(cliente: { id: session[:id] }, idTipoConta: 2).first
                conta_remetente.update!(saldo: conta_remetente.saldo - valor)
                conta_destino.update!(saldo: conta_destino.saldo + valor)

                Extrato.create!(idRemetente: conta_remetente.id, idDestinatario: conta_destino.id, valor: valor, tipo: 'E')
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
    def all_extratos(limite = nil)
        query = Extrato
                  .select(
                    'extratos.created_at AS data',
                    'extratos.idRemetente as idRemetente',
                    'extratos.idDestinatario as idDestinatario',
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
    def converte_data(data)
        Date.strptime(data, "%d/%m/%Y").strftime("%Y-%m-%d").to_s
    end
    def query_extrato_where(params)

        if params[:categoria] == '1'
            all_extratos.where('extratos.created_at > ? AND extratos.created_at < ?', converte_data(params[:search])+' 00:00:00.000000', converte_data(params[:search])+' 23:59:59.999999').page(params[:page]).per(5)
        elsif params[:categoria] == '2'
            all_extratos.where('LOWER(cr.nome) LIKE LOWER(?)', "%#{params[:search]}%").page(params[:page]).per(5)
        elsif params[:categoria] == '3'
            all_extratos.where('LOWER(cd.nome) LIKE LOWER(?)', "%#{params[:search]}%").page(params[:page]).per(5)
        elsif params[:categoria] == '4'
            all_extratos.where('extratos.valor = ?',params[:search]).page(params[:page]).per(5)
        end
    end

end