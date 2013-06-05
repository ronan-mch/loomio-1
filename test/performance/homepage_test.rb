require 'performance_test_helper'
require 'rails/performance_test_help'
require 'factory_girl'

class HomepageTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { :runs => 5, :metrics => [:wall_time, :memory]
  #                          :output => 'tmp/performance', :formats => [:flat] }

  #def test_homepage
    #visit '/'
  #end

  #def test_login
    #visit '/'
    #click_on 'Sign in'
    #fill_in 'Email', with: 'test@loomio.org'
    #fill_in 'Password', with: 'password'
    #click_on 'sign-in-btn'
  #end

  #def self.startup
    #@@user = FactoryGirl.create(:user)
    #@@discussion = FactoryGirl.create(:discussion, author: @@user)
    #20.times do
      #FactoryGirl.create(:comment, commentable: @@discussion)
    #end
  #end
  def setup

    @setup = false
    unless @setup
      @setup = true
      @user = FactoryGirl.create(:user)
      @group = FactoryGirl.create(:group, max_size: 200)
      @discussion = FactoryGirl.create(:discussion, author: @user, group: @group)
      20.times do
        FactoryGirl.create(:comment, commentable: @discussion)
      end
    end
  end 

  def test_discussion_show
    visit '/users/sign_in'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_on 'sign-in-btn'
    visit discussion_path(@discussion)
  end
end
