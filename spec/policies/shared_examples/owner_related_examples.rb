RSpec.shared_examples 'where owner required' do
  context 'with non-authenticated user' do
    let(:current_user) { nil }
    let(:owner) { create(:user) }

    it { is_expected.to eq(false) }
  end

  context 'with authenticated user' do
    let(:current_user) { create(:user) }

    context 'when has rating on current movie' do
      let(:owner) { current_user }

      it { is_expected.to eq(true) }
    end

    context 'when does not have rating on current movie' do
      let(:owner) { create(:user) }

      it { is_expected.to eq(false) }
    end
  end
end

RSpec.shared_examples 'where owner interferes' do
  context 'with non-authenticated user' do
    let(:current_user) { nil }

    it { is_expected.to eq(false) }
  end

  context 'with authenticated user' do
    let(:current_user) { create(:user) }

    context 'when already has rating on current movie' do
      let(:movie) { create(:movie) }
      before { create(:rating, rated_movie: movie, rated_user: current_user, points: 5) }

      it { is_expected.to eq(false) }
    end

    context 'when does not have rating on current movie' do
      it { is_expected.to eq(true) }
    end
  end
end
