class Accpac::Porcph1Controller < ApplicationController
  before_action :set_accpac_porcph1, only: [:show, :details, :print]
  before_action :authenticate_user!, except: [:post_receipt]
  skip_before_action :verify_authenticity_token, only: [:post_receipt]
  include ApplicationHelper

  def index
    @accpac_porcph1 = Accpac::Porcph1Datatable
    respond_to do |format|
      format.html
      authorize! :index, @accpac_porcph1,format.json { render json: Accpac::Porcph1Datatable.new(view_context) }
    end
  end

  def show
    authorize! :read, @accpac_porcph1
  end

  def details
    render :partial => 'details'
  end

  def print
    authorize! :read, @accpac_porcph1
    respond_to do |format|
      format.html { render layout: 'print' }
    end
  end

  def post_receipt
    require 'uri'
    require 'net/http'
    require 'openssl'
    @document = Document.find(params[:document])

    if params[:vendor].present?
      url = URI("#{CONFIG['sage_po_api']['protocol']}://#{CONFIG['sage_po_api']['ip']}/#{CONFIG['sage_po_api']['path']}/api/InsertPOReceipts?key=Vx6850miami")

      http = Net::HTTP.new(url.host, url.port)
      http.open_timeout = 3     # in seconds
      http.read_timeout = 120   # in seconds
      if CONFIG['sage_po_api']['protocol'] == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = 'application/json'
      request.body = ApplicationController.render(template: 'documents/show.json.jbuilder', assigns: { document: @document }, locals: { vendor: params[:vendor] })

      response = http.request(request)

      if response.kind_of? Net::HTTPSuccess
        # Send email notification before checking if response is Success.
        PostReceiptWorker.perform_async(
          @document.id,
          params[:vendor],
          @document.properties_column["Packing List No"],
          @document.properties_column["Desccription"]
        )

        # Set as complete shild documents
        @document.document_id.each do |document|
          Document.where(id: document.to_i).update_all(confirmed: doc.confirmed, confirmed_at: doc.confirmed_at)
        end

        # Track event including document ID
        ahoy.track "Post Receipt porcph1", controller: controller_name, action: action_name, id: @document.id

        @document.update(confirmed: true, confirmed_at: Time.now)
        obj = JSON.parse(response.read_body)
        message = obj['message']
        #redirect_to document_path(@document), notice: message
        render json: { status: 'SUCCESS', message: message}, status: :ok
      else
        obj = JSON.parse(response.read_body)
        message = obj['error']
        #redirect_to document_path(@document), alert: message
        render json: {status: 'ERROR', message: message}, status: :unprocessable_entity
      end
    else
      render json: {status: 'ERROR', message: 'Make sure you scanned the right barcode.'}, status: :unprocessable_entity
    end
  end

  private
    def set_accpac_porcph1
      @accpac_porcph1 = Accpac::Porcph1.find(params[:id])
    end
end
