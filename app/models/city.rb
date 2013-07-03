class City < ActiveRecord::Base
  attr_accessible :name

  has_many :properties, dependent: :destroy

  # TODO(yjun):
  # * normalize city name
  # ** e.g. "SAN FraNCiSO, CA" => "san francisco, ca"
  # * how to recognize "san francisco ca" and "san francisco, ca" are same?
end
