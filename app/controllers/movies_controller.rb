class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings]
    @sort_by = params[:sort_by]
    @ratings_atual = params[:ratings_atual]
    
    if @selected_ratings.nil?
      @selected_ratings = @all_ratings
    else
      @selected_ratings = params[:ratings].keys
      session[:saved_ratings] = @selected_ratings
    end
    
    unless session[:saved_ratings].nil?
      @selected_ratings = session[:saved_ratings]
    end
    
    unless @ratings_atual.nil?
      @selected_ratings = params[:ratings_atual]
    end
    
    unless @sort_by.nil?
      session[:saved_sort] = @sort_by
    else
      @sort_by = session[:saved_sort]
    end
    
    @movies = Movie.where(:rating => @selected_ratings).order(@sort_by)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end


end
