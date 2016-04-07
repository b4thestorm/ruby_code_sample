require 'rubygems'
require 'uri'
require 'net/http'
require 'json'
require 'minitest/autorun'
require 'pry' 
require_relative 'codetest'


describe "Sorter" do

  before do 
    @sorter = Sorter.new
    @response = @sorter.get_data 'http://www.cyrusinnovation.com/wp-content/uploads/2013/11/pipe.txt'
  end

   it 'should retrieve the api data' do
     response = @response
     response.must_be_kind_of String
   end

   it 'should remove delimeters' do 
     zipped = @sorter.zip_lines(@response)
     zipped.wont_include("|")
     zipped.wont_include(",")
   end

  it 'should delete the extra element' do 
    deleted = final_length_data
    (deleted[0].length).must_equal(5)
  end 

  it 'should make gender a full word' do 
    input = final_length_data
    gendered = @sorter.full_gender(input)
    gendered[0][2].must_equal('Male')
  end

  it 'should swap the date' do 
   
    input = final_length_data
    swapped = @sorter.swap!(input)
    swapped[0][3].must_match(/[0-9]/)
  end

  it 'should normalize the date' do 
    input = final_length_data
    input = @sorter.swap!(input)
    prettier = @sorter.pretty_date(input)
    prettier[0][3].must_match(/\//)
  end
#------------------------------------------------------------
  it 'should grab every line of data' do 
    everything = @sorter.all_formatted_data
    (everything.flatten(1).length).must_equal(9)
  end
  
  it 'should be sorted by gender' do 
    sorted_gender = @sorter.sort_gender
    sorted_gender[0][0][2].wont_equal(sorted_gender[0][4][2])
  end

  it 'should be sorted by last name desc' do 
    sorted_lastname = @sorter.sort_lastname_desc
    (sorted_lastname[0][0][0]).must_be :>, sorted_lastname[0][1][0] 
  end

  it 'should be sorted by lastname asc' do 
    lastname_partial = @sorter.all_formatted_data[0].slice(0, 3)
    ascending = @sorter.lastname_asc(lastname_partial)
    ascending[0][0].must_be :<, ascending[1][0]
  end
  
  it 'should be sorted by date asc' do 
    sorted_birthdate = @sorter.sort_birthdate.slice(0,3)
    birthdate_asc = @sorter.make_date_parsable(sorted_birthdate)
    birthdate_asc[0][3].must_be :<, birthdate_asc[2][3]
  end

  def final_length_data
    zipped = @sorter.zip_lines(@response)
    final = @sorter.delete_extra_element(zipped)
  end 
end 
