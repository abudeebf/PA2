class ViewerInfo
attr_accessor :u,:m,:r,:p
def initialize user_id=nil, movie_id=nil,moive_rating=0,movie_predict=0
	@u=user_id
	@m=movie_id
	@r=movie_rating
	@p=movie_predict
	puts @u + " movie " + @m + " rating " +@r +" predict "+ @p
end

