require 'rails_helper'

RSpec.describe "matchups/show", type: :view do
  before(:each) do
    @matchup = assign(:matchup, Matchup.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
