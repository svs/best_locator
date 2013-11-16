angular.module('bestLocatorApp').controller('TripsCtrl',['$scope', 'Restangular',function($scope, Restangular) {
    $scope.trip = {
	new: true
    }
    $scope.status = "ready"

    var updateLocation = function(position) {
	$scope.status = "updating location...."
	Restangular.all('api/v1/location_reports').post({location_report: {trip_id: $scope.trip.id, lat: position.coords.latitude, lon: position.coords.longitude}}
	).then(function(d) {
	    $scope.status = "ready"
	});
    }
    var gotLocation = function(position) {
	$scope.current_location = {lon:position.coords.longitude, lat:position.coords.latitude}
	load_stops();
    }

    var failedLocation = function(msg) {
	console.log('failed to get position');
    }

    if (navigator.geolocation) {
	navigator.geolocation.getCurrentPosition(gotLocation, failedLocation);
    } else {
	error('not supported');
    }

    var busStops = Restangular.all('api/v1/bus_stops');
    var load_stops = function() {
	$scope.bus_stops = busStops.getList({center_lat: $scope.current_location.lat, center_lon: $scope.current_location.lon}).then(function(bs) {
	    $scope.bus_stops = bs;
	});
    };
    $scope.bus_stop = {name: "No stop chosen", routes: []}

    $scope.makeBusStop = function(bus_stop_data){
	$scope.bus_stop = bus_stop_data;
	Restangular.one('api/v1/bus_stops/' + bus_stop_data.properties.slug).get().then(function(data) {
	    r = data.properties.routes.split(",");
	    $scope.bus_stop.routes = r;
	});
    }

    $scope.chooseRoute = function(name) {
	Restangular.one('api/v1/routes/').get({q: name}).then(function(data) {
	    $scope.route = data;
	    Restangular.one('api/v1/routes/' + data.code).get().then(function(d) {
		$scope.route.stops = d;
	    });
	});
    };

    $scope.startTrip = function() {
	Restangular.all('api/v1/trips').post({trip: {bus_number: $scope.route.code, start_stop_id: $scope.bus_stop.properties.id}}).then(function(r) {
	    $scope.trip = r;
	    navigator.geolocation.watchPosition(updateLocation, failedLocation, {timeout: 5000});
	});
    }




}]);
