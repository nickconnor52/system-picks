require 'rails_helper'

RSpec.describe "matchups/index", type: :view do
  before(:each) do
    assign(:matchups, [
      Matchup.create!(),
      Matchup.create!()
    ])
  end

  it "renders a list of matchups" do
    render
  end
end
