angular.module('bestLocatorApp').controller('RoutesCtrl',['$scope', 'Restangular', function($scope, Restangular) {
  Restangular.all('api/v1/routes').getList().then(function(r) {
    $scope.routes = r;
  });

  $scope.selectedRoute = null;
  var selectedRoutes = [];
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
	    map: map
	  });
	  loadedRoutes[id] = p;
	});
      };
    });
    var routesToUnload = _.difference(_.keys(loadedRoutes), $scope.selectedRoutes);
    console.log(routesToUnload);
    _.each(routesToUnload, function(id) {
      loadedRoutes[id].map = null;
    });

  };

  $scope.map = {
    center: {
      latitude: 19,
      longitude: 72.9
    },
    draggable: true,
    zoom: 11,
    events: {
      tilesloaded: function (map) {
        $scope.$apply(function () {
          $scope.mapInstance = map;
        });
      }
    }
  };
}]);
