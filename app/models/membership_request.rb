class MembershipRequest < ActiveRecord::Base
  attr_accessible :name, :email, :introduction, :group, :group_id, :user, :user_id

  validates :name,  presence: true
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i  #fails to allow apostrophes. how does loomio ensure valid emails. or is that simple_form
  validates :email, presence: true#, format: { with: VALID_EMAIL_REGEX }
  # validates_uniqueness_of :email, :scope => :group_id
  validates :group, presence: true

  belongs_to :group#, counter_cache: true
  belongs_to :user#, counter_cache: true

  before_save { |request| request.email = email.downcase }

end
