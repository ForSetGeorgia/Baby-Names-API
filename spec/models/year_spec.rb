require 'rails_helper'

RSpec.describe Year, type: :model do
  # Association test
  it { should belong_to(:name) }

  # Validation tests
  it { should validate_presence_of(:year) }

end
