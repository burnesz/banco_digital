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
      pdf = params[:pdf]

      cliente = Cliente.find_by(cpf: cpf)

      if Cliente.exists?(cpf: cpf)
         flash[:title] = 'Você já é nosso cliente'
         flash[:message] = 'Entre com seu  CPF e senha criada anteriormente'
         flash[:classe] = 'danger'
         redirect_to registrarSe_path
         return
      end

      if valid_params?(nome, sobrenome, cpf, senha, agencia_id)
         agencia = Agencia.find_by(id: agencia_id)

         cliente_new = Cliente.create(nome: "#{nome} #{sobrenome}", cpf: cpf, senha: senha, agencia: agencia, pdf: pdf)
         
         conta_c = Conta.create(numeroConta: "#{cpf.slice(0, 5)}-1", idCliente: cliente_new.id, idTipoConta: 1, idAgencia: agencia.id, saldo: 0.00)
         conta_c.save
         conta_p = Conta.create(numeroConta: "#{cpf.slice(0, 5)}-2", idCliente: cliente_new.id, idTipoConta: 2, idAgencia: agencia.id, saldo: 0.00)
         conta_p.save


         flash[:title] = 'Registro feito com sucesso'
         flash[:message] = 'Entre com seu CPF e senha'
         flash[:classe] = 'success'
         redirect_to root_path
      else
         flash[:title] = 'Erro'
         flash[:message] = 'Preencha todos os campos para prosseguir'
         flash[:classe] = 'danger'
         redirect_to registrarSe_path
      end

   end

   def valid_params?(nome, sobrenome, cpf, senha, agencia_id)
      nome.present? && sobrenome.present? && cpf.present? && senha.present? && agencia_id > 0
   end
   
end