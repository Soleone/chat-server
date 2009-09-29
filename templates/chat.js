var Chat = Class.create({
  chat: null,
  msg: new Template('<div><span class="nick">#{nick}</span></a><span class="msg">#{msg}</span></div>'),
  em:  new Template('<div class="em"><span class="nick">&nbsp;</span></a><span class="msg">#{msg}</span></div>'),
      
  chatters: [],
  
  initialize: function(chat) {
    this.chat = $(chat);
  },
  
  joinChat: function(params) {
    var assigns = {msg: (params.nick || 'Someone') + ' joined the chat' };
    this._append( this.em.evaluate(assigns) );
  },
  
  leaveChat: function(params) {      
    var assigns = {msg: (chatter.nick || 'Someone') + ' left the chat' };
    this._append( this.em.evaluate(assigns) );      
  },
  
  say: function(params) {
    this._append( this.msg.evaluate(params) );
  },    
  
  dispatch: function() {
    switch(json[i].action) {
    case 'leave': leaveChat(json[i]);
    case 'join':  joinChat(json[i]);
    case 'say':   say(json[i]);          
    };
  },    

  /* Private */
  
  _append: function(msg) {
    this.chat.appendChild( new Element('div', {'className': 'line'}).update(msg) );
  }
});


var Connection = Class.create({    
  initialize: function(channel) {
    this.chat = chat;
    this.requestLog();      
  },
      
  put: function() {
    var msg = $F('msg');
    var nick = $F('nick')
    new Ajax.Request('/say?msg=' + encodeURIComponent(msg) + '&nick=' + encodeURIComponent(nick));
    $('msg').value = '';
  },    
  
  onData: function(e) {
    if (e != '' && e != 'nil') {
      eval('var json = ' + e.responseText);
      for (var i=0; i < json.length; i++) {
        this.chat._dispatch(json[i]);
      };
    }
    setTimeout(this.request.bind(this), 0);
  },
  
  request: function() {
    new Ajax.Request('/poll', {method: 'get', onSuccess:this.onData.bind(this)});
  },

  requestLog: function() {
    new Ajax.Request('/log', {method: 'get', onSuccess:this.onData.bind(this)});
  }
});



$(document).observe('dom:loaded', function(){
  
  var chat = new Chat('chat-log');
  //var connection = new Connection(chat);

  chat.joinChat({nick: 'tobi'})
  chat.say({nick: 'tobi', msg: 'hey guys...'})
  chat.say({nick: 'tobi', msg: 'hey hows it going?'})
  chat.say({nick: 'cody', msg: 'yo'})
  chat.say({nick: 'cody', msg: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'})

  //setInterval(function(){say({nick: 'test', msg: 'random text....'})}, 1000);
  
});