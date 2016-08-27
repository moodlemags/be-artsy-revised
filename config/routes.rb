Rails.application.routes.draw do

get   "/"       => "artsy#index"
post  "/artsy"  => "artsy#trigger_artsy_api"
get   "/artsy"  => "artsy#index"

end
