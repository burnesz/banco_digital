class AuthController < ApplicationController

    def authenticar
        cpf = params[:cpf]
        senha = params[:senha]

        cliente = Cliente.find_by(cpf: cpf)

        if cliente.present? && cliente.senha === senha
            session[:id] = cliente.id
            session[:nome] = cliente.nome
            redirect_to home_path
        elsif cpf.blank? || senha.blank?
            flash[:title] = 'Espaço em branco'
            flash[:message] = 'Preencha CPF e senha para entrar'
            flash[:classe] = 'danger'
            redirect_to root_path
        else
            flash[:title] = 'Erro'
            flash[:message] = 'CPF ou senha incorretos'
            flash[:classe] = 'danger'
            redirect_to root_path
        end
     end

    def sair
        session.delete(:id)
        redirect_to root_path
    end

end