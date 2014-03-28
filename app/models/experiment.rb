# == Schema Information
#
# Table name: experiments
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  app_id     :integer
#  is_active  :boolean, default:true
#  best_variation_id :integer
#  base_variation_id :integer
#  worst_variation_id :integer
#  choice_variation_id :integer
#  outcome_variation_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Experiment < ActiveRecord::Base
  belongs_to :app
  has_many :variations, dependent: :destroy
  has_many :clients, through: :variations
  belongs_to :best, class_name: "Variation", foreign_key: "best_variation_id", dependent: :destroy
  belongs_to :base, class_name: "Variation", foreign_key: "base_variation_id", dependent: :destroy
  belongs_to :worst, class_name: "Variation", foreign_key: "worst_variation_id", dependent: :destroy
  belongs_to :choice, class_name: "Variation", foreign_key: "choice_variation_id", dependent: :destroy
  belongs_to :outcome, class_name: "Variation", foreign_key: "outcome_variation_id", dependent: :destroy


  accepts_nested_attributes_for :variations
  validates :name, presence: true, uniqueness: { scope: :app_id }
  validates :app, presence: true
  validates :variations, length: { minimum: 1 }
end
