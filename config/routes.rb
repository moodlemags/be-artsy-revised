Rails.application.routes.draw do

# ROOT ROUTE
get "/"           => "game#welcome_placeholder"
get "/artsy"      => "game#make_artsy_api_call"


# GAME ROUTES
get   "/game"                   =>      "game#get_game_data"
post  "/game"                 =>      "game#get_game_data"
post  "/game/:gene"            =>      "game#find_gene"
post "/game/:gene/true"        =>     "game#confirm_gene"


# LEARN ROUTES
post  "/learn"              =>      "learn#trigger_artsy_api"
get   "/learn"              =>      "learn#index"
post  "/learn/search"       =>      "learn#render_artsy"
post  "/learn/:gene"        =>      "learn#render_gene"
# post  "/learn/more/:gene"   =>       "learn#modal_gene"
#
#

end
