require 'sinatra'
require 'pg'

$conn = PG.connect( dbname: 'sinatra_app',host:'localhost',user:'postgres',password:'postgres' )

class Todo
  def initialize(id,title)
    @id = id
    @title = title
  end

  def save
    result = $conn.exec("INSERT INTO todos (title) VALUES ('#{@title}') RETURNING id")
    @id = result[0]["id"]
  end

  def delete
    @result = $conn.exec("DELETE FROM todos WHERE id=#{@id}")
  end

  def update
    result = $conn.exec("UPDATE todos SET title='#{@title}' WHERE id=#{@id} RETURNING ID")
    @id = result[0]["id"]
  end

  def self.all
    @results = $conn.exec("SELECT * FROM todos")
  end

  def self.where(params)
    @id = params["id"]
    @title = "'"+params["title"]+"'"
    @results = $conn.exec("SELECT * FROM todos WHERE id=#{@id} AND title=#{@title}")
  end

  def self.where2(params)
    @id = params["id"]
    @title = "'"+params["title"]+"'"
    @results = $conn.exec("SELECT * FROM todos WHERE id=#{@id} AND title=#{@title}")
  end

end

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
  @result = $conn.exec("SELECT * FROM todos WHERE id=#{params['id']}")[0]

  erb :edit
end

get "/todos/:id" do
  @result = $conn.exec("SELECT * FROM todos WHERE id=#{params['id']}")[0]

  erb :show
end

post "/todos" do
  todo = Todo.new(params['id'],params['title'])
  if params["custom_method"] == "DELETE"
    todo.delete
    redirect to("/todos")
  else
    id = todo.save
    redirect to("/todos/#{id}")
  end
end

post "/todos/:id" do
  todo = Todo.new(params['id'],params['title'])
  if params["custom_method"] == "PUT"
    id = todo.update
    redirect to("/todos/#{id}")
  end
end
