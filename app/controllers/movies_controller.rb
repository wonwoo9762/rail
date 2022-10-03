class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      puts "hello world"
      puts params
      
      @all_ratings =  Movie.all_ratings
      @param_ratings =  params[:ratings].nil? ? {} : params[:ratings]
      @ratings_to_show = params[:ratings].nil? ?  @all_ratings : params[:ratings].keys ;
      puts @all_ratings
      puts @param_ratings
      puts @ratings_to_show
      puts "bye world"
  
      @sort = params[:sort].nil? ? "" : params[:sort]    
      unless (params[:sort].present? && params[:ratings].present?)
        h = {}.compare_by_identity
        @all_ratings.each_with_index{|k,v| h[k] = v} 
        redirect_to movies_path(sort: session[:sort] || "id" , ratings: session[:ratings] || h)
        return
      end
      session[:ratings] =  params[:ratings]
      session[:sort] = params[:sort]
      
      @movies = Movie.with_ratings(@ratings_to_show).order(@sort)
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end