##
#提供faye server的服务，发送消息, 生成频道
#
require 'net/http'
module FayeServer

  class Common
    def self.faye_url
      "http://#{FayeConfig["server"]}:#{FayeConfig["port"]}/#{FayeConfig["name"]}"
    end

    def self.faye_js_url
      "http://#{FayeConfig["server"]}:#{FayeConfig["port"]}/#{FayeConfig["name"]}.js"
    end
  end

  class Push
    ##
    #负责发送json数据到服务器, ext是增加额外的参数，比如认证token
    #
    def self.broadcast(channel, data)
      faye_url = FayeServer::Common.faye_url
      #message = {:channel => channel, :data => data, :ext => {:auth_token => FAYE_TOKEN} }
      message = {:channel => channel, :data => data }
      uri = URI.parse(faye_url)
      begin
        Net::HTTP.post_form(uri, :message => message.to_json)
      rescue Exception => e
        Rails.logger.info("#{e}")
      end
    end
  end
end