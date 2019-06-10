class CommentsController < ApplicationController

    def edit
        @comment = Comment.find(params[:id])
        @tweet = Tweet.find( @comment.tweets_id )
        @numComments = Comment.where(tweets_id: @tweet.id).size
    end

    def update
        @comment = Comment.find(params[:id])
        if @comment.update(content: params[:comment][:content])
            redirect_to tweet_path( @comment.tweets_id )
        else
            redirect_to edit_comment_path(@comment.id)
        end
    end

    def destroy
        @comment = Comment.find(params[:id])
        tweetId = @comment.tweets_id
        @comment.destroy
        redirect_to tweet_path( tweetId )
    end

    def create
        @comment = Comment.create( comments_params )
        redirect_to tweet_path(comments_params[:tweets_id])
    end

    def comments_params
        params.require(:comment).permit(:content,:tweets_id)
    end

end