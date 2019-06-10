class TweetsController < ApplicationController

    def index
        @tweets = Tweet.all
        comments = Comment.all
        @commentsHash = Hash.new( Array.new )
        comments.each do |comment|
            if @commentsHash[comment.tweets_id].size == 0
                @commentsHash[comment.tweets_id] = Array.new
            end
            @commentsHash[comment.tweets_id] << comment
        end
        @newTweet = Tweet.new
    end

    def create
        @tweet = Tweet.create( tweets_params )
        redirect_to tweets_path
    end

    def update
        @tweet = Tweet.find(params[:id])
        if @tweet.update(content: params[:tweet][:content])
            redirect_to tweets_path
        else
            redirect_to edit_tweet_path(@tweet.id)
        end
    end

    def show
        @tweet = Tweet.find(params[:id])
        @comments = Comment.where(tweets_id: @tweet.id)
        @newComment = Comment.new
    end

    # def new
    #     @tweet = Tweet.new
    # end

    def edit
        @tweet = Tweet.find( params[:id] )
        @numComments = Comment.where(tweets_id: @tweet.id).size
    end

    def destroy
        @tweet = Tweet.find(params[:id])
        @tweet.destroy
        redirect_to tweets_path
    end

    private

    def tweets_params
        params.require(:tweet).permit(:content)
    end

end
