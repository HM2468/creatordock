require 'rails_helper'

RSpec.describe Creator, type: :model do
  def new_creator(attrs = {})
    Creator.new({ name: "Test Creator", email: "test@example.com" }.merge(attrs))
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(new_creator).to be_valid
    end

    context "name" do
      it "is invalid without a name" do
        creator = new_creator(name: nil)
        expect(creator).not_to be_valid
        expect(creator.errors[:name]).to include("can't be blank")
      end

      it "is invalid with a blank name" do
        creator = new_creator(name: "   ")
        expect(creator).not_to be_valid
      end
    end

    context "email" do
      it "is invalid without an email" do
        creator = new_creator(email: nil)
        expect(creator).not_to be_valid
        expect(creator.errors[:email]).to include("can't be blank")
      end

      it "is invalid with a malformed email" do
        creator = new_creator(email: "not-an-email")
        expect(creator).not_to be_valid
        expect(creator.errors[:email]).to include("must be a valid email")
      end

      it "is invalid with a duplicate email (case-insensitive)" do
        Creator.create!(name: "Existing", email: "dupe@example.com")
        creator = new_creator(email: "DUPE@EXAMPLE.COM")
        expect(creator).not_to be_valid
        expect(creator.errors[:email]).to include("has already been taken")
      end

      it "normalizes email to lowercase" do
        creator = new_creator(email: "  UPPER@EXAMPLE.COM  ")
        creator.valid?
        expect(creator.email).to eq("upper@example.com")
      end
    end
  end
end
