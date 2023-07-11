require "net/http"
require "uri"
require "json"

# レスポンス
def result(socket, status)
  socket.puts "HTTP/1.0 200 OK"
  socket.puts "Content-Type: text/plain"
  socket.puts
  socket.puts status ? "Allow" : "Deny"
  socket.close
end

# Discord に 送信
def sendDiscord(text, url)
  payload = { content: text }
  uri = URI.parse(url)
  Net::HTTP.post_form(uri, payload)
end
