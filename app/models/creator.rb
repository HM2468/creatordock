class Creator < ApplicationRecord
  has_many :contents, dependent: :destroy

  validates :name, presence: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: {
              with: /\A[^@\s]+@[^@\s]+\z/,
              message: "must be a valid email"
            }

  before_validation :normalize_email

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
