class User < ActiveRecord::Base

  belongs_to :responsibility
  belongs_to :city
  belongs_to :congregation
  validates_presence_of :first_name, :last_name, :email, :phone

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  def self.current_user
    Thread.current[:current_user]
  end

  def self.current_user=(user)
    Thread.current[:current_user] = user
  end

  def admin?
    admin
  end

  def manager?
    manager == 1
  end

end
