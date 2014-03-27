# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  nom           :string(255)
#  email         :string(255)
#  dateNaissance :string(255)
#  poid          :float
#  poidIdeal     :float
#  sport         :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
