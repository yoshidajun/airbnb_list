class Property < ActiveRecord::Base
  attr_accessible :aid, :city_id, :name

  belongs_to :city
  has_many :vacancies, dependent: :destroy

  def add_date(in_date)
    vacancy = Vacancy.find_by_property_id_and_in_date(self.id, in_date)
    unless vacancy
      puts "city_id: #{self.city_id}, property_id: #{self.id}, in_date: #{in_date}"
      vacancy = Vacancy.create(city_id: self.city_id,
                               property_id: self.id,
                               in_date: in_date)
    end
    vacancy
  end

  # output:
  # * array of boolean
  # ** index: date
  # ** value: true if available
  def vacancy_list_by_date(in_date, out_date)
    list = []
    in_date.upto(out_date - 1) do |date|
      if Vacancy.find_by_property_id_and_in_date(self.id, date)
        list.push true
      else
        list.push false
      end
    end
    list
  end
end
