require 'rails_helper'

RSpec.describe NewsController, type: :controller do

    before(:all) do
        news = News.new
        news.text = "test"
        news.save 
    end

    describe 'publish news item ' do
        it 'should change publish to true and redirect' do
          news = News.last
          news.publish = false
          news.save
          post :publish, params: { id: news.id }
          news = News.last
          expect(news.publish).to equal(true)
          expect(response.redirection?).to be_truthy
        end
      end  
      
      describe 'unpublish item ' do
        it 'should change publish to false and redirect' do
          news = News.last
          news.publish = true
          news.save
          post :unpublish, params: { id: news.id }
          news = News.last
          expect(news.publish).to equal(false)
          expect(response.redirection?).to be_truthy
        end
      end
    

end
