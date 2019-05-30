class ShortenedUrl
  include Mongoid::Document

  field :original_url, type: String 
  field :sanitize_url, type: String 
  field :short_url,    type: String
  field :visits,       type: Integer, default: 1
  field :final_url,    type: String

  #length for the url name
  UNIQUE_ID_LENGTH = 6;
  validates :original_url, presence: true, on: :create,
                           uniqueness: true
  validates :short_url, uniqueness: true

  #scopes
  scope :ordered, -> { order(visits: 'ASC') }

  def generate_short_url
    #generates random combinations for the shortened url
  	url = ([*('a'..'z'),*('0'..'9')]).sample(UNIQUE_ID_LENGTH).join

    boolRepeated = false
    #Checks if the generated short_url is already on existence
    shortenedUrls = ShortenedUrl.all
    shortenedUrls.each do |item|
      if item.short_url.to_s == url
        boolRepeated = true
      end
    end

  	if boolRepeated
  		self.generate_short_url
  	else
  		self.short_url = url
  	end
  end

  #Sanitize the given URL
  def sanitize
  	self.original_url.strip!
  	self.sanitize_url = self.original_url.downcase.gsub(/(https?:\/\/)|(www\.)/, "")
  	self.sanitize_url = "http://#{self.sanitize_url}"

    
    start = 8
    final = self.sanitize_url.length

    while start <= final  do
      sanitize_url[start] == ' ' ? sanitize_url[start] = '-' : sanitize_url[start] = sanitize_url[start] #change spaces for '-'
      break if sanitize_url[start] == '/'                                                                #break if '/' is found
      start +=1
    end

    self.sanitize_url = sanitize_url[0..start]       #cut the string for creating the shortened_url
    self.short_url = sanitize_url + short_url        #save the final shortened_url on the short_url's field
  end

  # Render
  def as_json(options = {})
    json = super(options) 
    json
  end

end
