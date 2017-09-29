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
  	@all_ratings = {'G'=>true,'PG'=>true,'PG-13'=>true,'R'=>true}
  	
  	
  	@sort_by = session[:s_sortby]
  	if params.has_key?(:sortby)
  		if session[:s_sortby] != params[:sortby]
  			session[:s_sortby] = params[:sortby]
  			@sort_by = params[:sortby]
  		end
  	end
  	if params.has_key?("ratings")
  		if session[:sratings].keys != params["ratings"]
  			if params["ratings"].keys.size > 0
  				ratings = params["ratings"]
  				ratings = ratings.keys
  				@all_ratings.keys.each do |rating|
  					if params["ratings"][rating] == "1"
  						@all_ratings[rating] = true
  					else
  						@all_ratings[rating] = false
  					end
  				end
  				session[:sratings]=@all_ratings
  			end
  		end
  	end
  	
  	if session[:s_sortby] == "title"
  		ratings = []
  		session[:sratings].keys.each do |k|
  			if session[:sratings][k] == true
  				ratings.insert(0, k)
  			end
  		end
  		@movies = Movie.where(:rating => ratings ).sort_by { |r| r.title }
  		@all_ratings = session[:sratings]
  		
  	elsif session[:s_sortby] == "releasedate"
  		ratings = []
  		session[:sratings].keys.each do |k|
  			if session[:sratings][k] == true
  				ratings.insert(0, k)
  			end
  		end
  		@movies = Movie.where(:rating => ratings ).sort_by { |r| r.release_date }
  		@all_ratings = session[:sratings]
  		
  	else
  		ratings = []
  		@all_ratings.keys.each do |k|
  			if @all_ratings[k] == true
  				ratings.insert(0, k)
  			end
  		end
  		session[:sratings] = @all_ratings
  		@movies = Movie.where(:rating => ratings )
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
