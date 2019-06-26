class TweetsController < ApplicationController

    before_action :authenticate_user!, except: [ :index, :show ]
    before_action :get_hash_tags, except: [ :create, :update, :destroy, :like, :unlike ]

    layout 'twitter_layout'

    def index
        @tweets = Tweet.where( reply_to_tweet_id: nil )
          .filter{ |tweet| user_signed_in? ? ((current_user.following_ids.include? tweet.user_id) or current_user.id == tweet.user_id) : true }
          .sort_by{ |tweet| tweet.updated_at }.reverse
        @new_tweet = Tweet.new
    end

    def create
        tweet = current_user.tweets.create( tweets_params )
        if tweet.valid?
            flash[:success] = ['Tweet successful.']
            create_hash_tag( tweet )
        else
            flash[:fail] = Array.new
            tweet.errors.messages.each{ |column, message_array|  message_array.each{ |message| flash[:fail] << message } }
        end
        redirect_to tweet.reply_to_tweet_id.nil? ? tweets_path : tweet_path( tweet.reply_to_tweet_id )
    end

    def update
        tweet = current_user.tweets.find(params[:id])
        if tweet.nil?
            flash[:fail] = ['You can\'t edit this tweet.']
            redirect_to tweets_path
        else
          new_tweet = tweet.dup
          new_tweet.content = params[:tweet][:content]
          if new_tweet.valid?
            update_hash_tag( tweet )
            tweet.update( content: params[:tweet][:content] )
            flash[:success] = ['Edit successful.']
            redirect_to tweet_path( params[:id] )
          else
            flash[:fail] = Array.new
            tweet.errors.messages.each{ |column, message_array|  message_array.each{ |message| flash[:fail] << message } }
            redirect_to edit_tweet_path( params[:id] )
          end
        end
    end

    def show
        @tweet = Tweet.find(params[:id])
        @new_reply = Tweet.new
    end

    def retweet
        @new_retweet = Tweet.new
        @tweet = Tweet.find(params[:id])
    end

    def edit
        @tweet = Tweet.find(params[:id])
    end

    def destroy
        tweet = current_user.tweets.find(params[:id])
        if tweet.nil?
            flash[:fail] = ['You can\'t delete this tweet.']
            redirect_to tweets_path
        else
            parent_tweetId = tweet.retweet_from_tweet_id
            tweet.destroy
            redirect_to request.referer == url_for ? ( parent_tweetId.nil? ? tweets_path : tweet_path( parent_tweetId ) ) : request.referer
        end
    end

    def like
        if current_user.liked_tweets.where( id: params[:id] ).present?
            flash[:fail] = ['Can not like the tweet.']
        else
            tweet = current_user.likes.create( tweet_id: params[:id] )
            unless tweet.valid?
                flash[:fail] = Array.new
                tweet.errors.messages.each{ |column, message_array|  message_array.each{ |message| flash[:fail] << message } }
            end
        end
        redirect_to request.referer
    end

    def unlike
        like = current_user.likes.select{ |like| like.tweet_id == params[:id].to_i }[0]
        if like.nil?
            flash[:fail] = ['Can not unlike the tweet.']
        else
            like.destroy
        end
        redirect_to request.referer
    end

    def theme
      current_user.dark_theme ? current_user.update( dark_theme: false ) : current_user.update( dark_theme: true )
      redirect_to request.referer
    end

    private

    def create_hash_tag( tweet )
        tweet.content.split(' ')
            .select{ |word| word.match? /\B(\#[a-zA-Z]+\b)/ }
            .uniq.each do | hash_tag_name |
                hash_tag = HashTag.where( name: hash_tag_name )[0]
                hash_tag = hash_tag.present? ? hash_tag : HashTag.create( name: hash_tag_name )
                tweet.hash_tag_associations.create( hash_tag_id: hash_tag.id )
                # tweet.content.gsub!(hash_tag_name,"<a href=#{tweets_hash_tag_path(hash_tag.name)}>#{hash_tag_name}</a>")
            end
        tweet.save
    end

    def update_hash_tag( tweet )
        new_hash_tag_array = params[:tweet][:content].split(' ').select{ |word| word.match? /\B(\#[a-zA-Z]+\b)/ }
        old_hash_tag_array = tweet.content.split(' ').select{ |word| word.match? /\B(\#[a-zA-Z]+\b)/ }

        create_hash_tag_array = new_hash_tag_array - old_hash_tag_array
        delete_hash_tag_array = old_hash_tag_array - new_hash_tag_array
        old_hash_tag_array = new_hash_tag_array & old_hash_tag_array

        create_hash_tag_array.each do | hash_tag_name |
            hash_tag = HashTag.where( name: hash_tag_name )[0]
            hash_tag = hash_tag.present? ? hash_tag : HashTag.create( name: hash_tag_name )
            tweet.hash_tag_associations.create( hash_tag_id: hash_tag.id )
            # params[:tweet][:content].gsub!(hash_tag_name,"<a href=#{tweets_hash_tag_path(hash_tag.name)}>#{hash_tag_name}</a>")
        end

        delete_hash_tag_array.each do | hash_tag_name |
            hash_tag = HashTag.where( name: hash_tag_name )[0]
            next unless hash_tag.present?
            hash_tag_association = tweet.hash_tag_associations.where( hash_tag_id: hash_tag.id )[0]
            hash_tag_association.destroy if hash_tag_association.present?
        end

        # old_hash_tag_array.each do |hash_tag_name|
        #     hash_tag = HashTag.where( name: hash_tag_name )[0]
            ### check validation please ###
            # params[:tweet][:content].gsub!(hash_tag_name,"<a href=#{tweets_hash_tag_path(hash_tag.name)}>#{hash_tag_name}</a>")
        # end

        # tweet.content = params[:tweet][:content]
        # tweet

    end

    def tweets_params
        params.require(:tweet).permit(:content).merge(reply_to_tweet_id: params[:reply_to_tweet_id], 
                                                    retweet_from_tweet_id: params[:retweet_from_tweet_id])
    end

end
