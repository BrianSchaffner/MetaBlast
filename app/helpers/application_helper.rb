module ApplicationHelper

	def current_account
		if user_signed_in?
			current_user.accounts.first
		else
			nil
		end
	end
	
	def tab(text, route)
		if current_page?(route)
			li_start = 	"<li id='selected' class='tab small_rounded_top'>"
			link = link_to text, route
			li_end = "</li>"
			(li_start + link + li_end).html_safe
		else
			li_start = 	"<li class='tab small_rounded_top'>"
			link = link_to text, route
			li_end = "</li>"
			(li_start + link + li_end).html_safe
		end
	end
	
	def right_content_button(image, text, route, options = nil)
		span_start = "<span class='button'>"
		link = link_to(route, options) do
			image_tag(image) + text
		end
		span_end = "</span>"
		(span_start + link + span_end).html_safe
	end
	
	def display_bread_crumbs(list)
		seperator = " >> "
		display_html = String.new
		
		list.each do |element|
			case element.class.to_s
				when 'String'
					display_html << element
				when 'Group'
					display_html << link_to(element.name, element)
				when 'Collection'
					display_html << link_to(element.name.to_s, element)
			end # END CASE
			
			unless element == list.last
				display_html << seperator
			end
		end
		
		display_html.html_safe
	
	end
	
end
