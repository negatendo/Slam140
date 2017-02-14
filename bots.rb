#!/usr/bin/env ruby
# encoding: utf-8

require 'twitter_ebooks'

# This is an example bot definition with event handlers commented out
# You can define as many of these as you like; they will run simultaneously

Ebooks::Bot.new("Slam140") do |bot|
  # Consumer details come from registering an app at https://dev.twitter.com/
  # OAuth details can be fetched with https://github.com/marcel/twurl
  bot.consumer_key = "" # Your app consumer key
  bot.consumer_secret = "" # Your app consumer secret
  bot.oauth_token = "" # Token connecting the app to this account
  bot.oauth_token_secret = "" # Secret connecting the app to this account

  #keeps track of followers
  followers = Array.new()

  #people who have been tweeted resets every hour
  tweeted = Array.new()

  #all the possiblee replies
  bot_replies = [
    'BOOOM SHAKALAKA',
    'BooooooooooooooooooooOOOM SHAKALAKA!!!!',
    'BLESS THE INTERNET CYBERMOM FOR THIS GLORIOUS DAYYYY!',
    'ATTN ALL OF TWITTER YOU NEED TO SEE THIS 140 SLAM DUNK!',
    'SCOOOOOREEE! SCOOOOOOREEE! AHSHFLAKSJDJD!!!',
    'TWOOOSH!',
    'TWOOOOOOOOSH!',
    'TWOOOOOOOOOOOOOOOOOOOOOSH!',
    'TWOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOSH!',
    'HAHAHAHAHAHAHAHH WOOOOOOOWWW!',
    'HEYOOO!',
    'HEYYOOOOOOOOOOOOOOOOOOO!',
    'l;aksdjf ;laksdfjh ;asdkfjl!!!',
    'asd;lgfa;woirhgaowirhg;alwirgh!!!111!!!1!',
    'ZOMMMMNGGGGGG!!1!!11 HAHgggg! I cannOT EVEN!',
    'Thats alllllll folks 140 characters of MAGIIIIICCCCC!',
    'HEYOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO!',
    'OHHH MYYYYYY ASDASDFJH fdjshf asdkjfh !!!',
    'WHOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO!',
    '*crowd goes wild*',
    'AHHHHHHHH I CANNNOT BELIIEVEVEe!!',
    '*faints*',
    'WOOOOOOOOWWWWW!!!! You are amazing!',
    'You are incredible.',
    'Wow. Masterclass tweeter. I am privileged to follow you. I mean that.',
    'Woooooowww did I even actually *see* that?',
    '*rubs cyber-eyes in disbelief*',
    'AMAAAAAAAAAAAAAZZIIINNNNNNGGGGGG!',
    '140 CHARACTERS OOHHHHH YEAAAAA!',
    '140. Character. Perfection.',
    '140 character bliss',
    '140 character beauty',
    '140 character GREATNESS',
    '140 characterrrrs!',
    'ONE FOUR TEYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY!',
    'YOU. ARE. GREATNESS.',
    'BOW DOWN BEFORE THE LORD OF THE TWEETS!',
    'HOOOOLLY CRAP DO YOU KNOW HOW HARD THAT IS?1?!?!',
    'LITERALLY DEAD. DEAD!',
    '140140140140140140 1 4 0!',
    'AHHHHHH! AAAAHHHH! *cough wheeze* AHAHAHAAAAAAAAAAAAAAAAAAAA!',
    'SLAMMMMMMMMM DUNNNNNNNNNNK!',
    'SLAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAM!',
    'HOLY GREAT CYBERMOTHER OF THE INTERNET 140 SLAM DUNK!',
    '*cries with joy* A beautiful 140 character tweet.',
    "that's what I call tweeting!",
    'marry me',
    'please have my robo children',
    'did i actually just witness that? was that a 140 slam dunk? i can HARDLY BELIEVE IT!!!',
    '*slaps own face repeatedly*',
    'Amazing. I just- Amazing.',
    'That was the most incredible thing. Oh wow. WOW!',
    'WOW!',
    'WOOOOOOOWWW~!',
    'WWWWWWWWWWWWWWWWAAAAAAAAAAAAAAAAAAAAAAAAAAT?!?!',
    'what? What? WHAT?!',
    'One hundre-- ONe hundred fouertly charactyers ag IU cantt evern tyep1',
    'SO EXCITED I JUST THREW MY PHONE',
    ':O you... you did it',
    'oh my... you really did it... YOU DID IT!!!',
    'AHAHHHHHAHHHH! AMAMAZINNNG! AHHHHGGG!',
    'I am so happy I was online to see that.',
    'I have just witnessed HISTORY.',
    'HISTORY IN THE MAKING RIGHT HERE PEOPLE',
    'Are you sure yr not a bot? I mean, the accuracy. THE PERFECTION.',
    'Perfect. <3',
    'Wow.',
    'Wowww140',
    'WOOOOOO!',
    'MY EYES FLOW WITH TEARS AT THE BEAUTY OF THAT TWEET',
    'Beautiful tweet. Beauuuuutifullll.'
  ]

  bot.on_startup do
    #get our current followers list
    followers = bot.twitter.followers.map { |x| x[:screen_name] }
  end

  bot.on_follow do |user|
    # Follow a user back
    bot.follow(user[:screen_name])
  end

  bot.on_timeline do |tweet, meta|
    # no rt or manual rt
    next if tweet[:retweeted_status] || tweet[:text].start_with?('RT')

    # Count the number of characters in the tweet
    next if meta[:mentionless].length < 140

    #skip if already awarded this hour
    next if tweeted.include? tweet[:user][:screen_name]

    bot.log("140 character tweet detected from " + meta[:reply_prefix])
    sleep rand(1..10)

    bot.log("...faving")
    bot.twitter.favorite(tweet[:id])

    bot.log("...replying")
    bot.reply(tweet, meta[:reply_prefix] + bot_replies.sample)

    #add user to tweeted
    tweeted << tweet[:user][:screen_name]
  end

  bot.scheduler.every '1h' do
    #clear the list of the tweeted
    bot.log("clearing tweeted")
    tweeted = []
  end

  bot.scheduler.every '8h' do
    bot.log("cleaning followers")
    ### Check for follow/unfollow to-dos on schedule:
    followers = bot.twitter.followers.map { |x| x[:screen_name] }
    following = bot.twitter.following.map { |x| x[:screen_name] }
    to_follow = followers - following
    to_unfollow = following - followers
    bot.twitter.follow(to_follow) unless to_follow.empty?
    bot.twitter.unfollow(to_unfollow) unless to_unfollow.empty?
    following -= to_unfollow
    bot.log "Followed #{to_follow.size}; unfollowed #{to_unfollow.size}."
  end 
end
