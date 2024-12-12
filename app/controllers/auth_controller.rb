class AuthController < ApplicationController

    def authenticar
        cpf = params[:cpf]
        senha = params[:senha]

        cliente = Cliente.find_by(cpf: cpf)

        if cliente && cliente.senha === senha
            session[:id] = cliente.id
            redirect_to "/home"
        elsif cpf.blank? || senha.blank?
            redirect_to root_path+'?erro=2'
        else
            redirect_to root_path+'?erro=1'
        end
     end

    def sair
        session.delete(:id)
        redirect_to root_path
    end

end