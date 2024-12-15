class AuthController < ApplicationController

    def authenticar
        cpf = params[:cpf]
        senha = params[:senha]
        conta = params[:tipo_conta]
        
        cliente = Cliente.find_by(cpf: cpf)
        if cliente.nil?
            flash[:title] = 'Erro'
            flash[:message] = 'CPF ou senha incorretos'
            flash[:classe] = 'danger'
            redirect_to root_path
        elsif cpf.blank? || senha.blank? || conta.blank?
            flash[:title] = 'Espaço em branco'
            flash[:message] = 'Preencha CPF, senha e conta para entrar'
            flash[:classe] = 'danger'
            redirect_to root_path
        else
            conta = Conta.find_by(idCliente: cliente.id, idTipoConta: params[:tipo_conta])
            if cliente.present? && conta.present? && cliente.senha === senha
                session[:id] = cliente.id
                session[:nome] = cliente.nome
                session[:id_conta] = conta.id
                redirect_to home_path
            else
                flash[:title] = 'Erro'
                flash[:message] = 'CPF ou Senha incorretas'
                flash[:classe] = 'danger'
                redirect_to root_path
            end
        end
    end

    def sair
        session.delete(:id)
        redirect_to root_path
    end

end