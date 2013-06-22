class Events::MotionEdited < Event
  after_create :notify_users!

  def self.publish!(motion, editor)
    create!(:kind => "motion_edited", :eventable => motion, :user => editor,
                      :discussion_id => motion.discussion.id)
  end

  def motion
    eventable
  end

  private

  def notify_users!
    MotionMailer.motion_edited(motion, motion.author.email, user).deliver
    motion.users_voted.each do |voted_user|
      unless voted_user == user
        notify!(voted_user)
      end
    end
  end

  handle_asynchronously :notify_users!
end