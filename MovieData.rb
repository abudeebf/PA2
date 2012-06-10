class MovieData
  # the constuctor will call method read to
  # intilize the training set and testing set
	def  initialize folder_name, file_name=nil
		if file_name
		  fname=folder_name +"/" + file_name
          @training_set=read fname+".base"
          @testing_set=read fname +".test"
		else
		file_n=folder_name +"/u.data"
    	@training_set=read file_n
      @testing_set=[]
    end
  end
   # return the rate that user u give to movie m
   # it will return 0 if user did not rate
   #===============================================
       def rating u,m
         if	@training_set[u][m].nil?
          0
         else
          @training_set[u][m]
         end 
       end
       #+=========================================
       # return the program rating predict for movie m by user u
       def predict u,m
        sum=0
        count=0
        @training_set.each do |u,movies|
         if movies.keys & [m]==[m]
         sum+=movies[m]
         count+=1
         end
        end
        if(count!=0)
          sum/count
        else
         0
        end
       end
       #===============================
       # retun the array of movies that user u watches 
       def movies u
       	 @training_set[u].keys
       end
       #=============================================
       # return the array of users who watches movie m
       def viewers m
       	viewers_m=Array.new
        @training_set.each do |u,m1|
        	if m1.keys & [m]==[m]
             viewers_m+=[u]
          end# end if 
        end # end do 
         return viewers_m
       end
       #==============================================
       # run the test for k or the whole test_set
       def run_test k=0
         flag=1
         movie_test=Array.new
         @testing_set.each do |u,m| 
         if flag==1
           m.each do|movie,r| 
           p=predict u, movie 
           movie_test.push (ViewerInfo.new(u,movie,r,p))
           if k>0
            if movie_test.length==k
             flag=0
             break
            end
           end
         end
        end
        end
        MovieTest.new(movie_test)
      end
      #=====================================================
      # read the file and return either a testing or training set
       def read file_name
         	train=Hash.new{|hash, key| hash[key] = Hash.new}
         	File.open(file_name,"r") do |file|
    		  while (line = file.gets)
    		  	data=line.split(" ") # split the line by placeholder " "
		        train[data[0].to_i][data[1].to_i]=data[2].to_i
    		  end
    		  end
    		  return train
         end
     end # end of the class
     # class to save the viewer information
class ViewerInfo
 attr_accessor :u,:m,:r,:p
 # the class constructor take ethere 0 or 4 parameter
 def initialize user_id=nil, movie_id=nil,movie_rating=0,movie_predict=0
  @u=user_id
  @m=movie_id
  @r=movie_rating
  @p=movie_predict
 end
end# end of the class
# class MovieTest to test the predction alogrithem
class MovieTest
  attr_accessor :movie_test
  # constructor to intlize the movie_test varabile
  def  initialize movie=nill
   if movie
     @movie_test=movie
   else
    @movie_test=Array.new
   end
  end
# return the average of the error predction
  def mean 
    result=@movie_test.inject(0){ |result,element|  result + element.r }
    presult=@movie_test.inject(0){|presult,element| presult + element.p}
   (( result.to_f/@movie_test.length) - (presult.to_f/@movie_test.length)).abs
  end
  # return the satander deviation of the error
def stdv
 result=@movie_test.inject(0){ |result,element|   result + ((element.r - element.p)**2)}
 Math.sqrt (result)
end 
# return the root mean square error of the predection
def rms 
  result=@movie_test.inject(0){ |result,element| result + (element.r - element.p)**2 }
  Math.sqrt (result.to_f/@movie_test.length)
end
  # return an array of the prediction in the form [u , m, r, p]
  def to_a
   prediction_a=Array.new(Array.new) 
   @movie_test .each do|viewer_info|
   prediction_a.push([viewer_info.u,viewer_info.m,viewer_info.r,viewer_info.p])
    end
   prediction_a
  end
end # end of the classs
     movie_user=MovieData.new"ml-100k","u1"
     t1= Time.now
     x=movie_user.run_test(10)
     t2=Time.now
     puts " the time it take to predict 10 ratings is=  " + ((t2 - t1) * 1000).to_s + " Mileseconds"
     puts "The Movie data"
      x.to_a.each do |v|
       puts v.inspect
      end
     puts " the average prediction error= " + x.mean.to_s
     puts " the stander deviation error= " + x.stdv.to_s
     puts " the squre root the root mean square error of the predection = " + x.rms.to_s