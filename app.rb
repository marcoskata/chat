# coding: utf-8
require 'sinatra'
set server: 'thin', connections: Hash.new

get '/' do
  halt erb(:login) unless params[:user]
  erb :chat, locals: { user: params[:user].gsub(/\W/, '') }
end

get '/stream/:user', provides: 'text/event-stream' do
  stream :keep_open do |out|
    settings.connections[params[:user]] = out
    out.callback { settings.connections.delete(settings.connections.key out) }
  end
end

post '/' do

    settings.connections.each { |user, out| out << "data: #{params[:user]} : #{params[:msg]}\n\n" }
    204 # response without entity body

end
