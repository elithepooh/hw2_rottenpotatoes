class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    sorted_by = params[:sorted_by]
    @ratings = params[:ratings]
    if @ratings.nil? and not session[:ratings].nil?
      flash.keep
      redirect_to movies_path({:ratings => session[:ratings], :sorted_by => session[:sorted_by]})
    else
      if @ratings.nil?
        @ratings_filter = @all_ratings
        @ratings = @all_ratings.inject({}) {|hsh, elt| hsh[elt] = "1"; hsh}
      else
        @ratings_filter = @ratings.keys
      end
      session[:ratings] = @ratings

      if sorted_by == "title"
        @hilite_title = true
      elsif sorted_by == "release_date"
        @hilite_release_date = true
      end
      session[:sorted_by] = sorted_by

      if sorted_by.nil?
        @movies = Movie.find(:all, :conditions => ["rating IN (?)",
                                                  @ratings_filter])
      else
        @movies = Movie.find(:all, :order => sorted_by, :conditions =>
                          ["rating IN (?)", @ratings_filter])
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
