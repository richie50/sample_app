require 'spec_helper'


describe "AuthenticationPages" do
  
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_selector('title', text: user.name) }

      it { should have_link('Users',    href: users_path) } #added after ch 9
      it { should have_link(user.name , href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) } #make sure this test pass
      it { should have_link('Sign out', href: signout_path) }
      
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
        end
      end  
  end
  
  describe "Authorization" do
    describe "for non-signed in users" do
      let(:user) {FactoryGirl.create(:user)}
      
      #friendly forwarding test
      describe  "when attempting to visit  protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
         end
          #micropost testing new
        describe "in Micropost controller" do
        
        describe "submitting create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end
        describe "submitting to the create action" do
          before do
            micropost = FactoryGirl.create(:micropost)
            delete micropost_path(micropost)
          end
          specify { response.should redirect_to(signin_path) }
         end
        end #micropost end
        describe "after signin in" do
          
          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')    
          end 
        
        describe "when signin in again" do
          before do
            visit signin_path
            fill_in "Email", with: user.email
            fill_in "Password", with: user.password
            click_button "Sign in"
          end
          it "should render to default profile page" do
            page.should have_selector('title', text: user.name)   
           end 
        end 
      end
      end  
      
      describe "in Users controller" do
        
        describe "visiting edit page" do
          before {visit edit_user_path(user)}
          it { should have_selector('title' , text: 'Sign in')}  
        end
        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path)}
        end
        
        describe "visiting the user index page" do
          before { visit users_path }
          it { should have_selector('title' , text: 'Sign in')}
        end  
      end
    end
    #why???
    describe "as wrong user" do
      let(:user) {FactoryGirl.create(:user)}
      let(:wrong_user) {FactoryGirl.create(:user , email: "wrong@example.com")}
      before { sign_in user }
    
      describe "visiting Users (number) edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('tilte' , text: full_title('Edit user')) }
      end
     
       describe "before updating using PUT to update a wrong user action " do
         before { put user_path(wrong_user) }
         specify { response.should redirect_to(root_path) }
       end
    end
    #To make sure an attacker doesnt user curl delete to directly get admin rights and delete legitimate users
    describe "as non-admin users" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }
      
      before { sign_in non_admin }
      
      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end  
    end   
  end #autorization
end