# == Schema Information
#
# Table name: assignments
#
#  id           :integer          not null, primary key
#  client_id    :integer
#  variation_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Assignment < ActiveRecord::Base
  belongs_to :client
  belongs_to :variation
end
