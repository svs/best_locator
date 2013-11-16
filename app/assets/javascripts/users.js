angular.module('bestLocatorApp').controller('UsersCtrl',['$scope', function($scope) {
    $scope.trips = [
	{id: 1, from: "Dongri Pada", to: "Kalva", start_time: "", end_time: "", status: "complete", kms: 21}
        ]
    $scope.user = {name: "Sid Sharma"}
}]);
