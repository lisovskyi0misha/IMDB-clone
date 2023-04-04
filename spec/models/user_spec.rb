require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of(:name) }

  it { should have_many(:ratings) }
  it { should have_many(:rated_movies).through(:ratings) }
end
