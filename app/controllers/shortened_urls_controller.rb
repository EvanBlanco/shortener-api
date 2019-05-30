class ShortenedUrlsController < ApplicationController
	before_action :find_url, only: [:show]
	skip_before_action :verify_authenticity_token

	# def index
	# 	urls = ShortenedUrl.all 
	# 	render json: urls, status: 200
	# end

	def show
		render json: @url, status: 200
	end

	def create
    	shortenedUrl = ShortenedUrl.new(url_params)

    	shortenedUrl.original_url = params[:original_url]

    	#Check if an existing original_url is entered
	    shortenedUrls = ShortenedUrl.all
	    shortenedUrls.each do |item|
	      if item.original_url.to_s == shortenedUrl.original_url
	        item.visits = item.visits + 1 #Update the visits count if the url already existed
	        item.save
	        return render json: item, status: 200
	      end
	    end

		shortenedUrl.generate_short_url
		shortenedUrl.sanitize

	    if shortenedUrl.save
	      render json: shortenedUrl, status: 200
	    else
	      render json: { errors: shortenedUrl.errors }, status: 422
	    end
	end

	def most_frequents
		urls = ShortenedUrl.all 
		urls.ordered
		render json: urls, status: 200
	end

	private

	def find_url
		@url = ShortenedUrl.find_by_short_url(params[:short_url])
	end

	def url_params
		params.require(:shortened_url).permit(:original_url, :sanitize_url, :short_url)
	end

end
