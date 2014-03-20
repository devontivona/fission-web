# == Schema Information
#
# Table name: experiments
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  app_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class Experiment < ActiveRecord::Base
  belongs_to :app
  has_many :variations, dependent: :destroy
  has_many :clients, through: :variations

  accepts_nested_attributes_for :variations
  validates :name, presence: true, uniqueness: { scope: :app_id }
  validates :app, presence: true
  validates :variations, length: { minimum: 1 }
end
