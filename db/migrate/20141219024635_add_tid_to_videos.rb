class AddTidToVideos < ActiveRecord::Migration
	def change
		add_column :videos, :tid, :string
		add_column :videos, :preview_addr, :string
		add_column :videos, :archived_addr, :string
	end
end
