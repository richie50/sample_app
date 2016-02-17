require 'spec_helper'

describe "Static pages" do
let(:base_title) { "Forum And Post" }

subject { page }

  describe "Home Page" do
  	before { visit root_path }
    	it { should have_selector('h1',  text: 'Welcome To Forum CSHUB, Lassonde') }
    	it { should have_selector('title',  text: full_title('')) }
    	#it { should_not have_selector('title',  text: '| Home') } 
    end
		
    describe "Help page" do
    	before { visit help_path }
		it { should have_selector('h1',  text: 'Help') }
    	it { should have_selector('title',  text: full_title('Help')) }
    end
    describe "About page" do
		before { visit about_path }
		it { should have_selector('h1',  text: 'About us') }
    	it { should have_selector('title',  text: full_title('About us')) }
    end	
	describe "Current News Page" do
		before { visit newsupdate_path }
		it { should have_selector('h1',  text: 'Current News') }
    	it { should have_selector('title',  text: full_title('Current News')) }
    end 
end 
