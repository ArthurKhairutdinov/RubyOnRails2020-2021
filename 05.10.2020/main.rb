require 'sinatra'
require 'pg'

require './models/Todo'

get '/' do
  "Hello world"
end

get '/filter' do
  params = {"id" => 9, "title"=>"do"}
  @results = Todo.where(params)
  erb :index
end

get "/todos" do
  @results = Todo.all
  erb :index
end

get "/todos/new" do
  erb :new
end

get "/todos/:id/edit" do
  @result = Todo.where(params).first

  erb :edit
end

get "/todos/:id" do
  @result = Todo.where(params).first

  erb :show
end

post "/todos" do
  todo = Todo.new(params)
  if params["custom_method"] == "DELETE"
    todo.delete
    redirect to("/todos")
  else
    @result = todo.save
    redirect to("/todos/#{@result.first['id']}")
  end
end

post "/todos/:id" do
  todo = Todo.new(params)
  if params["custom_method"] == "PUT"
    @result = todo.update
    redirect to("/todos/#{params['id']}")
  end
end
