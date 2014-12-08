type = Type.find_or_create_by_name('Team Player')
badge = Badge.create({ 
                      :name => 'Level 1', 
                      :points => '50',
                      :type_id  => type.id,
                      :default => 'false'
                    })
puts '> Badge successfully created'