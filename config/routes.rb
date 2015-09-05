Rails.application.routes.draw do
  root to: "homes#index"
  get '/data', to: "homes#data"
end
