# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'associations' do
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:polls).through(:votes) }
    it { should have_many(:questions).through(:votes) }
  end

  describe 'validations' do
    it { should validate_presence_of(:ip) }
  end
end
