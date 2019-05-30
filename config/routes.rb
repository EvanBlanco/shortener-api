Rails.application.routes.draw do
	resources :shortened_urls

	#root to: 'shortened_urls#index'
	post "/shortened_urls/most_frequents"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
