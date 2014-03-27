# encoding: UTF-8
# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  nom           :string(255)
#  email         :string(255)
#  dateNaissance :string(255)
#  poid          :float
#  poidIdeal     :float
#  sport         :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'digest'
class User < ActiveRecord::Base
	has_attached_file :cv ,:styles => {:thumb => ["400x600", :png]}
	attr_accessor :password
	attr_accessible :nom, :email, :password, :password_confirmation, :admin, :dateNaissance, :poid, :poidIdeal, :sport, :aimeSport, :taille, :cv

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates 	:nom, 
				:presence => true,
				:length   => { :maximum => 50 }
	validates 	:email, :presence => true,
				:format   => { :with => email_regex },
				:uniqueness  => { :case_sensitive => false }
	# Crée automatique l'attribut virtuel 'password_confirmation'.
	validates 	:password, 
				:presence     => true,
				:confirmation => true,
				:length       => { :within => 6..40 }
	validates_numericality_of :poid, :greater_than_or_equal_to => Proc.new {|user| user.poidIdeal.to_f }
	
	before_save :encrypt_password, :check_admin

	# Retour true (vrai) si le mot de passe correspond.
	def has_password?(password_soumis)
		encrypted_password == encrypt(password_soumis)
	end

	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil  if user.nil?
		return user if user.has_password?(submitted_password)
	end

	def self.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		(user && user.salt == cookie_salt) ? user : nil
	end
	
	def imc
		if self.taille.nil? || self.poid.nil?
			retour = "Information insuffisante"
		else
			imc = (self.poid/((self.taille/100.0)**2)).round(2)
			imc_complement = case  imc
							when 0...16  
								"dénutrition"
							when 16...18  
								"maigreur"
							when 18...25  
								"normal"
							when 25...30  
								"surpoids"
							when 30...35  
								"obésité modérée"
							when 35...40  
								"obésité sévère"
							else 
								"obésité massive"	
						end	
			imc_complement += " : #{imc}"
		end
	end
	
	def age
		if self.dateNaissance
			if self.dateNaissance > Date.today
				"Marty McFly ???"
			else
				date = Time.now;
				anniv = Time.new(self.dateNaissance.year,self.dateNaissance.month,self.dateNaissance.day)
				age = (date-anniv)/31536000
				age = age.to_i;
				age
			end
		else
			"Information insuffisante"
		end
	end

	private
		def check_admin
			self.admin = 0 if admin==1 && current_user && current_user.admin?
		end

		def encrypt_password
			self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(password)
		end

		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end

		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end

		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end
