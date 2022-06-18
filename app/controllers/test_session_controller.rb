class TestSessionController < ApplicationController
  def create


    conn = create_connect
    res = conn.post do |req|
      req.url '/api/v2/users'
      req.body = {
        email: params[:email],
        password: SecureRandom.alphanumeric,
        connection: "Username-Password-Authentication",
        verify_email: false
      }.to_json
    end
    send_change_password(params[:email])
  end

  def generat_access_token
    conn = Faraday.new(
      url: "https://#{ENV['AUTH0_DOMAIN']}/oauth/token",
      headers: {'Content-Type' => 'application/x-www-form-urlencoded'}
    )
    res = conn.post do |req|
            req.body = {
              client_id: ENV['AUTH0_CLIENT_ID'],
              client_secret: ENV['AUTH0_CLIENT_SECRET'],
              audience: "https://#{ENV['AUTH0_DOMAIN']}/api/v2/",
              grant_type: 'client_credentials'
            }
          end
    JSON.parse(res.body)['access_token']
  end

  def send_change_password(email)
    require 'uri'
    require 'net/http'
    require 'openssl'

    url = URI("https://#{ENV['AUTH0_DOMAIN']}/dbconnections/change_password")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/json'
    request.body = "{\"client_id\":\"#{ENV['AUTH0_CLIENT_ID']}\",\"email\":\"#{email}\",\"connection\": \"Username-Password-Authentication\"}"

    request.body.inspect
    response = http.request(request)
    puts response.read_body
  end

  def create_connect
    conn = Faraday.new(
      url: "https://#{ENV['AUTH0_DOMAIN']}",
      headers: {'Content-Type' => 'application/json'}
    )
    token = generat_access_token
    conn.headers['Authorization'] = "Bearer #{token}"
    conn
  end
end
