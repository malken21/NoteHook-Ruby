require "net/http"
require "uri"

# レスポンス
def result(socket, status)
  response = { status: status ? "Allow" : "Deny" }.to_json

  socket.print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: application/json\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"
  socket.print "\r\n"
  socket.print response
  socket.close
end

# Discord に 送信
def sendDiscord(text, url)
  payload = { content: text }
  uri = URI.parse(url)
  Net::HTTP.post_form(uri, payload)
end
