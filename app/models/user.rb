class User < ApplicationRecord
  %i[:name, :phone_number, :email].each do |val|
    validates_presence_of  val
  end

  DAUSO_VIETNAM = %w(03 05 07 08 09)
end
