MAIN_DIR="/var/www/jiaoyu"

God.watch do |w|
  w.name = "web"
  w.start = "rails s"
  w.dir = MAIN_DIR
  w.log = "#{MAIN_DIR}/log/#{w.name}.log"
  w.keepalive
end

God.watch do |w|
  w.name = "faye"
  w.start = "node faye.js"
  w.dir = "/var/www/chat_server"
  w.log = "#{w.dir}/#{w.name}.log"
  w.keepalive
end

God.watch do |w|
  w.name = "chat_web"
  w.start = "node app.js"
  w.dir = "/var/www/chat_server/webserver"
  w.log = "#{w.dir}/#{w.name}.log"
  w.keepalive
end

God.watch do |w|
  w.name = "statitics"
  w.start = "ruby app.rp -p 4000"
  w.dir = "/var/www/data_interface"
  w.log = "#{w.dir}/#{w.name}.log"
  w.keepalive
end
