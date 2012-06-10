  class MovieTest
  attr_accessor :movie_test
def  initialize
  @movie_test=Array.new
  end
  def mean 
  	@movie_test.inject(0){ |result,element| puts element.r result+(element.r-element.p)}
  	 puts result / movie_test.length
end
end 