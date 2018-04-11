module ApplicationHelper

  def show_user_mail(user)
    user.role == 'admin' ? user.mail + '(Admin)' : user.mail
  end
end
