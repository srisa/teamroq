require 'rails_helper'

describe "documents/show" do
  describe "Project as Attachable" do
    before(:each) do
      @attachable = FactoryGirl.create(:project)
      @document = FactoryGirl.create(:document, name: "freedom")
      @document_version = FactoryGirl.create(:document_version, release_note: "added")
      @document.document_versions.push @document_version
    end

    it "renders links" do
      render
      expect(rendered).to have_link("Dashboard")
      expect(rendered).to have_link("Users")
      expect(rendered).to have_link("Discussions")
      expect(rendered).to have_link("Standup Meeting")
      expect(rendered).to have_link("Documents")
    end

    it "renders document" do
      render
      expect(rendered).to match /Freedom/
      expect(rendered).to match /added/
    end
  end

  describe "Group as Attachable" do
    before(:each) do
      @attachable = FactoryGirl.create(:group)
      @document = FactoryGirl.create(:document, name: "freedom")
      @document_version = FactoryGirl.create(:document_version, release_note: "added")
      @document.document_versions.push @document_version
    end

    it "renders links" do
      render
      expect(rendered).to have_link("Dashboard")
      expect(rendered).to have_link("Users")
      expect(rendered).not_to have_link("Discussions")
      expect(rendered).not_to have_link("Standup Meeting")
      expect(rendered).to have_link("Documents")
    end

    it "renders document" do
      render
      expect(rendered).to match /Freedom/
      expect(rendered).to match /added/
    end
  end
end
