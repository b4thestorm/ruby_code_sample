# ruby_code_sample
CodeTest is a text parser that grabs input from 3 remote filepaths: 
http://www.cyrusinnovation.com/wp-content/uploads/2013/11/space.txt
http://www.cyrusinnovation.com/wp-content/uploads/2013/11/pipe.txt
http://www.cyrusinnovation.com/wp-content/uploads/2013/11/comma.txt

The Purpose of the CodeTest is to create a  composite of the 3 file paths
and to return it, organized as an array of string values with spaces separating
each piece of data at each level of the array.

To run CodeTest,  simply call:

ruby codetest.rb (int)   <-- in the terminal    

With “int” being any number value within the range 1-3 for the desired output:

ruby codetest.rb 1 <--- is the output sorted by gender
ruby codetest.rb 2 <--- is the output sorted by birthdate 
ruby codetest.rb 3 <--- is the output sorted by lastname

CodeTest also comes with a test file for development maintenance purposes.
To run the CodeTest test's, simply call:

ruby test_codetest.rb
