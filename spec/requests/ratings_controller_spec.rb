require 'rails_helper'
require_relative 'shared_examples/common_controller_behavior'
require_relative 'shared_examples/non_get_turbo_responses'

RSpec.describe RatingsController do
  describe 'POST #create' do
    subject(:create_request) do
      post "/movies/#{movie.id}/ratings",
        params: { movie_id: movie.id, rating: { points: }, format: :turbo_stream }
    end
    let(:movie) { create(:movie) }

    context 'with authenticated user' do
      let(:user) { create(:user) }

      before { sign_in user }

      context 'with valid points' do
        let(:points) { 2 }

        it 'saves rating to db' do
          expect { create_request }.to change(Rating, :count).by(1)
        end

        include_examples 'finds movie'
        include_examples 'positive turbo-stream responses', :create
      end

      context 'with invalid points' do
        let(:points) { 'invalid points' }

        include_examples 'finds movie'

        it 'redirects back' do
          create_request
          expect(response).to redirect_to(movies_path)
        end

        it 'does not call job' do
          expect { create_request }.not_to have_enqueued_job(RatingCountJob)
        end

        it 'does not saves rating to db' do
          expect { create_request }.not_to change(Rating, :count)
        end
      end
    end

    context 'with non-authenticated user' do
      let(:user) { :nil }
      let(:points) { 2 }

      include_examples 'non-authenticated user'
    end
  end

  describe 'PATCh #update' do
    subject(:update_request) do
      patch "/movies/#{movie.id}/ratings/#{rating.id}",
        params: { movie_id: movie.id, rating: { points: }, format: :turbo_stream },
        headers: { "HTTP_REFERER" => movies_url }
    end
    let(:owner) { create(:user) }
    let(:movie) { create(:movie) }
    let(:rating) { create(:rating, rated_user: owner, rated_movie: movie, points: 4) }

    context 'with authenticated user' do
      context 'when owner' do
        before { sign_in owner }

        context 'with valid points' do
          let(:points) { 2 }
          it 'finds rating' do
            update_request
            expect(assigns(:rating)).to eq(rating)
          end

          include_examples 'finds movie'
          include_examples 'positive turbo-stream responses', :update

          it 'updates rating' do
            update_request
            expect(assigns(:rating).points).to eq(2)
          end
        end

        context 'with invalid points' do
          let(:points) { 'invalid points' }

          include_examples 'finds movie'

          it 'finds rating' do
            update_request
            expect(assigns(:rating)).to eq(rating)
          end

          it 'redirects back' do
            update_request
            expect(response).to redirect_to(movies_path)
          end

          it 'does not update rating' do
            update_request
            expect(Rating.find_by(id: rating.id).points).to eq(4)
          end

          it 'does not call job' do
            expect { update_request }.not_to have_enqueued_job(RatingCountJob)
          end
        end
      end

      context 'when not owner' do
        let(:user) { create(:user) }
        let(:points) { 2 }

        before { sign_in user }

        it 'does not update rating' do
          update_request
          expect(Rating.find_by(id: rating.id).points).to eq(4)
        end

        include_examples 'non-owner response', :update
      end
    end

    context 'with non-authenticated user' do
      let(:user) { :nil }
      let(:points) { 2 }

      include_examples 'non-authenticated user'
    end
  end

  describe 'DELETE #destroy' do
    subject(:destroy_request) do
      delete "/movies/#{movie.id}/ratings/#{rating.id}",
        params: { movie_id: movie.id, format: :turbo_stream },
        headers: { "HTTP_REFERER" => movies_url }
    end
    let(:owner) { create(:user) }
    let(:movie) { create(:movie) }
    let(:rating) { create(:rating, rated_user: owner, rated_movie: movie, points: 4) }
    context 'with authenticated user' do
      context 'when owner' do
        before { sign_in owner }

        it 'finds rating' do
          destroy_request
          expect(assigns(:rating)).to eq(rating)
        end

        include_examples 'finds movie'
        include_examples 'positive turbo-stream responses', :destroy

        it 'deletes rating from db' do
          rating
          expect { destroy_request }.to change(Rating, :count).by(-1)
        end
      end

      context 'when not owner' do
        let(:user) { create(:user) }

        before { sign_in user }

        it 'does not delete rating from db' do
          rating
          expect { destroy_request }.not_to change(Rating, :count)
        end

        include_examples 'non-owner response', :destroy
      end
    end

    context 'with non-authenticated user' do
      let(:user) { create(:user) }

      include_examples 'non-authenticated user'
    end
  end
end
