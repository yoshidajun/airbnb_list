class Vacancy < ActiveRecord::Base
  attr_accessible :city_id, :in_date, :property_id

  belongs_to :city
  belongs_to :property

  # TODO(yjun):
  # * create VacancyList class to simplify this function.
  # * properties/index view is too complicated now.
  def self.date_property_list(city, in_date, out_date)
    if city.class == String
      city_name = city.downcase
      city = City.find_by_name(city_name)
      unless city
        raise CityError, "Unrecognized city name: #{city_name}"
      end
    end

    hash = {} # key: date, value: hash of property id
    in_date.upto(out_date - 1) do |date|
      vs = Vacancy.find_all_by_city_id_and_in_date(city.id, date)
      hash[date] = {}
      vs.each do |v|
        hash[date][v.property_id] = true
      end
    end

    property_ids = []
    hash.values.each { |list| property_ids += list.keys }
    property_ids.uniq!
    properties = Property.find(property_ids)

    return hash, properties
  end
end
