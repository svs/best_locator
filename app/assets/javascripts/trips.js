angular.module('bestLocatorApp').controller('TripsCtrl',['$scope', 'Restangular','$window','$modal',function($scope, Restangular, $window, $modal) {
  var busStopLocationWatch;
  var geolocationWatch;

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
    $scope.status = "ready";
    $scope.state = 'start';
    $scope.route = null;
    $scope.routes = null;
    $scope.start_bus_stop = null;
    $scope.end_bus_stop = null;
    $scope.end_area = null;
    $scope.end_areas = null;
    $scope.trip = null;
    $scope.points = [];
    $scope.geocode_accurate = false;
    $scope.current_location = {lat: 0, lon: 0};
    $scope.spottedRoute = null;
  };

  $scope.start();


  var initialize = function() {
    Restangular.one('api/v1/trips/live').get().then(function(live_trips) {
      if (live_trips.length > 0) {
	$scope.trip = live_trips[0];
      } else {
	if (navigator.geolocation) {
	  $scope.getBusStopLocation();
	  load_stops(true);
	} else {
	  error('not supported');
	}
      }
    }, function() {
      load_stops();
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

  var updateLocation = function(position) {
    var c = position.coords;
    if (c.accuracy > 100) {
      $scope.geocodeAccurate = false;
      console.log("Accuracy is poor (" + c.accuracy + "). Ignoring");
    } else {
      $scope.geocodeAccurate = false;
      $scope.status = "sending update....";
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
      window.navigator.geolocation.clearWatch( geoLocationWatch );
      window.setTimeout( getGeoLocation, 60000 );
    }
  };


  var gotLocation = function(position) {
    var c = position.coords;
    if (true) {
      $scope.current_location = {lon:c.longitude, lat:c.latitude};
      console.log(position);
      console.log(new Date(position.timestamp));
      window.navigator.geolocation.clearWatch( busStopLocationWatch );
      load_stops();
    }
  };

  var failedLocation = function(msg) {
    console.log('failed to get position');
  };

  var busStops = Restangular.all('api/v1/bus_stops');
  var load_stops = function(reset) {
    $scope.bus_stops = busStops.getList({center_lat: $scope.current_location.lat, center_lon: $scope.current_location.lon}).then(function(bs) {
      $scope.bus_stops = bs;
      if(reset) {
	$scope.start_bus_stop = bs[0];
	$scope.routes = bs[0].routes;
	$scope.state = 'choose_route';
      }

    });
  };

  $scope.load_map_squares = function() {
    console.log('loading map squares');
    Restangular.one('api/v1/browse/map_squares').get().then(function(data) {
      $scope.map_squares = data;
      $scope.state = 'choose_last_square';
    });
  };

  $scope.getFaves = function() {
    Restangular.one('api/v1/browse/bus_stops?faves=' + true ).get().then(function(data) {
      $scope.end_area = 'foo';
      $scope.end_areas = 'bar';
      $scope.end_bus_stops = data;
      $scope.state = 'choose_last_stop';
    });

  };

  $scope.markEndMapSquare = function(map_square) {
    $scope.end_map_square = map_square;
    Restangular.one('api/v1/browse/areas?map_square_id=' + map_square.id + '&sort=alpha' ).get().then(function(data) {
      $scope.end_areas = data;
      $scope.state = 'choose_last_area';
    });
  };

  $scope.chooseEndArea = function(area) {
    $scope.end_area = area;
    Restangular.one('api/v1/browse/bus_stops?area=' + area ).get().then(function(data) {
      $scope.end_bus_stops = data;
      $scope.state = 'choose_last_stop';
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



  $scope.startTrip = function(r) {
    $scope.route = r;
    var sp = $scope.start_bus_stop;
    var ep = $scope.end_bus_stop;
    Restangular.all('api/v1/trips').post(
      {trip:
       {bus_number: $scope.route.code,
	start_stop_id: sp.id,
	start_stop_name: sp.display_name,
	start_stop_code: sp.code,
	end_stop_id: ep.id,
	end_stop_name: ep.display_name,
	end_stop_code: ep.code
       }
      }
    ).then(function(r) {
      $scope.trip = r;
      getGeoLocation();
    });
  };

  $scope.stopTrip = function() {
    if ($scope.trip === null) {
      return false;
    }
    Restangular.one('api/v1/trips/' + $scope.trip.id + '/stop').put().then(
      function(d) {
	$window.location.href = "/";
      });
  };

  $scope.clear = function() {
    $scope.trip = null; $scope.route = null; $scope.points = []; $scope.end_bus_stop = null;
  };

  $scope.updateTrip = function(params) {
    console.log(params);
    var t = Restangular.one('api/v1/trips/' + $scope.trip.id).customPUT({trip: params}).then( function() {
      console.log("trip updated");
    });
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


  var ModalInstanceCtrl = function ($scope, $modalInstance, spottedRoute) {

    $scope.spottedRoute = spottedRoute;

    $scope.ok = function () {
      $modalInstance.close($scope.selected.item);
    };

    $scope.cancel = function () {
      $modalInstance.dismiss('cancel');
    };
  };

  $scope.open = function (route,size) {
    $scope.spottedRoute = route;
    console.log(route);
    var modalInstance = $modal.open({
      templateUrl: 'busSpot.html',
      controller: ModalInstanceCtrl,
      resolve: {
        spottedRoute: function () {
          return $scope.spottedRoute;
        }
      }
    });
  };

}]);
