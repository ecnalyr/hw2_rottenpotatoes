class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    if session["sort_by"] == "title"
      @title_class = 'hilite'
      @movies = Movie.order(session[:sort_by])
    elsif session["sort_by"] == 'release_date'
      @release_date_class = 'hilite'
     @movies = Movie.order(session[:sort_by])
    end

    if params[:commit] == 'Refresh'
      session[:ratings] = params[:ratings]
    elsif session[:ratings] != params[:ratings]
      redirect = true
      params[:ratings] = session[:ratings]
    end

    if params[:sort_by]
      session[:sort_by] = params[:sort_by]
    elsif session[:sort_by]
      redirect = true
      params[:sort_by] = session[:sort_by]
    end
    
    @ratings, @sort_by = session[:ratings], session[:sort_by]
    if redirect
      redirect_to movies_path({:sort_by=>@sort_by, :ratings=>@ratings})
    elsif
      columns = {'title'=>'title', 'release_date'=>'release_date'}
      if columns.has_key?(@sort_by)
        query = Movie.order(columns[@sort_by])
      else
        @sort_by = nil
        query = Movie
      end
      
      @movies = @ratings.nil? ? query.all : query.find_all_by_rating(@ratings.map { |r| r[0] })
      @all_ratings = Movie.all_ratings  
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
