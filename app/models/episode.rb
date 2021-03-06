class Episode < ActiveRecord::Base
  belongs_to :channel
  has_many :captions, dependent: :delete_all
  validates :channel, presence: true # Requires association to be present
  validates :name, presence: true
  validates :slug, presence: true
  validates :date_created, presence: true
  validates_date :date_created, on_or_before: :today
  validates_uniqueness_of :slug, scope: :channel_id

  def to_param
    slug
  end
end
