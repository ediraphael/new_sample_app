# En utilisant le symbole ':user', nous faisons que
# Factory Girl simule un modèle User.
Factory.define :user do |user|
	user.nom                  	"Raphael Pillie"
	user.email                 	"contact@raphael-pillie.com"
	user.password              	"totoro"
	user.password_confirmation 	"totoro"
	user.poid					80
	user.poidIdeal				70
end