module UsersHelper

  def role(user)
    "Админ" if user.admin?
    "Менеджер" if user.manager?
    "Нет" unless user.admin? and user.manager?
  end

end
