require 'rails_helper'

RSpec.describe IdeasController, type: :controller do

    def current_user 
        @current_user ||=FactoryBot.create :user
    end

    describe "#new" do

        context "without Signed in User" do

            it "should redirect to session new" do
                get :new
                expect(response).to redirect_to new_session_path
            end

        end

        context "with signed in user" do

            before do
                current_user = FactoryBot.create :user
                session[:user_id] = current_user.id
            end

            it 'render new template' do
                get :new

                expect(response).to render_template :new
            end

            it "sets an instance varable with a idea" do
                get :new
                
                expect(assigns(:idea)).to be_a_new Idea
            end
        end
    end

    describe "#create" do

        def vaild_request
            post :create, params: {idea: FactoryBot.attributes_for(:idea)}
        end

        context "without signed in user" do
            it "should redirect to sign in page" do
                vaild_request
                expect(response).to redirect_to new_session_path
            end
        end

        context "with Signed in user" do 

            before do
                session[:user_id] = current_user
            end

            context "with valid parameters" do

                it "should save a new idea to db" do
                
                    count_before = Idea.count
                    vaild_request
                    count_after = Idea.count

                    expect(count_after).to eq(count_before + 1)
                end

                it "should redirect to the show page of that new idea" do
                    vaild_request
                    idea = Idea.last

                    expect(response).to redirect_to idea_path(idea.id)

                end
            
            end

            context "with invalid parameters" do 

                def invalid_request
                    post :create, params:{idea: FactoryBot.attributes_for(:idea, title: nil)}
                end

                it "should not create a idea" do

                    count_before = Idea.count
                    invalid_request
                    count_after = Idea.count

                    expect(count_after). to eq count_before
                end

                it "should re-render the new template" do
                    invalid_request
                    expect(response).to render_template :new
                end

                it "assigns an invalid job as an instance variable" do

                    invalid_request
                    expect(assigns(:idea)).to be_a Idea
                    expect(assigns(:idea).valid?).to be false

                end
            end
        end
    end

    describe "#Show" do 
       
       it "should render show temple" do
        
            idea = FactoryBot.create(:idea)
            get(:show, params:{id: idea.id})
            expect(response).to render_template :show
        end

        it "should @idea for shown object" do

            idea = FactoryBot.create(:idea)
            get(:show, params:{id: idea.id})

            expect(assigns(:idea)).to eq idea
        end 

    end

    describe "#index" do

        before do
            get :index
        end

        it "should render index template" do
            expect(response).to render_template :index

        end

        it "assigns an instance vabiable to all created ideas" do
            idea_1 = FactoryBot.create(:idea)
            idea_2 = FactoryBot.create(:idea)
            idea_3 = FactoryBot.create(:idea)

            expect(assigns(:ideas)).to eq ([idea_3, idea_2, idea_1])
        end

    end

    describe "#edit" do 
   
        context "without signed in user" do 
            it "should redirect to the new session page" do
                idea = FactoryBot.create :idea
                get(:edit, params: {id: idea.id})
                expect(response).to redirect_to(new_session_path)
            end

        end

        context "with signed in user" do
            before do
                session[:user_id] = current_user
            end

            context "with idea owner signed in" do

                it "should render edit templete" do
                    idea = FactoryBot.create(:idea, user: current_user)
                    get(:edit, params: {id: idea.id})
                    expect(response).to render_template :edit
                end

                it "should get existing idea params" do
                    idea = FactoryBot.create(:idea, user: current_user)
                    get(:edit, params: {id: idea.id})

                    expect(assigns(:idea)).to eq(idea)
                end
            end

            context "With non-owner signed in" do
                it "should redirect the user to the idea page" do
                    idea = FactoryBot.create(:idea)
                    get(:edit, params: {id: idea.id})
                    expect(response).to redirect_to idea_path
                end



            end
        end
    end

    describe "#update" do 

        before do 
            @idea = FactoryBot.create(:idea)
        end

        context "with out sign in user" do

            it "should redirect to signin page" do

                new_title = "Hudson is cuter than you!!!"
                patch :update, params: {id: @idea.id, idea: {title: new_title}}
                expect(response).to redirect_to(new_session_path)
            end
        end

        context "with Signed in user" do

            
            context "NON-owner of idea" do
                
            before do
                session[:user_id] = current_user 
            end

                it "should redirect to root_path" do
                     new_title = "#{@idea.title} New Changes"
                    patch :update, params: {id: @idea, idea: { title: new_title}}
                    expect(response).to redirect_to idea_path
                end
            end
            context "with owner signed in" do

            before do

                session[:user_id] = @idea.user
            end

                context "with valid params" do

                    it "should update change to idea" do 
                        new_title = "#{@idea.title} Changes"
                        patch :update, params: {id: @idea.id, idea: {title: new_title}}
                        expect(@idea.reload.title).to eq(new_title)
                    end

                    it "should redirect to idea show page" do
                            new_title = "#{@idea.title} Changes"
                        patch :update, params: {id: @idea.id, idea: {title: new_title}}
                        expect(response).to redirect_to @idea
                    end

                end

                context "with invalid params" do

                    def invalid_request 
                        patch :update, params: {id: @idea.id, idea: {title: nil}}
                    end

                    it "should not update idea" do
                        expect{invalid_request}.not_to change{@idea.reload.title}
                    end

                    it "should re-render idea edit template" do
                        invalid_request
                        expect(response).to render_template :edit
                    end
                end
            end
        end
    end

    describe "#destroy" do

          before do
                session[:user_id] = current_user 
            end
        

        it "should remove idea from db" do
            idea = FactoryBot.create :idea, user: current_user
            delete(:destroy, params: {id: idea.id})
            expect(Idea.find_by(id: idea.id)).to be nil
        end

        it "should redirect to index page" do
            idea = FactoryBot.create :idea, user: current_user
            delete(:destroy, params: {id: idea.id})
            expect(response).to redirect_to ideas_path 

        end 
    end

end
