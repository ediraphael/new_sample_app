# encoding: UTF-8
require 'spec_helper'

describe UsersController do
	render_views

	describe "GET 'show'" do
		before(:each) do
			@user = Factory(:user)
		end

		it "devrait reussir" do
			get :show, :id => @user
			response.should be_success
		end

		it "devrait trouver le bon utilisateur" do
			get :show, :id => @user
			assigns(:user).should == @user
		end

		it "devrait avoir le bon titre" do
			get :show, :id => @user
			response.should have_selector("title", :content => @user.nom)
		end

		it "devrait inclure le nom de l'utilisateur" do
			get :show, :id => @user
			response.should have_selector("h1", :content => @user.nom)
		end
	end

	describe "GET 'new'" do
	
		it "devrait reussir" do
			get 'new'
			response.should be_success
		end

		it "devrait avoir le bon titre" do
			get 'new'
			response.should have_selector("title", :content => "Inscription")
		end

		it "devrait avoir un champ nom" do
			get :new
			response.should have_selector("input[name='user[nom]'][type='text']")
		end

		it "devrait avoir un champ email" do
			get :new
			response.should have_selector("input[name='user[email]'][type='text']")
		end

		it "devrait avoir un champ mot de passe" do
			get :new
			response.should have_selector("input[name='user[password]'][type='password']")
		end

		it "devrait avoir un champ confirmation du mot de passe" do
			get :new
			response.should have_selector("input[name='user[password_confirmation]'][type='password']")
		end
		
		it "devrait avoir un champ poid" do
			get :new
			response.should have_selector("input[name='user[poid]'][type='text']")
		end
		
		it "devrait avoir un champ poid Ideal" do
			get :new
			response.should have_selector("input[name='user[poidIdeal]'][type='text']")
		end
		
		it "devrait avoir un bouton d'enregistrement" do
			get :new
			response.should have_selector("input[name='commit'][type='submit']")
		end
	end

	describe "POST 'create'" do
		describe "echec" do
			before(:each) do
				@attr = { :nom => "", :email => "", :password => "",
						:password_confirmation => "" }
			end

			it "ne devrait pas creer d'utilisateur" do
				lambda do
					post :create, :user => @attr
				end.should_not change(User, :count)
			end

			it "devrait avoir le bon titre" do
				post :create, :user => @attr
				response.should have_selector("title", :content => "Inscription")
			end

			it "devrait rendre la page 'new'" do
				post :create, :user => @attr
				response.should render_template('new')
			end
		end

		describe "succes" do
			before(:each) do
				@attr = { 	:nom => "New User", 
							:email => "user@example.com",
							:password => "foobar", 
				            :password_confirmation => "foobar",
				            :poid => 80,
				            :poidIdeal => 70}
			end

			it "devrait creer un utilisateur" do
				lambda do
					post :create, :user => @attr
				end.should change(User, :count).by(1)
			end

			it "devrait rediriger vers la page d'affichage de l'utilisateur" do
				post :create, :user => @attr
				response.should redirect_to(user_path(assigns(:user)))
			end

			it "devrait avoir un message de bienvenue" do
				post :create, :user => @attr
				flash[:success].should =~ /Bienvenue dans l'Application Exemple/i
			end

			it "devrait identifier l'utilisateur" do
				post :create, :user => @attr
				controller.should be_signed_in
			end
		end
	end

	describe "GET 'edit'" do
		before(:each) do
			@user = Factory(:user)
			test_sign_in(@user)
		end

		it "devrait réussir" do
			get :edit, :id => @user
			response.should be_success
		end

		it "devrait avoir le bon titre" do
			get :edit, :id => @user
			response.should have_selector("title", :content => "Édition profil")
		end
		
		it "devrait avoir un champ nom" do
			get :edit, :id => @user
			response.should have_selector("input[name='user[nom]'][type='text']")
		end

		it "devrait avoir un champ email" do
			get :edit, :id => @user
			response.should have_selector("input[name='user[email]'][type='text']")
		end

		it "devrait avoir un champ mot de passe" do
			get :edit, :id => @user
			response.should have_selector("input[name='user[password]'][type='password']")
		end

		it "devrait avoir un champ confirmation du mot de passe" do
			get :edit, :id => @user
			response.should have_selector("input[name='user[password_confirmation]'][type='password']")
		end
		
		it "devrait avoir un champ date" do
			get :edit, :id => @user
			response.should have_selector("input[name='user[dateNaissance]'][type='text']")
		end
		
		it "devrait avoir un champ taille" do
			get :edit, :id => @user
			response.should have_selector("input[name='user[taille]'][type='text']")
		end
		
		it "devrait avoir un champ poid" do
			get :edit, :id => @user
			response.should have_selector("input[name='user[poid]'][type='text']")
		end
		
		it "devrait avoir un champ poidIdeal" do
			get :edit, :id => @user
			response.should have_selector("input[name='user[poidIdeal]'][type='text']")
		end
		
		it "devrait avoir un champ pratiqueUnSport" do
			get :edit, :id => @user
			response.should have_selector("input[name='user[sport]'][type='radio']")
		end
		
		it "devrait avoir un champ souhaitePratiquerSport" do
			get :edit, :id => @user
			response.should have_selector("input[name='user[aimeSport]'][type='radio']")
		end
		
		it "devrait avoir un champ Cv" do
			get :edit, :id => @user
			response.should have_selector("input[name='user[cv]'][type='file']")
		end
		
		it "ne devrait pas avoir de champ admin" do
			get :edit, :id => @user
			response.should_not have_selector("input[name='user[admin]'][type='radio']")
		end
		
		it "devrait avoir de champ admin" do
			@user.admin = 1
			get :edit, :id => @user
			response.should have_selector("input[name='user[admin]'][type='radio']")
		end
		
		it "devrait avoir un bouton d'enregistrement" do
			get :edit, :id => @user
			response.should have_selector("input[name='commit'][type='submit']")
		end
	end

	describe "PUT 'update'" do
		before(:each) do
			@user = Factory(:user)
			test_sign_in(@user)
		end

		describe "Échec" do
			before(:each) do
				@attr = { :email => "", :nom => "", :password => "",
							:password_confirmation => "" }
			end

			it "devrait retourner la page d'édition" do
				put :update, :id => @user, :user => @attr
				response.should render_template('edit')
			end

			it "devrait avoir le bon titre" do
				put :update, :id => @user, :user => @attr
				response.should have_selector("title", :content => "Édition profil")
			end
		end

		describe "succès" do
			before(:each) do
				@attr = { :nom => "New Name", :email => "user@example.org",
						:password => "barbaz", :password_confirmation => "barbaz",
						:poid => 70 , :poidIdeal => 60
						}
			end

			it "devrait modifier les caractéristiques de l'utilisateur" do
				put :update, :id => @user, :user => @attr
				@user.reload
				@user.nom.should  == @attr[:nom]
				@user.email.should == @attr[:email]
			end

			it "devrait rediriger vers la page d'affichage de l'utilisateur" do
				put :update, :id => @user, :user => @attr
				response.should redirect_to(user_path(@user))
			end

			it "devrait afficher un message flash" do
				put :update, :id => @user, :user => @attr
				flash[:success].should =~ /actualisé/
			end
		end
	end

	describe "authentification des pages edit/update" do
		before(:each) do
			@user = Factory(:user)
		end

		describe "pour un utilisateur non identifié" do
			it "devrait refuser l'acccès à l'action 'edit'" do
				get :edit, :id => @user
				response.should redirect_to(signin_path)
			end

			it "devrait refuser l'accès à l'action 'update'" do
				put :update, :id => @user, :user => {}
				response.should redirect_to(signin_path)
			end
		end

		describe "pour un utilisateur identifié" do
			before(:each) do
				wrong_user = Factory(:user, :email => "user@example.net")
				test_sign_in(wrong_user)
			end

			it "devrait correspondre à l'utilisateur à éditer" do
				get :edit, :id => @user
				response.should redirect_to(root_path)
			end

			it "devrait correspondre à l'utilisateur à actualiser" do
				put :update, :id => @user, :user => {}
				response.should redirect_to(root_path)
			end
		end
	end

	describe "DELETE 'destroy'" do
		before(:each) do
			@user = Factory(:user)
		end

		describe "en tant qu'utilisateur non identifié" do
			it "devrait refuser l'accès" do
				delete :destroy, :id => @user
				response.should redirect_to(signin_path)
			end
		end

		describe "en tant qu'utilisateur non administrateur" do
			it "devrait protéger la page" do
				test_sign_in(@user)
				delete :destroy, :id => @user
				response.should redirect_to(root_path)
			end
		end

		describe "en tant qu'administrateur" do
			before(:each) do
				admin = Factory(:user, :email => "admin@example.com", :admin => true)
				test_sign_in(admin)
			end

			it "devrait détruire l'utilisateur" do
				lambda do
					delete :destroy, :id => @user
				end.should change(User, :count).by(-1)
			end

			it "devrait rediriger vers la page des utilisateurs" do
				delete :destroy, :id => @user
				response.should redirect_to(users_path)
			end
		end
	end
end
