Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    get 'html_to_pdf', to: 'pdf#html_to_pdf'
    post 'html_to_pdf', to: 'pdf#html_to_pdf'

    get 'html_to_image', to: 'image#html_to_image'
    post 'html_to_image', to: 'image#html_to_image'

    get 'barcode_to_image', to: 'barcode#barcode_to_image'
    post 'barcode_to_image', to: 'barcode#barcode_to_image'
  end
end
