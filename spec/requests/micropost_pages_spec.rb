require 'spec_helper'

describe "MicropostPages" do
      subject { page }
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      describe "micropost creation" do
        before { visit root_path }
        describe "invalid information" do
          
          it "should not be able to create a micropost" do
            expect { click_button "Post"}.should_not change(Micropost, :count)
          end
        describe "error messages" do
          before { click_button "Post" }
          it { should have_content('error') }
          end  
        end
        describe "with valid infomation" do
          before { fill_in 'micropost_content', with: "Lorem ipsum" }
          it "should create a micropost" do
            expect { click_button "Post"}.should change(Micropost, :count).by(1)
          end  
      end
    end
end
