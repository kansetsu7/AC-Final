module ApplicationHelper

  def show_user_mail(user)
    user.role == 'admin' ? user.email + '(Admin)' : user.email
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

  def latest_comment_time(post)
    puts "post_id: #{post.id}"
    post.comments == [] ? 'No reply' : post.comments.latest_time
  end
end
