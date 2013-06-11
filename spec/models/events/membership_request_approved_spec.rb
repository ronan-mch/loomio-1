require 'spec_helper'

describe Events::MembershipRequestApproved do
  let(:membership_request) { stub(:membership_request) }
  describe '#publish' do
    let(:event) { stub(:event, notify_users!: true) }
    before { Event.stub(:create!).and_return(event) }

    it 'creates an event' do
      Event.should_receive(:create!).with(kind: 'user_added_to_group',
                                          eventable: membership)
      Events::UserAddedToGroup.publish!(membership_request)
    end

    it 'returns an event' do

    end

    context "after event has been published" do
      it 'delivers ....' do
      end

      it 'notifies group admins' do
        # event.should_receive(:notify!).with(user)
        # event.save
      end
    end
  end
end

#################################
