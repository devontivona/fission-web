# == Schema Information
#
# Table name: apps
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  access_token :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class App < ActiveRecord::Base
  has_many :experiments
  has_many :clients

  before_create :generate_access_token
  
  validates :access_token, uniqueness: true
  validates :name, presence: true, uniqueness: true

private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

end
