def full_title(page_title)
	base_tilte = "Forum and Post"
	if page_title.empty?
		base_tilte
	else
		"#{base_tilte} | #{page_title}"
	end	
end
def sign_in(user)
		visit signin_path
		fill_in "Email", with: user.email
		fill_in "Password", with: user.password
		click_button "Sign in"
		#remember the session
		cookies[:remember_token] = user.remember_token
end
def content(args)
	return args
end