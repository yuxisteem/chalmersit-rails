class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.ordered
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @comments = @post.comments.order(created_at: :desc)
    @comment = Comment.new
    if request.path != post_path(@post)
      redirect_to @post, status: :moved_permanently
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
    @event = find_or_create_event
  end

  # GET /posts/1/edit
  def edit
    @event = find_or_create_event
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: I18n.translate('model_created', name:@post.title) }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: I18n.translate('model_updated', name:@post.title) }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: I18n.translate('model_destroyed', name:@post.title) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find params[:id].split('-')[0]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      permitted = [:user_id, :group_id, :title, :body, :sticky, { event_attributes: [:event_date, :full_day, :start_time, :end_time, :facebook_link, :location, :organizer] }] + Post.globalize_attribute_names
      params.require(:post).permit(permitted)
    end

    def find_or_create_event
      return @post.event unless @post.event.nil?
      Event.new(post: @post, event_date: Date.today, start_time: Time.now, end_time: Time.now + 1.hour)
    end
end
