angular.module('bestLocatorApp').controller('TripsCtrl',['$scope', 'Restangular','$window','$modal',function($scope, Restangular, $window, $modal) {
  var busStopLocationWatch;
  var geoLocationWatch;

  $scope.bounds = new google.maps.LatLngBounds(
    new google.maps.LatLng(18, 71),
    new google.maps.LatLng(19, 73));

   $scope.mapOptions = {
      bounds: $scope.bounds,
      types: 'geocode',
     country: 'in',
      boundsEnabled: true,
      componentEnabled: true,
      watchEnter: true
   };

  $scope.start = function() {
    $scope.route = null;
    $scope.routes = null;
    $scope.start_bus_stop = null;
    $scope.end_bus_stop = null;
    $scope.end_area = null;
    $scope.end_areas = null;
    $scope.trip = null;
    $scope.points = [];
    $scope.geocode_accurate = true;
    $scope.current_location = {lat: 0, lon: 0};
    $scope.spottedRoute = null;
  };

  var initialize = function() {
    $scope.start();
    $scope.state = 'loading';
    Restangular.one('api/v1/trips/live').get().then(function(live_trips) {
      if (live_trips.length > 0) {
	$scope.trip = live_trips[0];
      } else {
	if (navigator.geolocation) {
	  //$scope.current_location.lat = 19.1860811;
	  //$scope.current_location.lon = 72.8340963;
	  console.log('geolocation supported');
	  //load_stops(true);
	   navigator.geolocation.getCurrentPosition(function(p) {
	     console.log(p);
	     $scope.current_location = {lat: p.coords.latitude, lon: p.coords.longitude};
	     $scope.position = p;
	     load_stops(true);
	   });
	} else {
	  error('not supported');
	}
      }
    }, function() {
      load_stops(true);
    });
  };


  initialize();

  var getGeoLocation = function() {
    console.log('Updating location...');
    geoLocationWatch = navigator.geolocation.watchPosition(updateLocation, failedLocation, {timeout: 5000, enableHighAccuracy: true});
  };

  $scope.getBusStopLocation = function() {
    busStopLocationWatch = navigator.geolocation.watchPosition(
      gotLocation, failedLocation, { maximumAge: 0, enableHighAccuracy: true}
    );
  };


  var gotLocation = function(position) {
    var c = position.coords;
    if (true) {
      $scope.current_location = {lon:c.longitude, lat:c.latitude};
      console.log('#gotLocation', position);
      console.log(new Date(position.timestamp));
      window.navigator.geolocation.clearWatch( busStopLocationWatch );
      load_stops(true);
    }
  };

  var failedLocation = function(msg) {
    console.log('failed to get position');
  };

  var busStops = Restangular.all('api/v1/bus_stops');
  var load_stops = function(reset) {
    console.log('loading stops', $scope.current_location);
    $scope.bus_stops = busStops.getList({center_lat: $scope.current_location.lat, center_lon: $scope.current_location.lon}).then(function(bs) {
      $scope.bus_stops = bs;
      if(reset) {
	$scope.start_bus_stop = bs[0];
	$scope.routes = bs[0].routes;
	$scope.state = 'choose_route';
      }

    });
  };


  var load_stop = function(id) {
    Restangular.one('api/v1/bus_stops', id).get().then( function(r) {
      $scope.routes = r.routes;
      $scope.state = 'choose_route';
    });
  };

  $scope.makeBusStop = function(bus_stop_data){
    console.log("makeBusStop", arguments);
    if (arguments[1] === "end") {
      $scope.end_bus_stop = bus_stop_data;
      Restangular.one('api/v1/browse/route?start_bus_stop=' + $scope.start_bus_stop.display_name + '&end_bus_stop=' + $scope.end_bus_stop.display_name).get().then(function(data) {
	$scope.routes = data;
	$scope.go_choose_route();
      });
    } else {
      $scope.start_bus_stop = bus_stop_data;
      console.log("LoadingStops");
      load_stop($scope.start_bus_stop.id);
    }
  };




  $scope.clear = function() {
    $scope.trip = null; $scope.route = null; $scope.points = []; $scope.end_bus_stop = null;
  };


  $scope.showRoute = function(r) {
    $scope.state = 'show_route';
    Restangular.one('api/v1/routes', r.id).get().then(function(route) {
      $scope.route = route;

    });
  };

  $scope.showRouteOnMap = function() {
    var route = _.map($scope.route.stops, function(stop) { return new google.maps.LatLng(stop.lat, stop.lon) });
    var route_path = new google.maps.Polyline({path: route});
    route_path.setMap($scope.mapInstance);
    google.maps.event.trigger($scope.mapInstance, 'resize');
  };

  $scope.map = {
    center: {
      latitude: 19.22,
      longitude: 72.75
    },
    draggable: true,
    refresh: true,
    zoom: 11,
    events: {
      idle: function(map) {
	console.log('init');
	google.maps.event.trigger(map, 'resize');
        $scope.mapInstance = map;
      },
      tilesloaded: function (map) {
        $scope.$apply(function () {
        });
      },
      dragend: function(map) {
	console.log(map.center);
      },
      resize: function(map) {
	console.log('resize');
      }
    }
  };

  $scope.go_choose_route = function() {
    $scope.state = 'choose_route';
  };


   $scope.autocomplete = "";
   $scope.details = {};
   $scope.watchDetails = function() { return $scope.details };

   $scope.$watch($scope.watchDetails, function() {
     if ($scope.details.geometry) {
       $scope.end_lat = $scope.details.geometry.location.lat();
       $scope.end_lon = $scope.details.geometry.location.lng();
       Restangular.all('api/v1/routes?lat1=' + $scope.start_bus_stop.lat + '&lon1=' + $scope.start_bus_stop.lon + '&lat2=' + $scope.end_lat +  '&lon2=' + $scope.end_lon).getList().then(function(r) {
	 $scope.routes = r;

       });
     }
   });

  $scope.spotBus = function() {
    console.log('bus Spotted!');
  };

  $scope.open = function (route,size) {
    console.log('opening modal');
    $scope.spottedRoute = route;
    console.log(route);
    var modalInstance = $modal.open({
      templateUrl: 'busSpot.html',
      controller: 'ModalInstanceCtrl',
      resolve: {
        data: function () {
          return {spottedRoute: $scope.spottedRoute, position: $scope.position, trip: $scope.trip};
        }
      }
    });
    modalInstance.result.then(function(direction) {
      console.log($scope.spottedRoute, direction);
    });
  };





}]);


