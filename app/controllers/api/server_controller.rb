# -*- encoding: utf-8 -*-
class Api::ServerController < ApplicationController
  layout false
  before_filter :flow_server_filter, :except => ["location"]
  skip_before_filter :verify_authenticity_token, :only => ["location"]


  #login for cient
  def change_archived_url
    video = Video.find_by_archived_addr params[:old_url]
    video.update_attributes(archived_addr: params[:new_url])
    path = "/live/#{params[:token]}"
    FayeServer::Push.broadcast(path, {cmd: 'update_video_url', url: params[:new_url], video_id: video.id})
    render text: "ok"
  end

  def get_url
    @message = Message.find_by_token params[:token]
    t_url = @message.try(:video).try(:flv_url)
    sleep 1 unless t_url
    render json: {url: t_url}
  end

  # This method is a api for cameras to get a video url
  def users_status
    user = User.find_by_phone(params[:phone])
    if user
      if !params[:get_all]
        video = user.videos.where('created_at > ?', params[:time].to_time).order('created_at ASC').last
        if video.vstate == 'LIVING'
          if params[:apple] == 'true'
          render json: {:url => video.url('apple') }
          else
          render json: {:url => video.flv_url }
          end
        else
          render json: {:status => 'closed'}
        end
      else
        if params[:apple] == 'true'
        result = user.videos.where('created_at > ?', params[:time].to_time).limit(5).order('created_at DESC').map { |x| {:status => x.vstate, :url => x.url('apple'), :time => x.created_at.utc.to_i*1000}}
        else
        result = user.videos.where('created_at > ?', params[:time].to_time).limit(5).order('created_at DESC').map { |x| {:status => x.vstate, :url => x.flv_url, :time => x.created_at.to_i*1000}}
        end
        render json: result
      end
    else
      render json: {:reason => "cannot find user named #{params[:phone]}"}
    end
  end

  def login
    challenge = params[:challenge]
    response = params[:response]
    username = params[:username]
    if true || User.authenticate_for_mobile?(username, challenge,response)
      render :status => 200, :json => {:result => "ok" }.to_json
    else
      render :status => 400, :json => {:result => "fail"}.to_json
    end
  end

  def save_archived
    respond_to do |format|
      format.json {
        archive = Video.find_by_tid(params[:video][:tid])
        if archive
          msg = archive.message
          Video.transaction do
            archive.update_attributes(params[:video])
            archive.update_attribute(:vstate, 'ARCHIVED')
            msg.update_attribute(:mstate, 3)
          end
          archive.add_user_space!
          #archive.push_message_with_faye

          ################## 12-11-27 liuling
          ################## faye push to sender and receiver
          data = archive.faye_json
          FayeServer::Push.broadcast(archive.user.channel, data)
          Rails.logger.info "=====#{archive.user.channel}=====#{data.to_s}====="
          #Resque.enqueue(FayePushWorker, user.id, video.id)
          if archive.message
            Rails.logger.info "==========#{archive.message.phones}=========="
            archive.message.phones.split(',').uniq.each do |phone|
              u = User.find_by_phone phone
              if u && u.id != archive.user_id
                FayeServer::Push.broadcast(u.channel, data)
                Rails.logger.info "=====#{u.channel}=====#{data.to_s}====="
                #Resque.enqueue(FayePushWorker, u.id, video.id)
              end
            end
          end
          ################## end

          render :json => {:result => "ok" }.to_json
        else
          render :json => {:result => "fail" }.to_json , :status => 400
        end
      }
    end
  end

  def live_rtmp
      path = "/live/#{params[:token]}"
      demo = Demo.find_by_path params[:token]
      tid = params[:token]
      if demo
        return render json: {} if demo.is_protected? and !params[:app_name]
        demo.update_attributes(stream_id: tid, live: true,
         app_name: params[:app_name])
        #TODO remove validate
        video = demo.videos.build(vstate: 'LIVING')
        video.user = demo.user
        video.save
        FayeServer::Push.broadcast(path, {id: demo.id, vstate: "LIVING",
          video_id: video.id, cmd: 'video_begin', url: demo.web_url,
          http_url: demo.url('http'), m3u8_url: demo.url("m3u8"),
          rtsp_url: demo.url("rtsp") })
      end
      render json: {}
  end

  def archived_rtmp
      path = "/live/#{params[:token]}"
      demo = Demo.find_by_path params[:token]
      if demo
        return render json: {} if demo.is_protected? and !params[:app_name]
        demo.update_attributes(live: false, from_fmle: nil, app_name: nil)
        video = demo.videos.order('created_at ASC').last
        video.update_attributes(archived_addr: params[:archived_addr], preview_path: params[:preview_path], tid: params[:tid])
        video.demo = demo
        video.vstate = 'ARCHIVED'
        video.save
        clean_up_client
        $redis.set "analytics:connect:#{demo.path}", 0
        FayeServer::Push.broadcast(path, {id: demo.id, vstate: "ARCHIVED", cmd: 'video_over', url: demo.videos.last.archived_addr, created_at: video.created_at.to_s, video_id: video.id})
      end
      render json: {}
  end

  def clean_up_client
    #TODO
  end

  def save_live
    respond_to do |format|
      format.json {
        user = User.find_by_phone(params[:username]) || User.find_by_username(params[:username])
        living = Video.new(params[:video])
        living.title = ""
        living.user = user
        living.vstate = "LIVING"
        title = params[:video][:title]
        token = title.split("|").last || ""
        phones = title.split("|").first
        msg = Message.find_by_token(token) || user.last_upload_message(1)
        unless msg
          Rails.logger.info("-------------------will error when come here~!----------------------")
          msg = user.messages.new
          msg.mstate = 1
          msg.mtype = "VIDEO"
          msg.save
        end
        living.message = msg
        living.readyed = 1 #默认可以准备直播了
        if user and living.save!
          #msg.update_attribute(:mstate, 2)
          msg.mstate = 2
          msg.phones = (msg.phones.nil? ? "#{phones}" : "#{msg.phones},#{phones}")
          msg.save

          msg.record

          living.update_attribute("title", "")
          image_path = File.join(Rails.root, "public", "video", "#{living.tid}.jpg")
          logger.info(image_path)
          if living.encoding == "flv/mp3/h263" then
            str = "ffmpeg -re -i #{living.leshi_url} -s 480x360 -vcodec libx264 -vpre medium -vpre baseline -acodec libfaac  -ar 44100 -ac 1  -f flv  rtmp://#{Wowza['domain']}/#{Wowza['live_name']}/mp4:#{living.tid}"
          else
            str = "ffmpeg -re -i #{living.leshi_url} -acodec libvo_aacenc -ar 22050 -ac 2 -vcodec copy -f flv rtmp://#{Wowza['domain']}/#{Wowza['live_name']}/mp4:#{living.tid}"
          end
          mp4_path = File.join(Rails.root, "public", "uploads", "video", "file", "#{living.tid}.mp4")
          mp4_path_tmp = File.join(Rails.root, "public", "uploads", "video", "file", "#{living.tid}_tmp.mp4")

          ffmpeg_copy = "ffmpeg -i #{mp4_path} -acodec copy -vcodec copy #{mp4_path_tmp}"
          cmd = "qt-faststart  #{mp4_path_tmp} #{mp4_path} "
          #cmd = Cmd['ffmpeg']['faststart']
          #cmd = Command::Generator.parse(cmd, mp4_path, mp4_path_tmp)
          logger.info str
          logger.info cmd
          Thread.new {
            until(File.exist?(image_path))
              sleep 1
            end

            # living.push_message_with_faye  #push message to client with faye

            `#{str}`

            `#{ffmpeg_copy}`

            `#{cmd}`

            FileUtils.remove_file(mp4_path_tmp, true)
          }
          ################## 12-11-27 liuling
          ################## faye push to sender and receiver
          data = living.faye_json
          FayeServer::Push.broadcast(user.channel, data)
          Rails.logger.info "=====#{user.channel}=====#{data.to_s}====="
          #Resque.enqueue(FayePushWorker, user.id, video.id)
          if living.message
            Rails.logger.info "==========#{living.message.phones}=========="
            living.message.phones.split(',').uniq.each do |phone|
              u = User.find_by_phone phone
              if u && u.id != user.id
                FayeServer::Push.broadcast(u.channel, data)
                Rails.logger.info "=====#{u.channel}=====#{data.to_s}====="
                #Resque.enqueue(FayePushWorker, u.id, video.id)
              end
            end
          end
          ################## end

          render :json => {:result => "ok" }.to_json
        else
          render :json => {:result => "fail" }.to_json , :status => 400
        end
      }
    end
  end


  #location for video 参考yunshivideo
  def location
    tid = params[:video][:tid]
    lat_t = params[:video][:lat]
    lng_t = params[:video][:lng]
    arr = Video.lat_and_lng(lat_t,lng_t)
    lat, lng = arr
    video = Video.find_by_tid(tid)
    hash = {}
    status = 404
    Rails.logger.info(video.inspect)
    if(video and video.lat.eql?(format("%.7f",lat).to_f) and video.lng.eql?(format("%.7f",lng).to_f))
      Rails.logger.info("--------------------------location still same-----------------------------")
      hash = {:result => "地理坐标没有变化" }
      status = 303
    elsif video and video.update_attributes({:lat => lat, :lng => lng})
      hash = { :result => "ok"}
      push_message = {
        :type => 'LIVING_LOCATION',
        :lat => lat,
        :lng => lng,
        :id => video.id,
        :static_map => "http://api.map.baidu.com/staticimage?width=240&height=150&center=#{lng},#{lat}&zoom=15&markers=#{lng},#{lat}"
      }
      FayeServer::Push.broadcast(video.user.channel, push_message) if video.user
      video.message.phones.split(",").each do |phone|
        u = User.find_by_phone(phone)
        if u && u.id != video.user_id
          FayeServer::Push.broadcast(u.channel, push_message)
        end
      end if video.message && video.message.phones
      status = 200
      Rails.logger.info("push message to -/videos/#{video.id}-----------------------------")
      result = video.to_hash
      result[:type] = "location"
      result[:g_image] = video.static_map_photo(240,300,"mp2");
      begin
        Juggernaut.publish(["/videos/#{video.id}", "/working"], result)
      rescue Exception => e
        Rails.logger.info(e)
      end
    else
      hash = { :result => "视频不存在"}
    end
    render :json => hash.to_json, :status => status
  end


  private
  #流媒体过滤器
  def flow_server_filter
    return
    remote_ip = request.remote_ip
    access_ip = AppConfig["server_ip"].split(" ").map { |ip|  ip.split(":").first  }
    unless access_ip.include?(remote_ip)
      respond_to do |wants|
        wants.json {
          render :json => {:result => "非法访问" }.to_json, :status => 400
        }
      end
    end
  end

  def get_statistics(token)
    points = ($redis.smembers "analytics:core_set_keys:#{token}").map {|k|
      hash = $redis.hgetall k
      $redis.del k
      hash["duration"] = (Time.parse(hash['end']) - Time.parse(hash['start'])).to_i
      hash
    }
    return [] if points.length == 0
    $redis.del  "analytics:core_set_keys:#{token}"
    max_view_time = points.max_by {|p| p['duration']}['duration']
    change_step = max_view_time / 100 + 1
    statics = (1..100).step(change_step).map { |d|
      {duration: d, count: (points.select{|p| (d..(d + change_step - 1)).include? p['duration'] }.count)}
    }
   #TODO merge data
 end

 def generate_time_points(token)
    points = ($redis.smembers "analytics:core_set_keys:#{token}").map {|k|
      $redis.hgetall k
    }
    return nil if points.length == 0
    end_time = Time.parse points.max_by{ |p| Time.parse p['end']}['end']
    start_time = Time.parse points.min_by { |p| Time.parse p['start']}['start']
    change_step = 10
    statics = (start_time.to_i..end_time.to_i).step(change_step).map { |d|
      {time: d, count: (points.select{|p| (Time.parse(p['start']).to_i..Time.parse(p['end']).to_i).include? d }.count)}
    }.to_json
 end

 def get_original_points(token)
    points = ($redis.keys "analytics:core_set:#{token}*").map {|k|
      hash = $redis.hgetall k
     # $redis.del k
      hash
    }
    $redis.del "analytics:core_set_keys:#{token}"
    points
 end
end
