Rails.application.routes.draw do

  # ActionCable
  mount ActionCable.server => "/cable"

  # Pages
  root 'pages#dashboard'
  get "/404", to: "pages#not_found", via: :all
  get "/500", to: "pages#internal_server_error", via: :all
  get :search, controller: :main

  # Sage 300 ERP Application Object Models
  namespace :accpac do
    # AP - Account Payable
    resources :apven, path: 'vendors' do
      member do
        get :purchase_orders_history
        get :opened_purchases
        get :items
        get :documents
      end
      collection do
        get :debts, path: 'debts-by-vendors'
      end
    end
    # AC - Account Receivable
    #resources :arcmm
    resources :arcus, only: [:index, :show], path: 'customers' do
      resources :arcmm, only: [:create, :new]
      collection do
        get :sales_history
        get :opened_orders
        get :backorders
        get :fulfillable
        get :price_lists
        get :documents
        get :budget
        get :receivable
        get :receivable
        get :miscellaneous_charges
        get :debts, path: 'debts-by-documents'
        get :map
      end
      member do
        post :statistics
      end
    end
    resources :arsap, only: [:index, :show], path: 'sales-representatives' do
      member do
        get :sales_history
        get :customers
      end
    end
    # GL - General Ledger
    resources :glamf
    resources :glacgrp do
      collection do
        get :trial_balance
        get :balance_sheet
        get :income_statement
        get :cash_flow_statement
        get :fiscal_sets
        get :chart_expenses
        get :expenses
        get :liquidity
        get :leverage
        get :efficiency
        get :profitability
        get :receivable
      end
    end
    # IC - Inventory Control
    resources :iccatg, only: [:index, :show], path: 'item-categories'
    resources :icitem, path: 'item-inquiry' do
      collection do
        get :locations
        get :transfers
        get :sales_orders
        get :transactions
        get :sales_history
        get :purchase_orders_history
        get :inventory_diff
        get :inv_vs_sales
        get :location_diff
        get :moving_average
        get :item_location_detail
        get :item_company_detail
        get :duties 
        get :vendors
        get :documents
        get :containers
        get :alternate_items
        get :optional_fields
        #namespace :reports do
        #end
      end
      member do
        get :coverage
        get :all_companies_stock
      end
    end
    get :icitem_optional_fields, :controller => :icitem

    resources :icitmv, only: [:index], path: 'item-vendor'
    resources :iciloc do
      collection do
        patch :update_inventory
      end
    end
    resources :iciceh, only: [:index, :show], path: 'internal-usages' do
      member do
        get :internal_usages
        get :shipped
      end
    end

    resources :iciced
    resources :ictreh, path: 'transfers' do
      member do
        get :details
      end
    end
    resources :siaud, only: [:index], path: 'item-change'
    # OE - Order Entry
    resources :oeordh, path: 'sales-orders' do
      collection do
        get :order_action
        get :order_action_report
        get :fulfillable
        get :backorders
        get :transfer_demand
        get :details
        get :shipments
        get :invoices
        get :miscellaneous_charges
        get :users_report
      end
    end

    # Invocies
    resources :oeinvh, only: [:index, :show], path: 'invoices' do
      collection do
        get :details
        get :invoice_report
        get :results
      end
      member do
        get :print
      end
    end

    # Shipments
    resources :oeshih, only: [:index, :show], path: 'shipments' do
      collection do
        get :details
      end
    end

    # Sales History
    resources :oeshdt, path: 'sales-history' do
      collection do
        get :sales_analysis
        get :sales_analysis_nopivot
        get :graphs
      end
    end
    get :filter_form, :controller => :oeshdt

    # Purchase History
    resources :pohstl, path: 'purchase-history' do
      collection do
        get :purchases_analysis
        get :vendors_analysis
      end
    end

    # PO - Purchase Orders
    resources :poporh1, only: [:index, :show], path: 'purchase-orders' do
      collection do
        get :logistics
        get :time_line
        get :details
        get :drop_shipments, path: 'drop-sipments'
        get :open_purchase_orders, path: 'open-purchase-orders'
      end
    end

    resources :porcph1, path: 'purchase-orders-receipts' do
      collection do
        get :details
      end
      member do
        get :print
      end
    end
    match 'purchase_orders_receipt/post_receipt' => 'porcph1#post_receipt', via: :post

    resources :poinvh1, only: [:index, :show], path: 'vendors-invoices' do
      member do
        get :details
      end
    end

    # RA - Return Material Authorization
    resources :rahead, only: [:index, :show] # RMA
    resources :rfrcctl, path: 'receiving-controls' do
      member do
        post :import_control
        get :revert_import
      end
    end
  end
  ### End Accpac Modules ###

  # widgets
  resources :widgets

  get :ytd_net_sales_widget, :controller => :widgets
  get :ytd_margin_widget, :controller => :widgets
  get :ytd_gp_widget, :controller => :widgets
  get :current_month_sales_widget, :controller => :widgets
  get :last_year_net_sales_widget, :controller => :widgets
  get :shipping_references_widget, :controller => :widgets
  get :backorders_widget, :controller => :widgets
  get :fulfillables_widget, :controller => :widgets
  get :opened_purchases_widget, :controller => :widgets
  get :logistic_board_widget, :controller => :widgets
  get :documents_widget, :controller => :widgets
  get :customers_widget, :controller => :widgets
  get :open_sales_orders_widget, :controller => :widgets
  get :invoice_pending_widget, :controller => :widgets
  get :customer_outstanding_balance_widget, :controller => :widgets
  get :customer_table_debts_widget, :controller => :widgets
  get :order_action_totals_widget, :controller => :widgets
  get :abc_ranking_widget, :controller => :widgets
  get :low_stock_a_items, :controller => :widgets

  resources :queries do
    collection do
      get :schema
    end
  end

  # Charts
  namespace :charts do
    namespace :documents do
      get "document_types_summary"
    end

    namespace :vendors do
      get "purchases_chart"
      get "purchases_count_trend"
      get "purchases_trend"
      get "invoices_trend"
      get "payments_chart"
    end

    namespace :customers do
      get "sales_chart"
      get "order_count_trend"
      get "sales_trend"
      get "sales_forecast"
      get "dues_geochart"
      get "claims"
      get "average_days_to_pay"
      get "statistics"
    end

    namespace :items do
      get "sales_chart"
      get "sales_trend_geochart"
      get "order_count_trend"
      get "sales_trend"
      get "iranking_pie"
      get "sales_and_purchases_trend"
      get "item_valuation"
    end

    namespace :sales_orders do
      get "daily_backorder_log"
      get "backorders_territory"
      get "ytd_net_sales_geochart"
      get "ytd_net_sales_geochart_states"
      get "order_action"
      get "monthly_orders_by_users"
      get "daily_orders_by_users"
    end

    namespace :transfers do
      get "daily"
      post "daily"
      get "by_location"
    end

    namespace :sales_reps do
      get "years_sales_chart"
      get "months_sales_chart"
    end

    namespace :sales_analysis do
      get "net_sales_by_years"
      get "net_sales_by_countries"
      get "sales_trend"
      get "ytd_net_sales"
      get "daily_sales"
    end

    namespace :finance do
      get "net_income"
      get "income_vs_expenses"
      get "expenses_by_groups"
      get "expenses_by_account_groups"
      get "expenses_groups_by_years"
      get "cash_flow"
      get "cash_flow_detail"
      get "aged_receivables"
      get "aged_payables"
    end
  end
end
