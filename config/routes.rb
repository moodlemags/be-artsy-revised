Rails.application.routes.draw do

get   "/"                   =>      "artsy#index"
post  "/artsy"              =>      "artsy#trigger_artsy_api"
get   "/artsy"              =>      "artsy#index"
post  "/artsy/search"       =>      "artsy#render_artsy"

get   "/game"               =>      "game#index"
post  "/game"               =>      "game#get_game_data"

end
