require 'spec_helper'

describe "User Pages" do

	subject { page }
  
  #test for users in the index page Users
  describe "index page for all users" do
	  let(:user) { FactoryGirl.create(:user) }
  	before(:each) do
		sign_in user		
		visit users_path
	end
	it { should have_selector('title',  text: 'All users') }
	it { should have_selector('h1',  text: 'All users') }
	
	describe "pagination" do		
	    #it { should have_selector('div.pagination') }
		
		it "should list each user" do
			User.paginate(page: 1).each do |user|
			page.should have_selector('li' , text: user.name)
			end
		end
	end
    #end	
	describe "delete links" do
		it { should_not have_link('delete') }
		describe "As an admin user" do
			let(:admin) { FactoryGirl.create(:admin) }
			before do
				sign_in admin
				visit users_path
			end
			it { should have_link('delete' , href: user_path(User.first)) }
			it "should be able to delete another user upon misconduct" do
				expect { click_link('delete') }.to change(User, :count).by(-1)
			end
			it { should_not have_link('delete', href: user_path(admin)) }		
		end	
	end
   end	
  describe "signup page" do
  
  	before { visit signup_path }
  	let(:submit) {"Create an account" }
  	
  	describe "with invalid information" do
		it "should not create a user" do
			expect { click_button submit }.not_to change(User, :count)
		end
	end
  	
  describe "with valid information" do
		before do
			fill_in "Name", 	with: "Example User"
			fill_in "Email" ,	with: "user@example.com"
			fill_in "Password",	with: "foobar"
			fill_in "Confirm your password",  with: "foobar"
		end
		it "should create a user" do
			expect  { click_button submit }.to change(User, :count).by(1)
		end
		 
		describe "after saving the user" do
			before { click_button submit }
			let(:user) { User.find_by_email('user@example.com') }
	
			it { should have_selector('title', text: user.name) }
			it { should have_selector('div.alert.alert-success', text: 'Welcome') }
			it { should have_link('Sign out') }
		end
		
		#describe "followed by signout" do
			#before { click_link "Sign out" }
			#it { should have_link('Sign in') }
		# end		
	end
    it { should have_selector('h2', text: 'Sign Up') } 
    it { should have_selector('title', text: full_title('Sign Up')) } 
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
  end
  
  describe "profile pages" do
  	let(:user) { FactoryGirl.create(:user) }
  	let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "YEET") }
	let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "BINGO") }
  	
  	before { visit user_path(user) }
  	
  	it { should have_selector('h1', text: user.name) }
  	it { should have_selector('title', text: user.name) }
  	
  	 # Showing micropost
	
	describe "micropost" do
		it { should have_content(m1.content) }
		it { should have_content(m2.content) }
		it { should have_content(user.microposts.count) }
	  end
  end
  
  describe "edit" do
	  let(:user) {FactoryGirl.create(:user) }
	  before do
		  sign_in user
		  visit edit_user_path(user)
		end  
	  
	  describe "page" do
		it { should have_selector('h1' , text: "Update your profile")}
		it { should have_selector('title' , text: "Edit user")}
		it { should have_link('change' , href: 'http://gravatar.com/emails')}
	  end
	  describe "with invalid information" do
		before{click_button "Save changes"}
		
		it {should have_content('error')}
	  end
	  #after updating the user information test cases 
	describe "with valid information" do
		  let(:new_name) {user.name}
		  let(:new_email) {user.email}
		  before do
			  fill_in "Name" , with: new_name
			  fill_in "Email" , with: new_email
			  fill_in "Password" , with: user.password
			  fill_in "Password" , with: user.password
			click_button "Save changes"
		end
		it {should have_selector('title' , text: 'Edit user')}
		#it { should have_selector('div.alert.alert-success')}
		it { should have_link('Sign out' , href: signout_path) }
		#making sure it displays the right information after updating
		specify{user.reload.name.should == new_name}
		specify{user.reload.email.should == new_email}
	end	
  end	  
  
end
