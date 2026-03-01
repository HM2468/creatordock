require 'rails_helper'

RSpec.describe Contents::Create do
  let(:creator) { Creator.create!(name: "Service Creator", email: "service@example.com") }

  let(:valid_params) do
    {
      title: "My Post",
      social_media_url: "https://www.instagram.com/p/xyz",
      social_media_provider: "instagram"
    }
  end

  describe ".call" do
    context "with valid params" do
      it "returns a successful result" do
        result = described_class.call(creator, valid_params)
        expect(result.success?).to be true
      end

      it "creates a content record" do
        expect { described_class.call(creator, valid_params) }.to change(Content, :count).by(1)
      end

      it "associates content with the creator" do
        result = described_class.call(creator, valid_params)
        expect(result.content.creator).to eq(creator)
      end
    end

    context "with invalid params" do
      it "returns a failed result when title is blank" do
        result = described_class.call(creator, valid_params.merge(title: ""))
        expect(result.success?).to be false
        expect(result.content.errors[:title]).to include("can't be blank")
      end

      it "returns a failed result when URL is invalid" do
        result = described_class.call(creator, valid_params.merge(social_media_url: "bad url"))
        expect(result.success?).to be false
        expect(result.content.errors[:social_media_url]).to include("must be a valid URL")
      end

      it "returns a failed result when provider is blank" do
        result = described_class.call(creator, valid_params.merge(social_media_provider: ""))
        expect(result.success?).to be false
      end

      it "does not create a content record on failure" do
        expect {
          described_class.call(creator, valid_params.merge(title: ""))
        }.not_to change(Content, :count)
      end
    end
  end
end
