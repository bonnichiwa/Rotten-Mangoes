class Movie < ActiveRecord::Base

  has_many :reviews

  mount_uploader :image, ImageUploader


  validates :title, :director, :description, :release_date, presence: true
  validates :runtime_in_minutes, numericality: { only_integer: true }

  validate :release_date_is_in_the_future

  def review_average
    if reviews.any?
      reviews.sum(:rating_out_of_ten)/reviews.size
    else
      return 0
    end
  end

  def self.search(search)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      Movie.all
    end
  end

  private

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the future") if release_date < Date.today
    end
  end

end
