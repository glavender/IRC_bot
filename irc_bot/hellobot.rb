require "socket"

server = "chat.freenode.net"
port = "6667"
nick = "PigLatinBot"
channel = "#bitmaker123"
greeting_prefix = "privmsg #{channel} :"
greetings = "pig "
def translate(word)
    arr = word.split(" ")
    arr.map do |x|
      if x.match(/[aeiouy]/) == nil
        "invalid"
      else
        num = x.index(/[aeiouy]/)
        num += 1 if x[num - 1] == "q"
        x[num..-1] + x[0...num] + "ay"
      end
    end.join(" ")
end

irc_server = TCPSocket.open(server, port)

irc_server.puts "USER bhellobot 0 * BHelloBot"
irc_server.puts "NICK #{nick}"
irc_server.puts "JOIN #{channel}"
irc_server.puts "PRIVMSG #{channel} :Type 'pig' followed by the words to be translated"

until irc_server.eof? do
  msg = irc_server.gets.downcase
  puts msg

  if msg.include?(greeting_prefix) && msg.include?(greetings)
    x = msg.index(greetings.chomp)
    mess = msg[(x + 4)..-1]
    if msg.include? " help"
      response = "Type 'pig' followed by the words to be translated. Type 'pig quit' to make PigLatinBot leave."
    elsif msg.include? " speak"
      response = "oink oink oink"
    elsif msg.include? " quit"
      irc_server.puts "PRIVMSG #{channel} :Goodbye, cruel world"
      abort
    else
  	 response = translate(mess)
    end
  	 irc_server.puts "PRIVMSG #{channel} :#{response}"
  end
end
