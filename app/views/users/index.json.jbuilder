json.array!(@users) do |user|
  json.extract! user, :id, :fname, :lname, :email, :password, :username, :location, :bio, :interests
  json.url user_url(user, format: :json)
end
