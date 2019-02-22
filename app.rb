require 'sinatra'
require 'redis'
require 'byebug'
require 'json'

redis = Redis.new()

get '/users' do
  redis.lrange(:users, 0, -1).to_json
end

post '/users' do
  user = JSON.parse(request.body.read)
  user['id'] = redis.llen(:users)
  name = user['name']
  cpf = user['cpf']
  email = user['email']
  birthday = user['birthday']

  redis.lpush(:users, user.to_json)

  201
end
