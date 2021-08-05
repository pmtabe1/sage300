class WidgetsController < ApplicationController
  before_action :set_widget, only: [:show, :edit, :update, :destroy]

  def index
    @widgets = Widget.all
  end

  def show
    authorize! :read, @widget
  end

  def edit
    authorize! :update, @widget
  end

  def new
    authorize! :create, @widget = Widget.new
  end

  def create
    @widget = current_user.widgets.build(widget_params)
    respond_to do |format|
      if @widget.save
        format.html { redirect_to widgets_path }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @widget.update(widget_params)
        format.html { redirect_to widgets_path }
      else
        format.html { render :edit }
      end
    end
  end

  # TODO 
  # Move all widgets to widget table
  def ytd_net_sales_widget
    render :partial => 'ytd_net_sales_widget'
  end

  def ytd_margin_widget
    render :partial => 'ytd_margin_widget'
  end

  def ytd_gp_widget
    render :partial => 'ytd_gp_widget'
  end

  def current_month_sales_widget
    render :partial => 'current_month_sales_widget'
  end

  def last_year_net_sales_widget
    render :partial => 'last_year_net_sales_widget'
  end

  def shipping_references_widget
    render :partial => 'shipping_references_widget'
  end

  def backorders_widget
    render :partial => 'backorders_widget'
  end

  def fulfillables_widget
    render :partial => 'fulfillables_widget'
  end

  def opened_purchases_widget
    render :partial => 'opened_purchases_widget'
  end

  def customers_widget
    render :partial => 'customers_widget'
  end

  # Customers
  def ytd_net_sales_customer_widget
    render :partial => 'ytd_net_sales_customer_widget'
  end

  def open_sales_orders_widget
    render :partial => 'open_sales_orders_widget'
  end

  def invoice_pending_widget
    render :partial => 'invoice_pending_widget'
  end

  def customer_outstanding_balance_widget
    render :partial => 'customer_outstanding_balance_widget'
  end

  def customer_table_debts_widget
    render :partial => 'customer_table_debts_widget'
  end

  def order_action_totals_widget
    render :partial => 'order_action_totals_widget'
  end

  def abc_ranking_widget
    render :partial => 'abc_ranking_widget'
  end

  def low_stock_a_items
    render :partial => 'low_stock_a_items'
  end

  private
    def set_widget
      @widget = Widget.find(params[:id])
    end

    def widget_params
      params.require(:widget).permit(:name, :description, :template, :query_ids => [])
    end
end
