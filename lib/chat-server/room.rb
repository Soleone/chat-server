module Chat

  class Room < EM::Channel
    attr_accessor :log
  
    def initialize
      @log = []
      super
    end
    
    def say(msg)
      @log << msg
      push(msg)
    end
  end
  
end