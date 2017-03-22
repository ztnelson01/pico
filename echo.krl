ruleset echo{
  meta {
    name "Hello World"
    description <<
A first ruleset for the Quickstart
>>
    author "Phil Windley"
    logging on
    shares hello, __testing
  }

  global {
    hello = function(obj) {
      msg = "Hello " + obj;
      msg
    }

    __testing = {
            "events": [ { "domain": "echo", "type": "hello", "attrs": [ "something" ]   },
                        { "domain": "echo", "type": "message", "attrs": [ "input" ]   }  ]
          }

  }

  rule hello_world {
    select when echo hello
    send_directive("say") with
      something = "Hello World"
  }

  rule message {
    select when echo message
    pre{
      input = event:attr("input")
    }
    send_directive("say") with
      something = input
  }

}
