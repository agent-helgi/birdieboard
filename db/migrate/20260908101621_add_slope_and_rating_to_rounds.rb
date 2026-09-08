class AddSlopeAndRatingToRounds < ActiveRecord::Migration[8.0]
  def change
    add_column :rounds, :slope_rating, :integer
    add_column :rounds, :course_rating, :decimal
  end
end
