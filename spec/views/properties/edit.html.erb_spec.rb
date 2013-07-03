require 'spec_helper'

describe "properties/edit" do
  before(:each) do
    @property = assign(:property, stub_model(Property,
      :name => "MyString",
      :city_id => 1
    ))
  end

  it "renders the edit property form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => properties_path(@property), :method => "post" do
      assert_select "input#property_name", :name => "property[name]"
      assert_select "input#property_city_id", :name => "property[city_id]"
    end
  end
end
