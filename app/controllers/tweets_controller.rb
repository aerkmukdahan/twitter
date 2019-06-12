class TweetsController < ApplicationController

    def index
        @tweets = Tweet.where( reply_to_tweet_id: nil ).sort_by{ |tweet| tweet.updated_at }.reverse
        @newTweet = Tweet.new
    end

    def create
        tweet = Tweet.create( tweets_params )
        if tweet.valid?
            flash[:success] = ['Tweet successful.']
        else
            flash[:fail] = Array.new
            tweet.errors.messages.each{ |column, messageArray|  messageArray.each{ |message| flash[:fail] << message } }
        end
        redirect_to tweet.reply_to_tweet_id.nil? ? tweets_path : tweet_path( tweet.reply_to_tweet_id )
    end

    def update
        tweet = Tweet.find(params[:id])
        if tweet.update(content: params[:tweet][:content])
            flash[:success] = ['Edit successful.']
            redirect_to tweet_path( params[:id] )
        else
            flash[:fail] = Array.new
            tweet.errors.messages.each{ |column, messageArray|  messageArray.each{ |message| flash[:fail] << message } }
            redirect_to edit_tweet_path( params[:id] )
        end
    end

    def show
        @tweet = Tweet.find(params[:id])
        @newReply = Tweet.new
    end

    def retweet
        @newRetweet = Tweet.new
        @tweet = Tweet.find(params[:id])
    end

    def edit
        @tweet = Tweet.find(params[:id])
    end

    def destroy
        tweet = Tweet.find(params[:id])
        parentTweetId = tweet.retweet_from_tweet_id
        tweet.destroy
        redirect_to request.referer == url_for ? ( parentTweetId.nil? ? tweets_path : tweet_path( parentTweetId ) ) : request.referer
    end

    private

    def tweets_params
        params.require(:tweet).permit(:content).merge(reply_to_tweet_id: params[:reply_to_tweet_id], retweet_from_tweet_id: params[:retweet_from_tweet_id])
    end

end
