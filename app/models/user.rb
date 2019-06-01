class User < ApplicationRecord
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  %i[:name, :phone_number, :email].each do |val|
    validates_presence_of  val
  end
end
