require "cinch"
require "open-uri"
require "json"

  
class Greeter
    include Cinch::Plugin
  
    match /hello$/, method: :greet
    def greet(m)
    m.reply "Hi there"
    end
end

class LibreFM
	include Cinch::Plugin
	
	match /np\ ?(.*)/, method: :scrobble
	
	def snark(m)

		nick = m.user.nick
		data = open("https://libre.fm/2.0/?method=user.getrecenttracks&user=#{nick}&page=1&limit=1&format=json") { |f| JSON.parse f.read }
		m.reply "Sorry #{nick}, but I cannot grok LibreFM scrobbles just yet :("

	end
	
	def scrobble(m, handle)

		if handle.strip.empty?  
			nick = m.user.nick
		else
			nick = handle
		end
		
		data = open("https://libre.fm/2.0/?method=user.getrecenttracks&user=#{nick}&limit=1&format=json") { |f| JSON.parse f.read }
		m.reply "#{nick}'s last scrobbled track was #{data["recenttracks"]["track"]["name"]} by #{data["recenttracks"]["track"]["artist"]["#text"]}"

	end

end
  
bot = Cinch::Bot.new do
    configure do |c|
        c.nick = "eebrah|bot"
        c.server = "chat.freenode.net"
        c.channels = ["#nairobilug"]
        c.plugins.plugins = [LibreFM]
        c.plugins.prefix = /^:/

    end
end
  
bot.start
