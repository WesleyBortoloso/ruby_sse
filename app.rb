# app.rb

require 'sinatra'

class ListaComprasApp < Sinatra::Base
  @@lista_compras = []

  get '/' do
    erb :index
  end

  post '/adicionar_item' do
    item = params[:item]
    @@lista_compras << item
    send_update(item)
    redirect '/'
  end

  get '/atualizar_lista', provides: 'text/event-stream' do
    stream(:keep_open) do |out|
      @@clientes ||= []
      @@clientes << out
      out.callback { @@clientes.delete(out) }
    end
  end

  def send_update(item)
    @@clientes.each do |cliente|
      cliente << "data: #{item}\n\n"
    end
  end
end

ListaComprasApp.run! if __FILE__ == $0
