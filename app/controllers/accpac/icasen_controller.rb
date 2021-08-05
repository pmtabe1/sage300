class Accpac::IcasenController < ApplicationController
  before_action :set_accpac_icasen, only: [:show, :details, :shopify_post]

  shop_url = "https://a468855f2a8b425956f14e4c6865c06a:0d1fe32e14f17f1b0d77b79e4f3bd3d0@vertilux-shop.myshopify.com"
  ShopifyAPI::Base.site = shop_url
  ShopifyAPI::Base.api_version = '2020-01'
  require "json"

  def index
    respond_to do |format|
      format.html
      format.json { render json: Accpac::IcasenDatatable.new(view_context) }
    end
  end

  def show
  end

  def shopify_post
    variants =  ShopifyAPI::Variant.find(:all, params: { limit: 250 }).to_json
    @variants = JSON.parse(variants)

    @accpac_icasen.icassmd.each do |r|
      variant = @variants.detect { |v| v['sku'] == "#{r.FMTITEMNO.squish}" }
      if variant.present?
        variant = variant['inventory_item_id']
        params = { inventory_item_ids: variant }
        inventory_levels = ShopifyAPI::InventoryLevel.find(:all, params: params)
        if r.TRANSTYPE = 1
          inventory_adjustment = r.BUILDQTY.to_i
        elsif r.TRANSTYPE = 2
          inventory_adjustment = "#{(r.BUILDQTY.to_i)*-1}"
        end
        case inventory_levels[0].adjust(inventory_adjustment)
        when true
          redirect_back fallback_location: request.referrer, notice: "Inventory level sucessfully updated."
        else
          redirect_back fallback_location: request.referrer, alert: "Unable to update inventory level."
        end
      end
    end
  end

  def details
    render :partial => 'details'
  end

  private
    def set_accpac_icasen
      @accpac_icasen = Accpac::Icasen.find(params[:id])
    end
end
