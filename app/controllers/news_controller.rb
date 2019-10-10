class NewsController < ApplicationController

  def publish 
    News.find(params[:id]).update(publish: true)
    redirect_to controller: 'admin', action: 'index'
  end
     
  def unpublish
    News.find(params[:id]).update(publish: false)
    redirect_to controller: 'admin', action: 'index'
  end
    
end
