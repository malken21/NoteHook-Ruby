require "net/http"
require "uri"

# レスポンス
def result(socket, status)
  response = { status: status ? "Allow" : "Deny" }

  socket.puts "HTTP/1.1 200 OK"
  socket.puts "Content-Type: application/json"
  socket.puts "Content-Length: #{response.to_json.bytesize}"
  socket.puts "Connection: close"
  socket.puts
  socket.print response.to_json
  socket.close
end

# Discord に 送信
def sendDiscord(text, url)
  payload = { content: text }
  uri = URI.parse(url)
  Net::HTTP.post_form(uri, payload)
end