angular.module('bestLocatorApp').controller('ModalInstanceCtrl',['$scope', '$modalInstance', 'data','Restangular',function ($scope, $modalInstance, data, Restangular) {

  $scope.spottedRoute = data.spottedRoute;
  $scope.position = data.position;
  $scope.directions = [{direction: "1", name: $scope.spottedRoute.end_stop}, {direction: -1, name:$scope.spottedRoute.start_stop}];
  $scope.x = {};
  $scope.x.spottedDirection = null;
  $scope.ok = function () {
    $modalInstance.close($scope.selected.item);
  };

  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };


  $scope.ready = function() {
    console.log($scope.bus_stops);
    $scope.state = 'start';
  };

  $scope.spotBus = function() {
    console.log('bus Spotted! at ', $scope.position, ' going', $scope.x.spottedDirection);

    var c = $scope.position.coords;
    if (c.accuracy > 1000000) {
      $scope.geocodeAccurate = false;
      console.log("Accuracy is poor (" + c.accuracy + "). Ignoring");
    } else {
      $scope.geocodeAccurate = false;
      $scope.status = "sending update....";
      Restangular.all('api/v1/location_reports').post(
	{
	  location_report: {
	    route_id: data.spottedRoute.id,
	    lat: c.latitude,
	    lon: c.longitude,
	    accuracy: c.accuracy,
	    heading: $scope.x.spottedDirection,
	    speed: c.speed
	  }
	}).then(function(d) {
	  $modalInstance.close($scope.x.spottedDirection);
	});
    }
  };
}]);
