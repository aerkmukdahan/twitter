module TweetsHelper

  def add_hash_tag_link( text )
    text.split(' ')
      .map do |word| 
        (word.start_with? '#') ? 
          "<a href=#{tweets_hash_tag_path(word)}>#{word}</a>" : 
          word 
      end.join(' ')
  end

end
