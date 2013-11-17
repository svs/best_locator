angular.module('bestLocatorApp').controller('UsersCtrl',['$scope', 'Restangular', function($scope, Restangular) {
    Restangular.all('api/v1/trips').getList().then(function(r) {
	$scope.trips = r
    });
}]);
