require 'rails_helper'

RSpec.describe Name, type: :model do
  # Association test
  it { should have_many(:years).dependent(:destroy) }

  # Validation tests
  it { should validate_presence_of(:name_ka) }
  it { should validate_presence_of(:name_en) }

end
