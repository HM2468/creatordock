require 'rails_helper'

RSpec.describe Content, type: :model do
  let(:creator) { Creator.create!(name: "Test Creator", email: "creator@example.com") }

  def build(attrs = {})
    Content.new({
      creator: creator,
      title: "My Post",
      social_media_url: "https://www.instagram.com/p/abc123",
      social_media_provider: :instagram
    }.merge(attrs))
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(build).to be_valid
    end

    context "title" do
      it "is invalid without a title" do
        content = build(title: nil)
        expect(content).not_to be_valid
        expect(content.errors[:title]).to include("can't be blank")
      end
    end

    context "social_media_url" do
      it "is invalid without a URL" do
        content = build(social_media_url: nil)
        expect(content).not_to be_valid
        expect(content.errors[:social_media_url]).to include("can't be blank")
      end

      it "is invalid with a non-URL string" do
        content = build(social_media_url: "not a url")
        expect(content).not_to be_valid
        expect(content.errors[:social_media_url]).to include("must be a valid URL")
      end

      it "is valid with an https URL" do
        content = build(social_media_url: "https://www.tiktok.com/@user/video/1")
        expect(content).to be_valid
      end
    end

    context "social_media_provider" do
      it "is invalid without a provider" do
        content = build(social_media_provider: nil)
        expect(content).not_to be_valid
        expect(content.errors[:social_media_provider]).to include("can't be blank")
      end

      it "accepts instagram" do
        expect(build(social_media_provider: :instagram)).to be_valid
      end

      it "accepts tiktok" do
        expect(build(social_media_provider: :tiktok)).to be_valid
      end

      it "accepts youtube" do
        expect(build(social_media_provider: :youtube)).to be_valid
      end
    end
  end
end
