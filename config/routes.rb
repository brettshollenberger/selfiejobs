Rails.application.routes.draw do
  root to: "selfies#index"

  post "selfies" => "selfies#create"
end
