module ApplicationHelper

  def show_user_mail(user)
    user.role == 'admin' ? user.mail + '(Admin)' : user.mail
  end

  def sortable(column, title = nil)
    title ||= column
    if column == current_title && sort_direction == 'asc'
      direction = 'desc'
      icon_direction = "sort-up"
    else
      direction = 'asc'
      icon_direction = 'sort-down'
    end

    if column == current_title
      link_to(icon('fas', icon_direction, column, class: 'fa-pull-right'), :sort => column, :direction => direction)
    else
      link_to(icon('fas', icon_direction, column, class: 'fa-pull-right'), :sort => column, :direction => direction)
    end
    # 
  end
end
