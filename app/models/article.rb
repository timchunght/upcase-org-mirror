class Article < ActiveRecord::Base
  attr_protected :body_html

  has_many :classifications, as: :classifiable
  has_many :products, through: :topics, uniq: true
  has_many :topics, through: :classifications
  has_many :workshops, through: :topics, uniq: true

  validates :body_html, presence: true
  validates :external_url, presence: true
  validates :published_on, presence: true
  validates :title, presence: true

  def self.ordered
    order('published_on desc')
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def keywords
    topics.map(&:name).join(',')
  end

  def related
    @related ||= Related.new(self)
  end
end
