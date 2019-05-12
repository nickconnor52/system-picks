require 'rails_helper'

RSpec.describe "matchups/edit", type: :view do
  before(:each) do
    @matchup = assign(:matchup, Matchup.create!())
  end

  it "renders the edit matchup form" do
    render

    assert_select "form[action=?][method=?]", matchup_path(@matchup), "post" do
    end
  end
end
