require 'sinatra'
require 'redis'
require 'byebug'
require 'json'
require 'cpf_cnpj'

redis = Redis.new(url: ENV['REDIS_URL'])

get '/users' do
  content_type :json

  "[" + redis.lrange(:users, 0, -1).join(",") + "]"
end

get "/users/:id" do
  content_type :json

  id = params["id"]
  halt(404, { message:'User not found'}.to_json) if id >= redis.llen(:users)
  redis.lrange(:users, id, id)
end

post '/users' do
  content_type :json

  user = JSON.parse(request.body.read)

  name = user.fetch('name', nil)
  cpf = user.fetch('cpf', nil)
  email = user.fetch('email', nil)
  birthday = user.fetch('birthday', nil)
  no_bug = user.fetch('no_bug', 'false')

  user['id'] = redis.llen(:users)
  headers 'Location' => "/users/#{user['id']}"

  # validations
  halt(401, { message:'Name can not be blank'}.to_json) if name.nil?
  halt(401, { message:'CPF can not be blank'}.to_json) if cpf.nil?
  halt(401, { message:'Email can not be blank'}.to_json) if email.nil?
  halt(401, { message:'Email can not be larger than 30 characters'}.to_json) if email.size > 30
  halt(401, { message:'Birthday can not be blank'}.to_json) if birthday.nil?
  begin
    Date.iso8601(birthday)
  rescue ArgumentError => e
    halt(401, { message:'Birthday not in ISO8601 yyyy-mm-dd format'}.to_json)
  end

  # Validations not done
  ## Birthday in future
  ## No max size for names
  ## Max size of email is 31, not 30 as described
  ## 2 Users can have same CPF
    
  # bug: HTTP Status 500 when cpf is invalid
  halt(500, nil) unless CPF.valid?(cpf)
  
  # intermitend bug. Unless if parameter no_bug is set
  halt(500, nil) if rand(4) == 0 && no_bug == "false"
  
  # happy path: create user and returns HTTP 201
  redis.rpush(:users, user.to_json)
  201
end
