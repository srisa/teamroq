module GroupsHelper
  def add_users_to_group user_list,group_id
    group = Group.find(group_id)
    logger.debug "User list #{user_list} and group id #{group_id}"
    user_arr = user_list.split(',')
    user_arr.each do |u|
      user = User.find(u.strip)
      unless user.nil?
        existing_group = user.groups.where(:id => group_id)
        if existing_group.empty?
          logger.debug "User #{user.name} not present in group #{group_id} so adding it"
          user.groups.push(group)
        end
      end
    end
  end
end
