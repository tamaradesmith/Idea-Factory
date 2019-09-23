class ReviewsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_idea



    def create
        @review = Review.new review_params
        @review.user = current_user
        @review.idea = @idea

        if @review.save

            redirect_to idea_path(@idea)
        else
            @reviews = @idea.reviews.order(created_at: :desc)
            render 'idea/show'
        end
    end

    def destroy
        @review = Review.find params[:id]
        if can? :crud, @review
            @review.destroy
            redirect_to idea_path(@idea)
        else
            redirect_to idea_path(@idea)
        end
    end

    private

    def review_params
        params.require(:review).permit(:body, :user)
    end

    def find_idea
        @idea = Idea.find(params[:idea_id])
    end
end
