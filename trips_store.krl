ruleset trips_store{
  meta {
    name "Hello World"
    description <<
A first ruleset for the Quickstart
>>
    author "Phil Windley"
    logging on
    shares __testing, trips, long_trips, short_trips
    provides trips, long_trips, short_trips
  }

  global {
    hello = function(obj) {
      msg = "Hello " + obj;
      msg
    }

    long_trip = 5

    __testing = {
            "queries": [ { "name": "short_trips"}],
            "events": [  { "domain": "car", "type": "trip_reset", "attrs": []   }  ]
          }

    trips = function(){
      ent:trips
    }
    long_trips = function(){
      ent:longTrips
    }
    short_trips = function(){
      shortTrips = ent:trips.filter(function(x){ x{"mileage"}.as("Number") < long_trip })
    }
  }

  rule collect_trips {
    select when explicit trip_processed
    pre{
      mileage = event:attr("mileage")
      time = time:now()
    }
    send_directive("trip") with
      mileage = mileage
      time = time
      always{
        ent:trips := ent:trips.append({"time": time, "mileage":mileage})
      }
  }

  rule collect_long_trips {
    select when explicit found_long_trip
    pre{
      mileage = event:attr("mileage")
      time = time:now()
    }
    send_directive("trip") with
      mileage = mileage
      time = time
      always{
        ent:longTrips := ent:longTrips.append({"time": time, "mileage":mileage})
      }
  }

  rule clear_trips{
    select when car trip_reset
    pre{
      mileage = event:attr("mileage")
      time = time:now()
    }
    send_directive("trip") with
      mileage = mileage
      time = time
      always{
        ent:trips := [];
        ent:longTrips := []
      }
  }
}
