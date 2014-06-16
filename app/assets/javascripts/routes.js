angular.module('bestLocatorApp').controller('RoutesCtrl',['$scope', 'Restangular', function($scope, Restangular) {
  Restangular.all('api/v1/routes').getList().then(function(r) {
    $scope.routes = r;
  });

  $scope.selectedRoutes = [];
  $scope.selectedRouteInfo = {};
  var loadedRoutes = {};
  var directionsService = new google.maps.DirectionsService();

  var getDirections = function(request) {
    directionsService.route(request, function(response, status) {
      console.log(response, status);
      if (status == google.maps.DirectionsStatus.OK) {
	var directionsDisplay = new google.maps.DirectionsRenderer();;
	directionsDisplay.setMap($scope.mapInstance);
	directionsDisplay.setDirections(response);
      }
    });
  };

  $scope.loadRoute = function(ids) {
    var routesToLoad = _.difference($scope.selectedRoutes, _.keys(loadedRoutes));
    console.log("selectedRoutes", $scope.selectedRoutes, "loadedRoutes", _.keys(loadedRoutes), "routesToLoad", routesToLoad);
    _.each(routesToLoad, function(id) {
      if (loadedRoutes[id]) {
	loadedRoutes[id].map = $scope.mapInstance;
      } else {
        Restangular.one('api/v1/routes', id).get().then(function(r) {
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
	  $scope.selectedRouteInfo[id] = r;
	  loadedRoutes[id] = p;
	  console.log($scope.selectedRoutesInfo);
	});
      };
    });
    var routesToUnload = _.difference(_.keys(loadedRoutes), $scope.selectedRoutes);
    console.log(routesToUnload);
    _.each(routesToUnload, function(id) {
      console.log(loadedRoutes[id]);
      loadedRoutes[id].setMap(null);
    });

  };

  $scope.toggleTrip = function(id) {
    if (loadedRoutes[id].map) {
      loadedRoutes[id].setMap(null);
    } else {
      loadedRoutes[id].setMap($scope.mapInstance);
    }
  };

  $scope.map = {
    center: {
      latitude: 19.1,
      longitude: 73
    },
    draggable: true,
    refresh: true,
    zoom: 11,
    events: {
      tilesloaded: function (map) {
        $scope.$apply(function () {
          $scope.mapInstance = map;
        });
      },
      click: function(map, event, event_data) {
	console.log(event_data);
	var lat = event_data[0].latLng.lat();
	var lon = event_data[0].latLng.lng();
	console.log(lat,lon);
	Restangular.all('api/v1/routes?lat=' + lat + '&lon=' + lon).getList().then(function(r) {
	  console.log(r);
	  _.each(r, function(route) {
	    $scope.selectedRoutes.push(route.id);
	  });
	  $scope.loadRoute();
	});
      }

    }
  };
}]);
