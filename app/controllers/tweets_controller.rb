class TweetsController < ApplicationController

    def index
        # @tweets = Tweet.where(parent_tweet_id: nil).sort_by{ |tweet| tweet.updated_at }.reverse
        @tweets = getAllReplyAndRetweet( nil, Tweet.all ).reverse
        # comments = Comment.all
        # @commentsHash = Hash.new( Array.new )
        # comments.each do |comment|
        #     if @commentsHash[comment.tweets_id].size == 0
        #         @commentsHash[comment.tweets_id] = Array.new
        #     end
        #     @commentsHash[comment.tweets_id] << comment
        # end
        @newTweet = Tweet.new
    end

    def create
        @tweet = Tweet.create( tweets_params )
        if @tweet.parent_tweet_id == nil
            redirect_to tweets_path
        else
            redirect_to tweet_path( @tweet.parent_tweet_id )
        end
    end

    # def update
    #     @tweet = Tweet.find(params[:id])
    #     if @tweet.update(content: params[:tweet][:content])
    #         redirect_to tweets_path
    #     else
    #         redirect_to edit_tweet_path(@tweet.id)
    #     end
    # end

    def show
        tweets = Tweet.all
        @tweet = Tweet.find(params[:id])
        @replies = getAllReplyAndRetweet( @tweet.id, tweets )
        @repliesNumber = @replies.sum{ |replyHash| replyHash[:count] } + @replies.size
        @parentTweets = getAllParent( @tweet, tweets )
        @newReply = Tweet.new
    end

    def retweet
        @newRetweet = Tweet.new
        @tweet = Tweet.find(params[:id])
    end

    # # def new
    # #     @tweet = Tweet.new
    # # end

    def edit
        tweets = Tweet.all
        @tweet = Tweet.find(params[:id])
        @replies = getAllReplyAndRetweet( @tweet.id, tweets )
        @repliesNumber = @replies.sum{ |replyHash| replyHash[:count] } + @replies.size
        @parentTweets = getAllParent( @tweet, tweets )
    end

    def destroy
        @tweet = Tweet.find(params[:id])
        parentTweetId = @tweet.parent_tweet_id
        @tweet.destroy
        redirect_to request.referer == url_for ? ( parentTweetId.nil? ? tweets_path : tweet_path( parentTweetId ) ) : request.referer
    end

    private

    def tweets_params
        params.require(:tweet).permit(:content).merge!(parent_tweet_id: params[:parent_tweet_id]).merge!(retweet_id: params[:parent_retweet_id])
    end

    def getAllReplyAndRetweet( parentId, tweets )
        output = Array.new
        tweets.select{|tweet| tweet.parent_tweet_id == parentId or tweet.parent_tweet_id.to_i == parentId}.each do |tweet|
            tmpHash = Hash.new
            tmpHash[:tweet] = tweet
            tmpHash[:retweet] = tweets.select{|tmpTweet| tmpTweet.id == tweet.retweet_id}
            tmpHash[:replies] = getAllReplyAndRetweet( tweet.id, tweets )
            tmpHash[:count] = tmpHash[:replies].sum{ |replyHash| replyHash[:count] } + tmpHash[:replies].size
            output << tmpHash
        end
        output.sort_by{ |tweetHash| tweetHash[:tweet].created_at }
    end

    def getAllParent( tweet, tweets )
        output = Array.new
        tmpHash = Hash.new
        tmpHash[:tweet] = tweet.parent_tweet
        if tmpHash[:tweet].nil?
            return output
        end
        tmpHash[:replies] = Array.new
        output = getAllParent( tmpHash[:tweet], tweets )
        tmpHash[:count] = output.size + 1
        output += [tmpHash]
    end

end
