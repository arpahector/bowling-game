class AddFrameIdToBall < ActiveRecord::Migration
  def change
    add_column :balls, :frame_id, :integer
  end
end
