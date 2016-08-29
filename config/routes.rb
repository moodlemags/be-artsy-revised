Rails.application.routes.draw do

get   "/"       => "artsy#index"
post  "/artsy"  => "artsy#trigger_artsy_api"
get   "/artsy"  => "artsy#index"

get "/game" => "game#index"
post "/game" => "game#get_game_data"

end
