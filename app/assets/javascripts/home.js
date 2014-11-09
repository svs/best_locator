var bestLocatorApp = angular.module('bestLocatorApp', ['restangular','google-maps', 'ngAutocomplete','ui.bootstrap','ui.router','doowb.angular-pusher']).
config(['PusherServiceProvider',
  function(PusherServiceProvider) {
    PusherServiceProvider
      .setToken($('meta[name="pusher_app_key"]')[0].content)
      .setOptions({});
  }
]);;

bestLocatorApp.config(["$stateProvider", "$urlRouterProvider", function($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise('/');

    $stateProvider.
	state('index',
	      {url: '/', templateUrl: "index.html", controller: 'indexController'}
	     ).
	state('choose_route',
	      {url: '/stops/:id', templateUrl: "chooseRoute.html", controller: 'chooseRouteController'}
	     ).
	state('show_route',
	      {url: '/routes/:id', templateUrl: "showRoute.html", controller: 'showRouteController'}
	     );

}]);

bestLocatorApp.factory('State', ["Restangular", function(Restangular) {
    var _data = {
	desiredLocation: null
    };
    var arrivals = {};
    var service = {};
    service.setPosition = function(p) {
	_data.actualPosition = angular.copy(p);
	service.setDesiredLocation(p);
    };

    service.setDesiredLocation = function(p) {
	_data.desiredLocation = angular.copy(p);
	service.loadStops();
    };

    service.loadArrivals = function(stop_id) {
	Restangular.one('api/v1/bus_stops/'  + stop_id + '/arrivals').get().then(function(d) {
	    _.each(d.arrivals, function(a) {
		a.secondsAgo = moment(a.report_time).fromNow();
		if (_.isUndefined(arrivals[a.route_id])) {
		    arrivals[a.route_id] = {"1": null, "-1": null};
		}
		arrivals[a.route_id][a.heading + ""] = a;
	    });
	    console.log(arrivals);
	    _data.arrivals = arrivals;
	});

    };

    service.loadStops = function(reset) {
	var rBusStops = Restangular.all('api/v1/bus_stops');
	rBusStops.getList({center_lat: _data.desiredLocation.coords.latitude,
			   center_lon: _data.desiredLocation.coords.longitude}).then(function(bs) {
			       _data.busStops = bs;
			       if(reset) {
				   _data.start_bus_stop = bs[0];
				   _data.routes = bs[0].routes;
				   _data.state = 'choose_route';
			       }

			   });
    };

    service.setBusStop = function(id) {
	if (!(_.isEmpty(_data.busStops))) {
	    _data.chosenStop = _.find(_data.busStops, function(b) { return b.id === parseInt(id); });
	} else {
	    console.log('loading Bus Stop');
	    Restangular.one('api/v1/bus_stops/' +  id).get().then(function (d) {
		_data.chosenStop = d;
	    });
	}
    };

    service.setBusRoute = function(id) {
	Restangular.one('api/v1/routes/' +  id).get().then(function (d) {
	    _data.chosenRoute = d;
	});
    };



    service.data = _data;

    return service;
}]);

angular.module('bestLocatorApp').controller('indexController',["$scope", "State", function($scope, State) {
    $scope.state = State;
    var gotLocation = function(p,r){
	$scope.$apply(function() {
	    State.setPosition(p);
	    State.loadStops();
	});
    };


    if (navigator.geolocation && !State.data.desiredLocation) {
	//$scope.current_location.lat = 19.1860811;
	//$scope.current_location.lon = 72.8340963;
	//load_stops(true);
	navigator.geolocation.getCurrentPosition(gotLocation);
    } else {
    }


    $scope.startAutocomplete = "";
    $scope.startDetails = {};
    $scope.watchStartDetails = function() { return $scope.startDetails; };
    $scope.$watch($scope.watchStartDetails, function() {
	if ($scope.startDetails.geometry) {
	    State.setDesiredLocation({coords: {latitude: $scope.startDetails.geometry.location.lat(), longitude: $scope.startDetails.geometry.location.lng()}});
	};
    });


}]);


angular.module('bestLocatorApp').controller('chooseRouteController',["$scope", "State", "$stateParams", "$modal", "Pusher",
								     function($scope, State, $stateParams, $modal, Pusher) {
    $scope.data = State.data;
    console.log('setting BusStop');
    State.setBusStop($stateParams.id);
    State.loadArrivals($stateParams.id);
    Pusher.subscribe('stop-' + $stateParams.id, 'arrival', function(item) {
	State.loadArrivals($stateParams.id);
    });
    $scope.open = function (route,direction) {
	$scope.spottedRoute = route;
	console.log(route);
	var modalInstance = $modal.open({
	    templateUrl: 'busSpot.html',
	    controller: 'ModalInstanceCtrl',
	    size: 'lg',
	    resolve: {
		data: function () {
		    return {spottedRoute: $scope.spottedRoute, position: $scope.data.actualPosition, trip: $scope.data.chosenRoute,
			    direction: direction, stopId: $scope.data.chosenStop.id};
		}
	    }
	});
	modalInstance.result.then(function(direction) {
	    console.log($scope.spottedRoute, direction);
	});
    };



}]);


angular.module('bestLocatorApp').controller('showRouteController',["$scope", "State", "$stateParams", function($scope, State, $stateParams) {
    $scope.data = State.data;
    State.setBusRoute($stateParams.id);
    $scope.route = State.data.chosenRoute;
}]);


angular.module('bestLocatorApp').controller('ModalInstanceCtrl',["$scope", "$modalInstance", "data", "Restangular", function ($scope, $modalInstance, data, Restangular) {
    console.log('data',data);
    $scope.spottedRoute = data.spottedRoute;
    $scope.position = data.position;
    $scope.directions = [{direction: "1", name: $scope.spottedRoute.end_stop}, {direction: "-1", name:$scope.spottedRoute.start_stop}];
    console.log($scope.directions);
    $scope.x = {busId: null, spottedDirection: data.direction + ""};
    $scope.stopId = data.stopId;
    $scope.ok = function () {
	$modalInstance.close($scope.selected.item);
    };

    $scope.cancel = function () {
	$modalInstance.dismiss('cancel');
    };


    $scope.ready = function() {
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
			speed: c.speed,
			bus_id: $scope.x.busId,
			stop_id: $scope.stopId
		    }
		}).then(function(d) {
		    $modalInstance.close($scope.x.spottedDirection);
		});
	}
    };

}]);
