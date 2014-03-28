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



  def participants
    @participants = self.clients.count
  end
  
  def converted
      
  end

  def measure
    conversion_rate
  end

  private 

  def conversion_rate
    @conversion_rate ||= (participants > 0 ? converted.to_f/participants.to_f  : 0.0)
  end

end
