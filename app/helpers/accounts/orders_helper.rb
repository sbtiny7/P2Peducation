module Accounts::OrdersHelper
    def expired_duration
        display_time Settings.expired_duration
    end

    def display_time(sec)
        (sec / 60).to_s + "分钟"
    end
end
