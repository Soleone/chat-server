module Chat
  
  class Chatter < EventMachine::Connection
    include EventMachine::HttpServer
  
    def unbind
      ROOM.unsubscribe(@subscription)
    end
 
    def parse_params
      params = ENV['QUERY_STRING'].split('&').inject({}) {|p, s| k,v=s.split('=');p[k.to_s]=CGI.unescape(v.to_s);p}
      params
    end  

    def process_http_request
      puts "#{object_id}: #{method = ENV["REQUEST_METHOD"]} #{action = ENV["PATH_INFO"]} #{ENV["QUERY_STRING"]}"
    
    
      case action
      when '/'      

        response = EventMachine::DelegatedHttpResponse.new( self )
        response.headers['Content-Type'] = 'text/html'
        response.headers['Content-Length'] = WELCOME_HTML.length.to_s
        response.status  = 200
        response.content = WELCOME_HTML
        response.send_response

      when '/log'
      
        response = EventMachine::DelegatedHttpResponse.new( self )
        response.headers['Content-Type'] = 'text/plain'
        response.status  = 200
        response.content = "[#{ROOM.log.join(',')}]"
        response.send_response

      when '/poll'
      
        response = EventMachine::DelegatedHttpResponse.new( self )
      
        @subscription = ROOM.subscribe do |msg| 
          response.headers['Content-Type'] = 'text/plain'
          response.status  = 200
          response.content = "[#{msg}]"
          response.send_response
        end
      
      when '/say'
        params = parse_params
      
        ROOM.say(%|{"msg": #{params["msg"].inspect}, "nick": #{params["nick"].inspect}}|)
      
        response = EventMachine::DelegatedHttpResponse.new( self )
        response.headers['Content-Type'] = 'text/plain'
        response.status  = 200
        response.send_response          
      
      else
      
        response = EventMachine::DelegatedHttpResponse.new( self )
        response.headers['Content-Type'] = 'text/html'
        response.status  = 404
        response.content = %|<h1>Not Found</h1>"|
        response.send_response                
      end    
    end  
  end
  
end