class Caption < ActiveRecord::Base
  belongs_to :episode
  validates :text, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
end
