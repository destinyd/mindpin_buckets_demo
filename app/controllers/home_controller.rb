class HomeController < ApplicationController
  before_filter :authenticate_user!#, only: [:dashboard]
  def index
  end
end
