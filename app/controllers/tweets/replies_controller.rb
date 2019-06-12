class Tweets::RepliesController < ApplicationController

    def create
        @tweet = Tweet.create( reply_params )
    end

    private

    def reply_params
        params.require(:tweet).permit(:content).merge!(parent_tweet_id: params[:tweet_id])
    end

end
