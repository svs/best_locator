 angular.module('bestLocatorApp').controller('RoutesCtrl',['$scope', 'Restangular', function($scope, Restangular) {
  Restangular.all('api/v1/routes').getList().then(function(r) {
    $scope.routes = r;
  });

  $scope.selectedRoutes = [];
  $scope.selectedRouteInfo = {};
  $scope.bounds = new google.maps.LatLngBounds(
    new google.maps.LatLng(18, 71),
    new google.maps.LatLng(19, 73));

   $scope.options = {
      bounds: $scope.bounds,
      types: 'geocode',
     country: 'in',
      boundsEnabled: true,
      componentEnabled: true,
      watchEnter: true
   };
   $scope.autocomplete = "";
   $scope.details = {};
   $scope.watchDetails = function() { return $scope.details };

   $scope.$watch($scope.watchDetails, function() {
     if ($scope.details.geometry) {
       $scope.end_lat = $scope.details.geometry.location.lat();
       $scope.end_lon = $scope.details.geometry.location.lng();
       Restangular.all('api/v1/routes?lat1=' + $scope.start_bus_stop.lat + '&lon1=' + $scope.start_bus_stop.lon + '&lat2' = $scope.end_lat +  '&lon2=' + $scope.end_lon).getList().then(function(r) {
	  //console.log(r);
	  _.each(r, function(route) {
	    $scope.selectedRoutes.push(route.id);
	  });
	  $scope.loadRoute();
       });
     }
   });


  $scope.loadedRoutes = {};
  // var directionsService = new google.maps.DirectionsService();

  // var getDirections = function(request) {
  //   directionsService.route(request, function(response, status) {
  //     //console.log(response, status);
  //     if (status == google.maps.DirectionsStatus.OK) {
  // 	var directionsDisplay = new google.maps.DirectionsRenderer();;
  // 	directionsDisplay.setMap($scope.mapInstance);
  // 	directionsDisplay.setDirections(response);
  //     }
  //   });
  // };

  $scope.loadRoute = function(ids) {
    var routesToLoad = _.difference($scope.selectedRoutes, _.keys($scope.loadedRoutes));
    //console.log("selectedRoutes", $scope.selectedRoutes, "loadedRoutes", _.keys($scope.loadedRoutes), "routesToLoad", routesToLoad);
    Restangular.all('api/v1/routes', {ids: routesToLoad}).getList().then(function(result) {
      _.each(result, function(r) {
	var map = $scope.mapInstance;
	var points = [];
	_.each(r.stops, function(stop, i) {
	  var lat = stop.lat;
	  var lon = stop.lon;
	  var position = new google.maps.LatLng(lat, lon);
	  points.push(position);
	});
	var p = new google.maps.Polyline({
	  path: points,
	  geodesic: true,
	  strokeOpacity: 1.0,
	  strokeWeight: 2,
	  strokeColor: '#' + ('00000'+(Math.random()*(1<<24)|0).toString(16)).slice(-6),
	  map: map
	});
	$scope.selectedRouteInfo[r.id] = r;
	$scope.loadedRoutes[r.id] = p;
      });
    });
    var routesToUnload = _.difference(_.keys($scope.loadedRoutes), $scope.selectedRoutes);
    //console.log('routesToUnload', routesToUnload);
    _.each(routesToUnload, function(id) {
      //console.log($scope.loadedRoutes[id]);
      $scope.loadedRoutes[id].setMap(null);
    });

  };

  $scope.toggleTrip = function(id) {
    if ($scope.loadedRoutes[id].map) {
      $scope.loadedRoutes[id].setMap(null);
    } else {
      $scope.loadedRoutes[id].setMap($scope.mapInstance);
    }
  };

  $scope.map = {
    center: {
      latitude: 19.1847392698115,
      longitude: 72.8358833573683
    },
    draggable: true,
    refresh: true,
    zoom: 14,
    events: {
      tilesloaded: function (map) {
        $scope.$apply(function () {
          $scope.mapInstance = map;
        });
      },
      click: function(map, event, event_data) {
	//console.log(event_data);
	$scope.lat = event_data[0].latLng.lat();
	$scope.lon = event_data[0].latLng.lng();
	Restangular.all('api/v1/routes?lat=' + $scope.lat + '&lon=' + $scope.lon).getList().then(function(r) {
	  //console.log(r);
	  _.each(r, function(route) {
	    $scope.selectedRoutes.push(route.id);
	  });
	  $scope.loadRoute();
	});
      }

    }
  };
}]);
