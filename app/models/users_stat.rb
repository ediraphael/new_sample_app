# encoding: UTF-8
class UsersStat
	#initilisation des variables
	def initialize(users)
		@users = users
		@users_nom = Array.new
		@poids = Array.new
		@poids_ideaux = Array.new
		@tableau_imc = Array.new
		@noms_imc = Array.new
	end
	
	#pour tous les utilisateurs on va chercher les poids actuels
	def nom_users
		@users.each do |user|
			@users_nom << [user.nom]
		end
		@users_nom
	end

	def noms_imc
		@users.each do |user|
			@noms_imc << user.imc.split(/\s:\s/)[0]
		end
		@noms_imc
	end
	
	def poids_users
		@users.each do |user|
			@poids << [user.nom,user.poid]
		end
		@poids
	end
	
	def poids_ideaux_users
		@users.each do |user|
			@poids_ideaux << [user.nom.to_s,user.poidIdeal]
		end
		@poids_ideaux
	end

	def repartition_imc
		repartition_imc = []
		@users.each do |user|
			repartition_imc << user.imc.split(/\s:\s/)[0]
		end

		counts = Hash.new(0)
		for imc in repartition_imc
			counts[imc] += 1
		end

		counts.each do |k,v|
			@tableau_imc << (v.to_f/counts.count)*100
		end
		@tableau_imc
  end
end