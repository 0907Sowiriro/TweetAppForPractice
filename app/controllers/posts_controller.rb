class PostsController < ApplicationController
    before_action :authenticate_user
    before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

    def index
        @post = Post.all.order(created_at: :desc)
    end 

    def show
        @post = Post.find_by(id: params[:id])
        @user = @post.user
        @likes_count = Like.where(post_id: @post.id).count
    end

    def new
        @post = Post.new
    end

    def create 
        @post = post.new(
            content: params[:content],
            user_id: params[:user_id]
        )
        if @post.save
            flash[:notice] = "投稿しました"
            redirect_to("/posts/index")
        else
            render("posts/new")
        end
    
    end

    def edit
        @post = Post.find_by(id: params[:id])
    end

    def update
        @post = Post.find_by(id: params[:id])
        @post.content = params[:content]
        if @post.save
            flash[:notice] ="投稿を編集しました"
            redirect_to("/posts/index")
        else
            render("posts/edit")
        end
    end

    def destroy
        @post = Post.find_by(id: params[:id])
        @post.destroy
        flash[:notice] ="投稿を削除しました"
        redirect_to("/posts/index")
    end

    def ensure_correct_user
        if @current_user.id != params[:id].to_i
            flash[:notice]="権限がありません"
            redirect_to("/posts/index")
        end
    end
end
