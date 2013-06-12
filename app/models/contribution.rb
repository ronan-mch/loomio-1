class Contribution < ActiveRecord::Base
  extend FriendlyId
  friendly_id :identifier_id
  attr_accessible :identifier_id, :response_code, :user_id
  validates_presence_of :user, :identifier_id, :response_code

  belongs_to :user

end
