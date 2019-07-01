class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :get_hash_tags, :get_suggestion, :dark_theme

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit( :account_update, keys: [:name] )
  end

  def get_hash_tags
    @top_ten_hash_tags = HashTag.all
      .sort_by{ |hash_tag| hash_tag.tweets.size }
      .reverse[0...10]
    @new_hash_tag = HashTag.new
  end

  def get_suggestion
    @user_suggestions = user_signed_in? ? 
    current_user.hash_tags.map(&:users)
      .flatten.reduce(Hash.new(0)) do |user_count_hash, user|
        user_count_hash[user] += 1 
        user_count_hash
      end
      .sort_by{|user, hash_tag_count| hash_tag_count }
      .reverse.map{ |hash_array| hash_array[0] } - 
        Array(current_user.followings) - Array(current_user)
    : User.all.sort_by{|user| user.tweets.size}.reverse[0...10]
  end

  def dark_theme
    @dark_theme = user_signed_in? ? 
      current_user.dark_theme : 
      false
  end
    
end
