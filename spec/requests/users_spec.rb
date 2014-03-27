# encoding: UTF-8
require 'spec_helper'

describe "Users" do
	describe "une inscription" do
		describe "ratee" do
			it "ne devrait pas creer un nouvel utilisateur" do
				lambda do
					visit signup_path
					fill_in "nom", :with => ""
					fill_in "email", :with => ""
					fill_in "Mot de passe", :with => ""
					fill_in "Confirmation", :with => ""
					click_button
					response.should render_template('users/new')
					response.should have_selector("div#error_explanation")
				end.should_not change(User, :count)
			end
		end

		describe "reussie" do
			it "devrait creer un nouvel utilisateur" do
				lambda do
					visit signup_path
					fill_in "nom", :with => "Example User"
					fill_in "email", :with => "user@example.com"
					fill_in "Mot de passe", :with => "foobar"
					fill_in "Confirmation", :with => "foobar"
					fill_in "Poid", :with => 80
					fill_in "Poid Ideal", :with => 70
					#choose pour radio
					click_button
					response.should have_selector("div.flash.success",
												:content => "Bienvenue")
					response.should render_template('users/show')
				end.should change(User, :count).by(1)
			end
		end
	end

	describe "identification/deconnexion" do
		describe "l'echec" do
			it "ne devrait pas identifier l'utilisateur" do
				visit signin_path
				fill_in "eMail",    :with => ""
				fill_in "Mot de passe", :with => ""
				click_button
				response.should have_selector("div.flash.error", :content => "invalid")
			end
		end

		describe "le succes" do
			it "devrait identifier un utilisateur puis le deconnecter" do
				user = Factory(:user)
				visit signin_path
				fill_in "email",    :with => user.email
				fill_in "Mot de passe", :with => user.password
				click_button
				controller.should be_signed_in
				click_link "Déconnexion"
				controller.should_not be_signed_in
			end
		end
	end
end
