# == Schema Information
#
# Table name: variations
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  experiment_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Variation < ActiveRecord::Base
  belongs_to :experiment
  has_many :assignments, dependent: :destroy 
  has_many :clients, through: :assignments
  validates :name, presence: true, uniqueness: { scope: :experiment_id }
end
