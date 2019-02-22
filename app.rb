require 'sinatra'
require 'redis'
require 'byebug'
require 'json'

redis = Redis.new(url: ENV['REDIS_URL'])

get '/users' do
  content_type :json

  "[" + redis.lrange(:users, 0, -1).join(",") + "]"
end

get "/users/:id" do
  content_type :json

  id = params["id"]
  redis.lrange(:users, id, id)
end

post '/users' do
  user = JSON.parse(request.body.read)

  name = user['name']
  cpf = user['cpf']
  email = user['email']
  birthday = user['birthday']

  user['id'] = redis.llen(:users)
  headers 'Location' => "/users/#{user['id']}"

  redis.rpush(:users, user.to_json)
  201
end
