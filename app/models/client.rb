# == Schema Information
#
# Table name: clients
#
#  id           :integer          not null, primary key
#  library      :string(255)
#  version      :string(255)
#  manufacturer :string(255)
#  os           :string(255)
#  os_version   :string(255)
#  model        :string(255)
#  carrier      :string(255)
#  token        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  app_id       :integer
#

class Client < ActiveRecord::Base
  belongs_to :app
  has_many :assignments, dependent: :destroy
  has_many :variations, through: :assignments

  validates :library, presence: true
  validates :version, presence: true
  validates :manufacturer, presence: true
  validates :os, presence: true
  validates :os_version, presence: true
  validates :model, presence: true
  validates :token, presence: true, uniqueness: true
  validates :app, presence: true

  def carrier
    carrier = read_attribute(:carrier)
    carrier ||= "Unknown"
  end

  def name
    "#{model} (#{token})"
  end
end
