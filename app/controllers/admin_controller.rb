# Admin controller handles uploading and publishing results
class AdminController < ApplicationController
  before_filter :admin_required
  def index
  end
end
