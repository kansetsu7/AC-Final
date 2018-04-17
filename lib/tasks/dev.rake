namespace :dev do
  # fake user
  task fake_user: :environment do
    User.where(role: nil).destroy_all
    puts "creating fake users..."
    # url = "https://uinames.com/api/?ext&region=england"
    for i in 1..20 do
      # response = RestClient.get(url)
      # data = JSON.parse(response.body)

      User.create!(
        email: "user#{i}@email.com",
        name: "user#{i}",
        password: '000000',
        # avatar: data["photo"]
        avatar: FFaker::Avatar.image
      )      
    end
    puts "now you have #{User.count} user data"
  end 

  # fake category
  task fake_category: :environment do
    10.times do
      Category.create!(
        name: FFaker::Skill.unique.tech_skill
      )
    end
  end

  #fake post
  task fake_post: :environment do
    Post.destroy_all
    puts "creating fake posts..."    
    User.all.each do |u|
     u.posts.create!(
      content: FFaker::Lorem.paragraph,
      status: 'Draft',
      title: FFaker::Lorem.phrase,
      authority: 'Self',
      image: FFaker::Avatar.image,
      category_ids: (1...10).to_a.shuffle.take(rand(1..5))
     )
     2.times do
       u.posts.create!(
        content: FFaker::Lorem.paragraph,
        status: 'Published',
        title: FFaker::Lorem.phrase,
        authority: 'All',
        image: FFaker::Avatar.image,
        category_ids: (1...10).to_a.shuffle.take(rand(1..5))
       )

       u.posts.create!(
        content: FFaker::Lorem.paragraph,
        status: 'Published',
        title: FFaker::Lorem.phrase,
        authority: 'Friends',
        image: FFaker::Avatar.image,
        category_ids: (1...10).to_a.shuffle.take(rand(1..5))
       )
     end        
    end
    puts "now you have #{Post.count} posts"
  end 

  # fake comment
  task fake_comment: :environment do
    Comment.destroy_all
    puts "creating fake comments..."
    Post.all.each do |p|
      rand(1..5).times do
        p.comments.create!(
          content: FFaker::Lorem.paragraph,
          user: User.all.sample
        )
      end
    end
    puts "now you have #{Comment.count} comments"
  end

  # fake view
  task fake_view: :environment do
    View.destroy_all
    puts "creating fake views..."
    Post.all.each do |p|
      @users = User.all.shuffle
      rand(0..5).times do
        p.views.create!(
          user: @users.pop
        )
      end
    end
    puts "now you have #{View.count} views"
  end

  # fake collect
  task fake_collect: :environment do
    Collect.destroy_all
    puts "creating fake collects..."
    User.all.each do |u|
      @posts = Post.all.shuffle
      3.times do
        u.collects.create!(
          post: @posts.pop
        )
      end
    end
    puts "now you have #{Collect.count} collects"
  end

  task fake_friendship: :environment do
    Friendship.destroy_all
    puts "creating fake friendship..." 
    status = ['unconfirmed', 'confirmed']
    User.all.each do |u|
      @users = User.where.not(id: u.id).shuffle
      5.times do
        u.friendships.create!(
        friend: @users.pop,
        status: false,
        )      
      end     
    end
    puts "now you have #{Friendship.count} friendship"
    Rake::Task['dev:chk_friendship'].execute
  end

  # checking friendships
  # there may have some duplicated friendships, in that case, the later one should be delete
  # (e.g user1 have firendship with user3, and user3 also have friendship with user1)
  # collect all duplicated friendships' id, then delete it.
  task chk_friendship: :environment do
    if Friendship.all.count == 0
      puts 'Poor you. No friends...'      
      return
    end

    puts "checking friendship..." 
    duplicated_friendships = Array.new(0)
    Friendship.all.each do |f1|
      @operating_friendships = Friendship.all
      @operating_friendships.each do |f2|
        if f1.user_id == f2.friend_id && f2.user_id == f1.friend_id
          if f2.status == 'confirmed'
            duplicated_friendships.push(f2.id)
          else
            f2.update_attribute(:status, 'confirmed')
            Friendship.find(f1.id).update_attribute(:status, 'confirmed')
          end
        end
      end
    end
    Friendship.destroy(duplicated_friendships) # delete duplicated firendships
    puts "#{Friendship.where(status: 'confirmed').count} friendship are confirmed "
  end 

  task test: :environment do
    posts = Post.includes(:comments).all.order('comments.created_at asc')
    puts posts.first.inspect
    puts posts.last.inspect
  end

  #fake all data
  task fake_all: :environment do
    Rake::Task['db:drop'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['db:seed'].execute
    Rake::Task['dev:fake_user'].execute
    Rake::Task['dev:fake_category'].execute
    Rake::Task['dev:fake_post'].execute
    Rake::Task['dev:fake_comment'].execute
    Rake::Task['dev:fake_view'].execute
    Rake::Task['dev:fake_collect'].execute
    Rake::Task['dev:fake_friendship'].execute
  end
end