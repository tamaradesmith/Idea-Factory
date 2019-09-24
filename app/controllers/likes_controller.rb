class LikesController < ApplicationController
        before_action :authenticate_user!



    def create

        idea = Idea.find(params[:idea_id])
        like = Like.new(user: current_user, idea: idea)
        if !can?(:like, idea)
            redirect_to idea_path(idea), alert: "can't liked idea"
        else like.save
            redirect_to idea_path(idea)
        end

    end

    def destroy
        like = current_user.likes.find(params[:id])
        if can? :destroy, like
            like.destroy
            redirect_to idea_path(like.idea)
        else
            redirect_to idea_path(like.idea)
        end
    end



end
