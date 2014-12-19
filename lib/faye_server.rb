##
#提供faye server的服务，发送消息, 生成频道
#
require 'net/http'
require 'json'

module FayeServer
    class Common
        def self.faye_url
            "http://#{Settings.chat_server}:9292/faye"
        end

        def self.faye_js_url
            "http://#{Settings.chat_server}:9292/faye/faye.js"
        end
    end

    class Push
        ##
        #负责发送json数据到服务器, ext是增加额外的参数，比如认证token
        #
        def self.broadcast(channel, data)
            @host = Settings.chat_server
            @port = '80'
            @post_ws = "/chat_server/publish"
            @payload ={
                channel: channel,
                message: data
            }.to_json

            req = Net::HTTP::Post.new(@post_ws, initheader = {'Content-Type' =>'application/json'})
            req.body = @payload
            response = Net::HTTP.new(@host, @port).start {|http| http.request(req) }
        end
    end
end
