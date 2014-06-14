angular.module('bestLocatorApp').controller('RoutesCtrl',['$scope', 'Restangular', function($scope, Restangular) {
  Restangular.all('api/v1/routes').getList().then(function(r) {
    $scope.routes = r;
  });

  $scope.selectedRoute = null;
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

  $scope.loadRoute = function(id) {
    console.log($scope.selectedRoute);
    Restangular.one('api/v1/routes/', $scope.selectedRoute).get().then(function(r) {
      var map = $scope.mapInstance;
      var points = [];
      _.each(r.stops, function(stop, i) {
	var lat = stop.lat;
	var lon = stop.lon;
	var position = new google.maps.LatLng(lat, lon);
	points.push(position);
      });
      new google.maps.Polyline({
	path: points,
	geodesic: true,
	strokeOpacity: 1.0,
	strokeWeight: 2,
	map: map
      });

    });
  };

  $scope.map = {
    center: {
        latitude: 19,
        longitude: 72.8
    },
    zoom: 12,
    events: {
      tilesloaded: function (map) {
        $scope.$apply(function () {
          $scope.mapInstance = map;
        });
      }
    }
  };
}]);
