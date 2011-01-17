Connecc::Application.routes.draw do

  devise_for :users

  resource :trial_order
  resources :google_orders
  resources :orders

  namespace "admin" do
    resources :orders do
      member do
        match 'cancel'
        post 'ship'
        get 'cards', :defaults => { :format => :pdf }
        get 'envelope', :defaults => { :format => :pdf }
      end
    end
    resources :users
    get "cards/cutting_sheet" => "cards#cutting_sheet", :defaults => { :format => :pdf }
    get "cards/perforating_sheet" => "cards#perforating_sheet", :defaults => { :format => :pdf }
    get "/" => "admin#dashboard"
  end

  get "tour" => "home#tour"
  get "about_us" => "home#about_us"
  get "contact_us" => "home#contact_us"
  get "faq" => "home#faq"
  get "terms" => "home#terms"

  scope ':code', :code => /\w{5}/, :module => 'cards' do
    resource :card, :path => '/' do
      resource :contact_request
      resource :notification_request
    end
  end

  root :to => "home#home"
end
