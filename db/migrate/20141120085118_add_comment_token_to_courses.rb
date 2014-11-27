class AddCommentTokenToCourses < ActiveRecord::Migration
  def change
      add_column :courses, :comment_token, :string
  end
end
