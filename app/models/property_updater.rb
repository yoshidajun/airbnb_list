require 'open-uri'
require 'json'
require 'pp'

class PropertyUpdater
  # input
  # * city: city name as string
  # * checkin, checkout: date as string ('%Y%m%d')
  def self.update(city, checkin, checkout = nil, force_update = true)
    city = city.downcase

    in_date = checkin.class == String ? Date.parse(checkin) : checkin
    out_date = 
      if checkout
        checkout.class == String ? Date.parse(checkout) : checkout
      else
        in_date + 1
      end

    pp in_date
    pp out_date

    in_date.upto(out_date - 1) do |date|
      pp date
      city_obj = store_city(city)
      unless force_update
        if Vacancy.find_by_city_id_and_in_date(city_obj.id, date)
          puts "-------------------- already stored"
          next  # this City, Date is already scanned.
        end
      end
      property_list = find_properties(city, date, date + 1)
      store_properties(city_obj, date, property_list)
    end
  end

  # output:
  # * array of properties
  #
  # uri example:
  # * https://www.airbnb.com/search/ajax_get_results?location=San+Francisco%2C+CA&checkin=07%2F09%2F2013&checkout=07%2F12%2F2013
  def self.find_properties(city, in_date, out_date)
    # uri = 
    puts "in: #{in_date}, out: #{out_date}"

    uri = airbnb_uri(city, in_date, out_date)
    puts uri
    html = open(uri).read

    json = JSON.parser.new(html)
    puts json.class

    hash =  json.parse()
    # pp hash['properties']

    hash['properties']
  end

  def self.airbnb_uri(city, in_date, out_date)
    uri = 'https://www.airbnb.com/search/ajax_get_results?'
    uri += "location=#{city}"
    uri += "&checkin=#{in_date.strftime('%m/%d/%Y')}"
    uri += "&checkout=#{out_date.strftime('%m/%d/%Y')}"
    URI.encode(uri)
  end

  # input:
  # * city: city name as string
  def self.store_city(city_name)
    city = City.find_by_name(city_name)
    unless city
      city = City.create(name: city_name)
    end
    city
  end

  def self.store_properties(city_obj, in_date, property_list)
    property_list.each do |property|
      puts "id: #{property['id']}, name: #{property['name']}"

      property_obj = Property.find_by_aid(property['id'])
      unless property_obj
        property_obj = Property.create(aid: property['id'],
                                       name: property['name'],
                                       city_id: city_obj.id)
      end

      property_obj.add_date(in_date)
    end
    true
  end
  
end
