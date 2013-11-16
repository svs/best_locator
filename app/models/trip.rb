class Trip < ActiveRecord::Base

  belongs_to :user
  has_many :location_reports


end
