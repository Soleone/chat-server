# external dependencies
require 'rubygems'
require 'eventmachine'
require 'evma_httpserver'
require 'cgi'
require 'erb'

# project dependencies
$LOAD_PATH.unshift(File.dirname(__FILE__) + "/chat-server")

require 'room'
require 'chatter'

module Chat
  TEMPLATES_DIR = File.dirname(__FILE__) + "/../templates"
  
  @css_content        = File.read(TEMPLATES_DIR + "/chat.css")
  @javascript_content = File.read(TEMPLATES_DIR + "/chat.js")
  
  WELCOME_HTML = ERB.new(File.read(TEMPLATES_DIR + "/chat.html.erb")).result(binding)
  
  ROOM = Room.new  
end


if __FILE__ == $0
  EventMachine.epoll

  EventMachine::run do
    EventMachine::start_server("0.0.0.0", 8080, Chat::Chatter)
    puts "Listening on 8080..."
  end
end