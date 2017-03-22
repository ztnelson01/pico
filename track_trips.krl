ruleset track_trips{
  meta {
    name "Hello World"
    description <<
A first ruleset for the Quickstart
>>
    author "Phil Windley"
    logging on
    shares __testing
  }

  global {
    hello = function(obj) {
      msg = "Hello " + obj;
      msg
    }

    long_trip = 5

    __testing = {
            "events": [ { "domain": "car", "type": "new_trip", "attrs": [ "mileage" ]   }  ]
          }

  }

  rule process_trip {
    select when car new_trip
    pre{
      input = event:attr("mileage")
    }
    send_directive("trip") with
      option = input
      timeStamp = time:now()
    fired{
      raise explicit event "trip_processed"
      attributes event:attrs()
    }
  }

  rule find_long_trips{
    select when explicit trip_processed
    pre{
      mileage = event:attr("mileage").as("Number")
    }
    if (mileage > long_trip) then noop()
    fired{
      raise explicit event "found_long_trip"
      attributes event:attrs()
    }
  }

  rule found_long_trip{
    select when explicit found_long_trip
    pre{
      input = event:attr("mileage")
    }
    send_directive("trip") with
      option = "found a long trip with mileage: " + input
  }
}
