def full_title(page_title)
	base_tilte = "Forum and Post"
	if page_title.empty?
		base_tilte
	else
		"#{base_tilte} | #{page_title}"
	end	
end	