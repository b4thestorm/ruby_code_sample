#data grabber needs to be initiated for any parsing to happen.
module DataGrabber
  require 'uri'
  require 'net/http'
  require 'pry'

Extensions = ['/wp-content/uploads/2013/11/comma.txt','/wp-content/uploads/2013/11/pipe.txt', '/wp-content/uploads/2013/11/space.txt' ]

  def get_data(path)
    url = "http://www.cyrusinnovation.com"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(path)
    response = http.request(request)
    response.body
  end

end


module Parser
  require 'date'
  require 'pry'

#1.remove the delimiters
#2.remove the extra data
#3.correct the gender
#4. swap the data
#5, reformat the date

  def zip_lines(response)
    container = []
    response.each_line do |line|
    container.push(remove_delimeter(line))
  end
    container
  end 


  def remove_delimeter(target)
    if target.include?("|" )
      target.chomp.split("|")
    elsif target.include?(",") 
      target.chomp.split(",")
    else 
      target.chomp.split(" ")
    end
  end

  def delete_extra_element(input)
    input.each {|element| element.delete_at(2) if element.length == 6}
  end 

  def full_gender(input)
    x = 0
    while  x <= (input.length - 1)
      if input[x][2].include?('F') 
        input[x][2] = 'Female'
      elsif input[x][2].include?('M')
        input[x][2] = 'Male' 
      end
    x += 1
  end
   input
  end 

  def swap!(input) 
    count = 0
    while count <= (input.length - 1) 
      if !!(input[count][4] =~ (/\d/))
        input[count][4], input[count][3] = input[count][3] , input[count][4]
      end
      count += 1
    end
    input  
  end

  def pretty_date(input)
    count = 0
    return input if input[0][3] =~ /\//
    while count < input.size
      input[count][3] = Date.parse(input[count][3].strip).strftime('%-d/%-m/%Y')
      count += 1
    end
   input
  end


  def make_date_parsable(input)
    count = 0
    while count < input.length
      date = input[count][3].strip.split("/")
      date = "#{date[1]}/#{date[0]}/#{date[2]}"
      input[count][3] = Date.parse(date)
      count += 1
    end
    input
  end

  def retouch_date(input)
    count = 0
    while count < input.length
      input[count][3] = input[count][3].strftime('%-m/%-d/%Y')
      count += 1
    end
    input
  end

  def format_rows(data)
    zipped  = zip_lines(data)
    deleted = delete_extra_element(zipped)
    gendered = full_gender(deleted)
    swapped = swap!(gendered)
    dated = pretty_date(swapped)
  end

end

class Sorter 
  include DataGrabber
  include Parser
  require 'pry'
  
#returns all the formatted rows from each extension path
  def all_formatted_data
    count = 0
    body = []
    while count <= DataGrabber::Extensions.length - 1
      response = get_data(DataGrabber::Extensions[count])
      body << format_rows(response)
     count += 1
    end 
    body
  end 

  #output #1
  def sort_gender
    input = all_formatted_data.flatten(1)
    sorted_gender = []
    female_array , male_array = input.partition {|y| y[2] == 'Female'}
    sorted_gender <<  lastname_asc(female_array) + lastname_asc(male_array)
  end

  #output #2
  def sort_birthdate
    input = all_formatted_data.flatten(1)
    output = make_date_parsable(input)
    result = output.sort {|a, b| a[3] <=> b[3] }
    date_fix = retouch_date(result)
  end
  
  #output #3
  def sort_lastname_desc
    input = all_formatted_data.flatten(1)
    collector = input.sort {|a, b| b <=> a}
    collector
  end  

  def lastname_asc(input)
    collector  = input.sort {|a, b| a <=> b}
    collector
  end
  
end

class OutPut 
def format_output(finalproduct) 
    finalproduct.map! do |element|  
      element*" "
    end
  end 

  def output_engine(int)
      sort_obj = Sorter.new
   if int.eql?(1)
      sorted_by_gender = sort_obj.sort_gender[0]
      format_output(sorted_by_gender)
    elsif int.eql?(2)
      sorted_by_birthdate = sort_obj.sort_birthdate
      format_output(sorted_by_birthdate)
    elsif int.eql?(3)
      sorted_by_lastname = sort_obj.sort_lastname_desc
      format_output(sorted_by_lastname)
    end
  end
end

output = OutPut.new
puts output.output_engine(ARGV[0].to_i)

