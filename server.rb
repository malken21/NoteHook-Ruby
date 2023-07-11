require "socket"
require "yaml"
require "json"

require "./util.rb"

# config.yml 読み込み
config = open("config.yml", "r") { |f| YAML.load(f) }

# TCPサーバー 作成
server = TCPServer.new config["Port"]

# 無限ループ
loop do
  Thread.start(server.accept) do |socket|
    # リクエストを受け取ったら

    # 現在のスレッド コンソール出力
    p Thread.current

    # メソッド と パス 取得
    method, path = socket.gets.split(" ")

    # Post リクエスト かつ パスが / の場合
    if method == "POST" && path == "/"

      # ヘッダー 解析
      headers = {}
      while header = socket.gets.chomp
        break if header.empty?
        key, value = header.split(": ")
        headers[key] = value
      end

      # 全ての ヘッダー コンソール出力
      p headers

      # シークレットが同じ
      if headers["X-Misskey-Hook-Secret"] == config["Secret"]

        # リクエストボディ 読み込み
        body = socket.read(headers["Content-Length"].to_i)

        # 結果 レスポンス ( 許可 )
        result(socket, true)

        # リクエストボディ json 解析
        bodyJSON = JSON.load(body)

        # リクエストボディ コンソール出力
        p bodyJSON

        # ノートの情報だけ 取り出す
        note = bodyJSON["body"]["note"]

        # ノートの公開範囲 確認
        if config["Visibility"].include?(note["visibility"])

          # config.yml の Sleep に書かれた秒数 待機
          sleep config["Sleep"]

          # Discordに表示する文字 生成
          text = format(config["Message"], Instance: config["Instance"], note_id: note["id"])

          # Discordに送信
          sendDiscord(text, config["Discord_Webhook"])
          # Discordに送信する文字 コンソール出力
          p text
        end
      end
      # スレッド 停止
      Thread.stop
    end

    # 結果 レスポンス ( 拒否 )
    result(socket, false)
  end
end
