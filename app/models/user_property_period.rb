class UserPropertyPeriod < ActiveRecord::Base
  belongs_to :user
  belongs_to :property
end