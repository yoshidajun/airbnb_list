require 'spec_helper'

describe "properties/show" do
  before(:each) do
    @property = assign(:property, stub_model(Property,
      :name => "Name",
      :city_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/1/)
  end
end
