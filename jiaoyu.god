MAIN_DIR="/var/www/jiaoyu"

God.watch do |w|
  w.name = "web"
  w.start = "rails s"
  w.dir = MAIN_DIR
  w.log = "#{MAIN_DIR}/log/#{w.name}.log"
  w.keepalive
end
