require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  I18n.available_locales.each do |locale|

    before do
      visit signin_path(locale)
      valid_sign_in(user)
    end

    describe "micropost creation" do
      let(:post) { t('static_pages.home.post') }

      before { visit locale_root_path(locale) }

      context "with invalid information" do

        it "should not create a micropost" do
          expect { click_button post }.to_not change(Micropost, :count)
        end

        describe "error messages" do
          before { click_button post }
          it { should have_alert_message('error') }
        end
      end

      context "with valid information" do
        let(:micropost_content) { 'micropost_content' }

        before { fill_in micropost_content, with: "Lorem Ipsum" }

        it "should create a micropost" do
          expect { click_button post }.to change(Micropost, :count).by(1)
        end
      end
    end

    describe "micropost destruction" do
      before { FactoryGirl.create(:micropost, user: user) }

      context "as correct user" do
        let(:delete) { t('shared.delete_micropost.delete') }

        before { visit locale_root_path(locale) }

        it "should delete a micropost" do
          expect { click_link delete }.to change(Micropost, :count).by(-1)
        end
      end

      context "as an incorrect user" do
        let(:other_micropost) do
          FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
        end
        let(:other_micropost_path) { micropost_path(locale, other_micropost) }

        before { delete other_micropost_path }

        subject { response }

        it { should redirect_to(locale_root_path(locale)) }

        it "should not delete a micropost" do
          expect { delete other_micropost_path }.to_not(
            change(Micropost, :count).by(-1))
        end
      end
    end

    describe "pagination" do
      before do
        FactoryGirl.create_list(:micropost, 31, user: user)
        visit locale_root_path(locale)
      end
      after { Micropost.delete_all }

      let(:next_page) { t('will_paginate.next_label') }

      it { should have_link(next_page) }
      its(:html) { should match('>2</a>') }

      it "should list each micropost" do
        Micropost.all[0..2].each do |micropost|
          # Each name should be a link (span>a)
          page.should have_selector('span>a', text: micropost.user.name)
        end
      end
    end

    describe "sidebar" do
      before { visit locale_root_path(locale) }

      describe "micropost counts" do
        let(:one)   { t('shared.user_info.microposts', count: 1) }
        let(:other) do
          t('shared.user_info.microposts', count: user.microposts.count)
        end

        context "when user has zero microposts" do
          it { should have_selector('span', text: other) }
          it { should_not have_selector('span', text: one) }
        end

        context "when user has one micropost" do
          before do
            FactoryGirl.create(:micropost, user: user)
            visit locale_root_path(locale)
          end

          it { should have_selector('span', text: one) }
        end

        context "when user has multiple microposts" do
          before do
            FactoryGirl.create_list(:micropost, 2, user: user)
            visit locale_root_path(locale)
          end

          it { should have_selector('span', text: other) }
          it { should_not have_selector('span', text: one) }
        end
      end
    end

    describe "feed" do
      let!(:current_user_micropost) do
        FactoryGirl.create(:micropost, user: user)
      end

      before { visit locale_root_path(locale) }

      describe "delete links" do
        let(:delete) { t('shared.delete_micropost.delete') }

        context "for user's microposts" do
          it { should have_link(delete, href: micropost_path(locale,
                                                current_user_micropost)) }
        end

        context "for other user's microposts" do
          let(:other_micropost) { FactoryGirl.create(:micropost,
                                    user: FactoryGirl.create(:user)) }

          before { visit locale_root_path(locale) }

          it { should_not have_link(delete,
                            href: micropost_path(locale, other_micropost)) }
        end
      end
    end
  end
end
