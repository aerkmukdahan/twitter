class Tweets::UserController < ApplicationController

  before_action :authenticate_user!, except: [ :index ]
  layout 'home_page_layout'

  def index
    @user = User.find( params[:id] )
    @tweets = @user.tweets.where( reply_to_tweet_id: nil ).sort_by{ |tweet| tweet.updated_at }.reverse
  end

  def follow
      if current_user.followings.where( id: params[:id] ).present?
        flash[:fail] = ['You have already followed this user.']
      elsif current_user.id == params[:id].to_i
        flash[:fail] = ['You can not follow yourself.']
      else
        follow = current_user.following_associations.create( following_id: params[:id] )
        unless follow.valid?
          flash[:fail] = Array.new
          follow.errors.messages.each{ |column, message_array|  message_array.each{ |message| flash[:fail] << message } }
        end
      end
      redirect_to request.referer
  end

  def unfollow
    follow = current_user.following_associations.find_by( following_id: params[:id] )
    if follow.nil?
      flash[:fail] = ['You have not followed this user yet.']
    else
      follow.destroy
    end
    redirect_to request.referer
end

end
