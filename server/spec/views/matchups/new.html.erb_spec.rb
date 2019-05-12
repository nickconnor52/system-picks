require 'rails_helper'

RSpec.describe "matchups/new", type: :view do
  before(:each) do
    assign(:matchup, Matchup.new())
  end

  it "renders new matchup form" do
    render

    assert_select "form[action=?][method=?]", matchups_path, "post" do
    end
  end
end
