RSpec.shared_examples 'positive turbo-stream responses' do |template|
  it 'responds with 200 status' do
    subject
    expect(response).to have_http_status(:ok)
  end

  it "renders #{template} template" do
    subject
    expect(response).to render_template(template)
  end

  it 'calls job' do
    expect { subject }.to have_enqueued_job(RatingCountJob).with(movie.id)
  end
end
