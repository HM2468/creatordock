class Content < ApplicationRecord
  belongs_to :creator, counter_cache: true

  enum social_media_provider: {
    instagram: 'instagram',
    tiktok: 'tiktok',
    youtube: 'youtube'
  }

  validates :title, presence: true
  validates :social_media_url, presence: true
  validates :social_media_provider, presence: true

  validate :social_media_url_must_be_valid

  private

  def social_media_url_must_be_valid
    return if social_media_url.blank?

    uri = URI.parse(social_media_url) rescue nil
    unless uri && uri.is_a?(URI::HTTP) && uri.host.present?
      errors.add(:social_media_url, "must be a valid URL")
    end
  end
end