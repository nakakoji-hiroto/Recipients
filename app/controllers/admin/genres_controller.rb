class Admin::GenresController < ApplicationController
  before_action :check_admin_sign_in
  
  def new
    @genre = Genre.new
    @genres = Genre.all
  end

  def edit
    @genre = Genre.find(params[:id])
  end
  
  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to new_genre_path, notice: "新規ジャンルを登録しました"
    else
      @genres = Genre.all
      render 'new'
    end
  end
  
  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      redirect_to new_genre_path, notice: "ジャンルを更新しました"
    else
      render 'edit'
    end
  end
  
  private
  
  def genre_params
    params.require(:genre).permit(:name)
  end
  
end
