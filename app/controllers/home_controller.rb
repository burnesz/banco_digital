class HomeController < ApplicationController
   def index
   end
   def registrarSe
   end
   def registrar

      nome = params[:nome]
      sobrenome = params[:sobrenome]
      cpf = params[:cpf]
      senha = params[:senha]
      agencia_id = params[:agencia].to_i
      tipo_conta_id = params[:tipo_conta].to_i
      pdf = params[:pdf]

      cliente = Cliente.find_by(cpf: cpf)

      if cliente
         redirect_to "/registrarSe?erro=1"

      elsif nome && sobrenome && cpf && senha && agencia_id && tipo_conta_id
         agencia = Agencia.find_by(id: agencia_id)
         tipo_conta = TipoConta.find_by(id: tipo_conta_id)

         cliente_new = Cliente.new(nome: nome + ' ' + sobrenome, cpf: cpf, senha: senha, agencia: agencia, pdf: pdf)
         cliente_new.save

         conta = Conta.new(numeroConta: cpf.slice(0, 5), idCliente: cliente.id, idTipoConta: tipo_conta.id, idAgencia: agencia.id, saldo: 0.00)
         conta.save

         redirect_to root_path+'?registro=1'
      else
         redirect_to "/registrarSe?erro=2"
      end

   end
end