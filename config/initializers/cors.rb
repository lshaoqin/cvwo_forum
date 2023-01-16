Rails.application.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:3001', 'http://localhost:3000', 'https://tagup.onrender.com'
      resource '*', headers: :any, methods: [:get, :post]
    end
  end