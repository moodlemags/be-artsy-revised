Rails.application.routes.draw do

get   "/"                   =>      "learn#index"
post  "/learn"              =>      "learn#trigger_artsy_api"
get   "/learn"              =>      "learn#index"
post  "/learn/search"       =>      "learn#render_artsy"
post  "/learn/search/:gene"  =>     "learn#render_artsy"
post  "/game"               =>      "game#get_game_data"

post   "/game/:gene"         =>     "game#find_gene"
end
