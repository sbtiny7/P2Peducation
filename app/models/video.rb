class Video < ActiveRecord::Base
    belongs_to :videoable, :polymorphic => true

    def url(type)
        case type.to_s
        end
    end
end
