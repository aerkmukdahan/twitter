class Tweets::HashTagController < ApplicationController

  before_action :authenticate_user!, except: [ :index ]
  layout 'home_page_layout'

  def index
    @hash_tag = HashTag.where( name: params[:hash_tag] ).first
    @tweets = @hash_tag.tweets.sort_by{ |tweet| tweet.updated_at }.reverse
  end

  def search
    require 'pry'
    binding.pry
  end

end
