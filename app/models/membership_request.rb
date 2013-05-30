class MembershipRequest < ActiveRecord::Base
  attr_accessible :name, :email, :introduction

  validates :name,  presence: true
  validates :email, presence: true, email: true
  validates :group, presence: true

  belongs_to :group
  belongs_to :user
end
