class PagesController < ApplicationController
  def dashboard
    @salaries = Accpac::Glacgrp.salaries
    @interest = Accpac::Glacgrp.interest
  end

  def search
  end

  # Handling Exceptions
  def not_found
    render(:status => 404, :layout => "print")
  end

  def internal_server_error
    render(:status => 500, :layout => "print")
  end
end
