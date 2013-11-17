angular.module("bestLocatorApp").controller("TripsCtrl",["$scope","Restangular","$window",function(t,o,n){t.status="ready",t.route=null,t.start_bus_stop=null,t.end_bus_stop=null,t.trip=null,t.points=[];var e=function(){o.one("api/v1/trips/live").get().then(function(o){o.length>0&&(t.trip=o[0],navigator.geolocation.watchPosition(i,a,{timeout:5e3}))})};e();var i=function(n){t.status="updating location....";var e=n.coords;o.all("api/v1/location_reports").post({location_report:{trip_id:t.trip.id,lat:e.latitude,lon:e.longitude,accuracy:e.accuracy,heading:e.heading,speed:e.speed}}).then(function(){t.points.push(n),t.status="ready"})},s=function(o){t.current_location={lon:o.coords.longitude,lat:o.coords.latitude},p()},a=function(){console.log("failed to get position")};navigator.geolocation?navigator.geolocation.getCurrentPosition(s,a):error("not supported");var u=o.all("api/v1/bus_stops"),p=function(){t.bus_stops=u.getList({center_lat:t.current_location.lat,center_lon:t.current_location.lon}).then(function(o){t.bus_stops=o})};t.makeBusStop=function(n){"end"===arguments[1]?t.end_bus_stop=n:t.start_bus_stop=n,o.one("api/v1/bus_stops/"+n.properties.slug).get().then(function(o){r=o.properties.routes.split(","),t.start_bus_stop.routes=r})},t.chooseRoute=function(n){o.one("api/v1/routes/").get({q:n}).then(function(n){t.route=n,o.one("api/v1/routes/"+n.code).get().then(function(o){t.route.stops=o})})},t.startTrip=function(){var n=t.start_bus_stop.properties,e=t.end_bus_stop.properties;o.all("api/v1/trips").post({trip:{bus_number:t.route.code,start_stop_id:n.id,start_stop_name:n.display_name,start_stop_code:n.code,end_stop_id:e.id,end_stop_name:e.display_name,end_stop_code:e.code}}).then(function(o){t.trip=o,navigator.geolocation.watchPosition(i,a,{timeout:5e3})})},t.stopTrip=function(){return null===t.trip?!1:(o.one("api/v1/trips/"+t.trip.id+"/stop").put().then(function(){n.location.href="/"}),void 0)},t.clear=function(){t.trip=null,t.route=null,t.points=[],t.end_bus_stop=null}}]);