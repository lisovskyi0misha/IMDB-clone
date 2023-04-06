require 'rails_helper'

RSpec.describe RatingHelper do
  describe 'can?' do
    subject(:can?) { helper.can?(action, movie, current_user) }
    let(:policy_class) { RatingPolicy }
    let(:policy_object) { instance_spy(policy_class) }
    let(:movie) { build(:movie) }
    let!(:current_user) { create(:user) }

    context 'with new' do
      let(:action) { :new }

      before do
        allow(policy_class).to(
          receive(:new).with(current_user, movie).and_return(policy_object)
        )
      end

      it 'calls policy with new? method' do
        can?
        expect(policy_object).to have_received(:new?).once
      end
    end

    context 'with edit' do
      let(:action) { :edit }

      before do
        allow(policy_class).to(
          receive(:new).with(current_user, movie).and_return(policy_object)
        )
      end

      it 'calls policy with new? method' do
        can?
        expect(policy_object).to have_received(:edit?).once
      end
    end
  end
end
