class MembershipRequest < ActiveRecord::Base

  # class NotInGroupAlreadyValidator < ActiveModel::EachValidator
  #   def validate_each(object, attribute, value)
  #     if object.group_members.find_by_email(object.email)
  #       object.errors.add attribute, "this address belongs to someone already in this group." 
  #     end
  #   end
  # end

  # class UniqueMembershipRequestValidator < ActiveModel::EachValidator
  #   def validate_each(object, attribute, value)
  #     if object.group_membership_requests.find_by_email(object.email)
  #       object.errors.add attribute, "you have already requested membership" #needs_translation see simple_form yaml
  #     end
  #   end
  # end

  attr_accessible :name, :email, :introduction

  validates :name,  presence: true
  validates :email, presence: true, email: true #this uses the gem valid_email

  validate :not_in_group_already
  validate :unique_membership_request

  validates :group, presence: true

  belongs_to :group
  belongs_to :user

  delegate :members, to: :group, prefix: true
  delegate :membership_requests, to: :group, prefix: true

  private

  def not_in_group_already
    if group_members.find_by_email(email)
      errors.add(:email, 'this address belongs to someone already in this group.') #needs_translation see simple_form yaml?
    end
  end

  def unique_membership_request
    if group_membership_requests.find_by_email(email)
      errors.add(:email, 'you have already requested membership') #needs_translation
    end
  end
end
