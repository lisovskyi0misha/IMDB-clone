RSpec.shared_examples 'positive GET responses' do |template|
  it 'responds with status 200' do
    subject
    expect(response).to have_http_status(:ok)
  end

  it "renders #{template} template" do
    subject
    expect(response).to render_template(template)
  end
end
