RSpec.shared_examples 'finds movie' do
  it 'finds movie' do
    subject
    expect(assigns(:movie)).to eq(movie)
  end
end

RSpec.shared_examples 'non-authenticated user' do
  it 'responds with 302 status' do
    subject
    expect(response).to have_http_status(:found)
  end

  it 'redirects to sign in page' do
    subject
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'does not call job' do
    expect { subject }.not_to have_enqueued_job(RatingCountJob)
  end
end

RSpec.shared_examples 'non-owner response' do |action|
  it 'redirects user back' do
    subject
    expect(response).to redirect_to(movies_path)
  end

  it 'flashes right alert message' do
    subject
    expect(flash.alert).to eq("You can\'t #{action} other\'s ratings")
  end

  it 'does not call job' do
    expect { subject }.not_to have_enqueued_job(RatingCountJob)
  end
end
