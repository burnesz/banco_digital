Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
  get "registrarSe", to: "home#registrarSe"
  get "home", to: "app#home"
  get "conta", to: "app#conta"
  get "extrato", to: "app#extrato"
  get "sair", to: "auth#sair"
  post "authenticar", to: "auth#authenticar"
  post "registrar", to: "home#registrar"
  post 'buscaCliente', to: 'app#buscaCliente'
  post 'fazer_pix', to: 'app#fazer_pix'
  get 'pdf_extrato', to: 'app#pdf_extrato'
  get 'csv_extrato', to: 'app#csv_extrato'
  get 'agenda', to: 'app#agenda'
  post 'agendamento', to: 'app#agendamento'

  
  # Defines the root path route ("/")
  # root "posts#index"
end
