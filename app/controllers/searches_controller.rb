class SearchesController < ApplicationController
  require 'json'

  def index
   @user = User.all
    Flightsearch_worker.perform_in(1.minutes, 2)
    binding.pry
    # User_Mailer.alert_email.deliver
    UserMailer.email_name.deliver
  end

  def new
    # origin = params[:origin]
    # destination = params[:destination]
    # date = params[:date]
    # adultCount = params[:adultCount]
    # permittedCarrier = params[:permittedCarrier]
    # preferredCabin = params[:preferredCabin]
    reqBody = params[:qpxData]
    # binding.pry
    flightRequest = Typhoeus::Request.new(
      "https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyDE6F79FbnrSc9hZlurECTyBJoEyHCj-Nc",
      method: :post,
      headers: {'Content-Type'=> "application/json; charset=utf-8"},
      body: reqBody,
    )
    flightRequest.run
    @results = JSON.parse(flightRequest.response.body)
    respond_to do |format|
      format.html
      format.json { render json: {
        :results => @results
        }
      }
    end
  end

end

