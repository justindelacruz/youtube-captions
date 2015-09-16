class Channel < ActiveRecord::Base
  has_many :episodes, dependent: :destroy
  belongs_to :source
  validates :source, presence: true # Requires association to be present
  validates :name, presence: true
  validates :slug, presence: true
  validates_uniqueness_of :slug
end
