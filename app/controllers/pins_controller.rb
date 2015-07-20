class PinsController < ApplicationController
  before_action :find_pin, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @pins = Pin.all.order("created_at DESC")
  end

  def show
  end

  def new
    @pin = current_user.pins.build
  end

  def create
    @pin = current_user.pins.build(pin_params)

    if @pin.save
      redirect_to @pin, notice: "Pin was successfully created"
    else
      render 'new'
    end
  end

  def edit
    if @pin.user != current_user
      redirect_to root_path
    end
  end

  def update
    if @pin.update(pin_params) && @pin.user == current_user
      redirect_to @pin, notice: "Pin was successfully updated"
    else
      render 'edit'
    end
  end

  def destroy
    if @pin.user == current_user
      @pin.destroy
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  def upvote
    @pin.upvote_by current_user
    redirect_to :back
  end

  private

  def pin_params
    params.require(:pin).permit(:title, :description, :image)
  end

  def find_pin
    @pin = Pin.find(params[:id])
  end

end
