class MoviesController < ApplicationController

#added a parameter to movie to check basis of sorting
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sortby)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end


#changes made to index for sorting by title and release date
  def index
    #if sorted by title
    
    @all_ratings = {'G' => true, 'PG' => true, 'PG-13' => true, 'R' => true}
    
    @sort = params[:sortby]
    
    if params.has_key?(:commit)
      ratings = params["ratings"]
      ratings = ratings.keys
      
      @all_ratings.keys.each do |rating|
        if params["ratings"][rating] == '1'
          @all_ratings[rating] = true
        else
          @all_ratings[rating] = false
        end
      end
      
      @movies = Movie.where(:rating => ratings)
      
    
    elsif params[:sortby] == "title"
      @movies = Movie.all.sort_by { |movie| movie.title }
      
    #if sorted by release date
    elsif params[:sortby] == "releasedate"
      @movies = Movie.all.sort_by { |movie| movie.release_date }
      
    else
      @movies = Movie.all
    end
    
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
