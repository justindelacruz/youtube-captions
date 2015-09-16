class Source < ActiveRecord::Base
  has_many :channels, dependent: :destroy
  validates :name, presence: true, length: {minimum: 3}
  validates_uniqueness_of :slug

  def to_param
    slug
  end
end
