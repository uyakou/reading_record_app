class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  PER = 6
  
  def new
    @book = Book.new
  end
  
  def create
    @book = current_user.books.build(book_params)
    if @book.save
      redirect_to book_path(@book), notice: "感想を投稿しました。"
    else
      render :new
    end
  end
  
  def index
    @books = Book.page(params[:page]).per(PER)
  end
  
  def show
    @book = Book.find(params[:id])
  end
  
  def edit
    @book = Book.find(params[:id])
    if @book.user != current_user
        redirect_to books_path, alert: "不正なアクセスです。"
    end
  end
  
  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "感想を更新しました。"
    else
      render :edit
    end
  end
  
  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to user_path(book.user), notice: "感想を削除しました。"
  end

  private
  
  def book_params
    params.require(:book).permit(:title, :body, :image, :comment)
  end
end