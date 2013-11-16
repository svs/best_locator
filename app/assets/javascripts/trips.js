angular.module('bestLocatorApp').controller('TripsCtrl',['$scope', 'Restangular',function($scope, Restangular) {
    $scope.current_location = {lon:72.83, lat:19.2}
    $scope.trip = {
	new: true
    }
    $scope.bus_stops = [];
}]);
