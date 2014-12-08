module AcceptanceHelpers
	def fill_autocomplete(field, options = {})
	  fill_in field, with: options[:with]

	  page.execute_script %Q{ $('##{field}').trigger('focus') }
	  page.execute_script %Q{ $('##{field}').trigger('keydown') }
	  selector = %Q{ul.ui-autocomplete li.ui-menu-item a:contains("#{options[:select]}")}

	  page.should have_selector('ul.ui-autocomplete li.ui-menu-item a')
	  page.execute_script %Q{ $('#{selector}').trigger('mouseenter').click() }
	end

	def create_badges
		FactoryGirl.create(:type)
		FactoryGirl.create(:type, :name => 'Promoter')
		FactoryGirl.create(:type, :name => 'Enlightened')
		FactoryGirl.create(:type, :name => 'Commenter')
		FactoryGirl.create(:type, :name => 'Curious')

	end
end
