require 'rails_helper'

RSpec.describe Idea, type: :model do

  describe "vaidates" do
    it "should require a title" do
      idea = Idea.new

      idea.valid?

      expect(idea.errors.messages).to have_key :title
    end

    it "should have a unique title" do
      persisted_idea = FactoryBot.create(:idea)
      idea = Idea.new(title: persisted_idea.title)

      idea.valid?

      expect(idea.errors.messages).to have_key :title
      expect(idea.errors.messages[:title]).to include('has already been taken')
    end

    it "should have a desciption" do
      idea = Idea.new

      idea.valid?

      expect(idea.errors.messages).to have_key :description
    end
  end

end
