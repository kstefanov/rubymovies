Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # we should arrange to add that movie to the database here.
    Movie.create movie
  end
end
 
Then /(.*) seed movies should exist/ do | n_seeds |
  assert Movie.count(n_seeds.to_i)
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  assert page.body =~ /#{e1}.*#{e2}/m, "#{e1} was not before #{e2}"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
 # use String#split to split up the rating_list, then
 # iterate over the ratings and reuse the "When I check..." or
 # "When I uncheck..." steps in lines 89-95 of web_steps.rb
 rating_list.split(',').each do |rating|
 field = "ratings_#{rating.strip}"
 if uncheck
 uncheck field
 else
 check field
 end
 end
end

Then /I should see all of the movies/ do
  movies = Movie.all
  
  if movies.size == 10
    movies.each do |movie|
      assert page.body =~ /#{movie.title}/m, "#{movie.title} did not appear"
    end
  else
    false
  end
end

Then /I should not see any movies/ do
  movies = Movie.all
  movies.each do |movie|
    assert true unless page.body =~ /#{movie.title}/m
  end
end

Then /^the director of "(.*?)" should be "(.*?)"$/ do |movie_title, new_director|
  movie = Movie.find_by_title movie_title
  movie.director.should == new_director
end