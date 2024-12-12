class AppController < ApplicationController
    before_action :verificar_autenticacao
    def home
    end
    def extrato
    end
    private
    def verificar_autenticacao
        unless session[:id]
            redirect_to root_path
        end
    end
 end
 