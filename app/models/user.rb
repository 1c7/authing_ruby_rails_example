# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  authing_access_token :text
#  authing_id_token     :text
#  email                :string
#  name                 :string
#  phone                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  authing_user_id      :string
#
class User < ApplicationRecord
end
