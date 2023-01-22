Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/swagger'
  mount Rswag::Api::Engine => '/swagger'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    post 'html_to_pdf', to: 'pdf#html_to_pdf'

    # get 'html_to_image', to: 'image#html_to_image'
    # post 'html_to_image', to: 'image#html_to_image'
    #
    get 'barcode_to_image/:barcode', to: 'barcode#barcode_to_image'
    post 'documents/:template_name', to: 'documents#build_report'
    get 'documents/:template_name/tags', to: 'documents#tags'
  end

  namespace :cdn do
    get 'barcodes/:barcode', to: 'barcode#barcode_to_image'
    post 'html_to_pdf', to: 'pdf#html_to_pdf'
    post 'many_html_to_pdf', to: 'pdf#many_html_to_pdf'
    post 'documents/:template_name', to: 'documents#build_report'
  end
end
