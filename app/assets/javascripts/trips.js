angular.module('bestLocatorApp').controller('TripsCtrl',['$scope', 'Restangular','$window',function($scope, Restangular, $window) {
    $scope.status = "ready"
    $scope.route = null;
    $scope.start_bus_stop = null;
    $scope.end_bus_stop = null;
    $scope.trip = null;
    $scope.points = [];
    $scope.geocode_accurate = false;
    var geolocation;

    var initialize = function() {
	Restangular.one('api/v1/trips/live').get().then(function(live_trips) {
	    if (live_trips.length > 0) {
		$scope.trip = live_trips[0];
		getGeoLocation();
	    } else {
		if (navigator.geolocation) {
		    $scope.getPosition();
		} else {
		    error('not supported');
	}


	    }
	});
    }


    initialize();

    var getGeoLocation = function() {
	geolocation = navigator.geolocation.watchPosition(updateLocation, failedLocation, {timeout: 5000, enableHighAccuracy: true});
    };

    $scope.getPosition = function() {
	navigator.geolocation.getCurrentPosition(gotLocation, failedLocation, {maximumAge: 0, enableHighAccuracy: true});
    };

    var updateLocation = function(position) {
	var c = position.coords
	if (c.accuracy > 100) {
	    $scope.geocodeAccurate = false;
	} else {
	    $scope.status = "updating location...."
	    Restangular.all('api/v1/location_reports').post(
		{
		    location_report: {
			trip_id: $scope.trip.id,
			lat: c.latitude,
			lon: c.longitude,
			accuracy: c.accuracy,
			heading: c.heading,
			speed: c.speed
		    }
		}).then(function(d) {
		    $scope.points.push(position);
		    $scope.status = "ready";
		});
	    window.navigator.geolocation.clearWatch( geolocation )
	    window.setTimeout( getGeoLocation, 60000 );
	}
    }


    var gotLocation = function(position) {
	$scope.current_location = {lon:position.coords.longitude, lat:position.coords.latitude}
	console.log(position);
	console.log(new Date(position.timestamp));
	load_stops();
    }

    var failedLocation = function(msg) {
	console.log('failed to get position');
    }

    var busStops = Restangular.all('api/v1/bus_stops');
    var load_stops = function() {
	$scope.bus_stops = busStops.getList({center_lat: $scope.current_location.lat, center_lon: $scope.current_location.lon}).then(function(bs) {
	    $scope.bus_stops = bs;
	});
    };

    $scope.makeBusStop = function(bus_stop_data){
	if (arguments[1] === "end") {
	    $scope.end_bus_stop = bus_stop_data;
	} else {
	    $scope.start_bus_stop = bus_stop_data;
	}
	Restangular.one('api/v1/bus_stops/' + bus_stop_data.slug).get().then(function(data) {
	    $scope.start_bus_stop.routes = data;
	});
    }



    $scope.chooseRoute = function(id) {
	Restangular.one('api/v1/routes/' + id).get().then(function(data) {
	    $scope.route = data;
	});
    };

    $scope.startTrip = function() {
	var sp = $scope.start_bus_stop
	var ep = $scope.end_bus_stop
	Restangular.all('api/v1/trips').post(
	    {trip:
	     {bus_number: $scope.route.code,
	      start_stop_id: sp.id,
	      start_stop_name: sp.display_name,
	      start_stop_code: sp.code,
	      end_stop_id: ep.id,
	      end_stop_name: ep.display_name,
	      end_stop_code: ep.code,
	     }
	    }
	).then(function(r) {
	    $scope.trip = r;
	    getGeoLocation();
	});
    }

    $scope.stopTrip = function() {
	if ($scope.trip === null) {
	    return false
	}
	Restangular.one('api/v1/trips/' + $scope.trip.id + '/stop').put().then(
	    function(d) {
		$window.location.href = "/";
	    });
    }

    $scope.clear = function() {
	$scope.trip = null; $scope.route = null; $scope.points = []; $scope.end_bus_stop = null;
    }

}]);
