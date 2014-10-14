class HomeController < ApplicationController
    before_action :authenticate_user!, :only => [:lesson]
    def index
    end

    def courses
    end

    def course
    end

    def study
    end

    def lesson
    end
end
