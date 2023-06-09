require 'rails_helper'

RSpec.describe Movie do
  it { should validate_presence_of(:title) }
  it do
    create(:movie)
    should validate_uniqueness_of(:title)
  end
  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:category) }
  it { should validate_numericality_of(:rating).is_in(0..10) }

  it { should have_many(:ratings).dependent(:destroy) }
  it { should have_many(:rated_users).through(:ratings).dependent(:nullify) }
  it { should have_one_attached(:image) }
  it { should have_one_attached(:trailer) }

  it { should define_enum_for(:category).with_values(%i[action fantasy western cartoon comedy]) }
end
