bankRoller.factory('BankRollerAPI', function($resource){
   return {
       transactions: $resource('/transactions'),
       grouped_transactions: $resource('/grouped_transactions'),
       categories: $resource('/categories'),
       hints: $resource('/categories/:categoryId/hints')
   }
});

bankRoller.controller('TransactionsCtrl', function( $scope, BankRollerAPI, ngTableParams, $location, $resource, alertService) {
    BankRollerAPI.categories.get({}, function(data) { $scope.categories = data.items })

    $scope.tableParams = new ngTableParams(
        angular.extend({
            page: 1,
            count: 10,
            sorting: {
                date: 'desc'
            }
        }, $location.search()),
        {
            total: 0, // length of data
            getData: function($defer, params) {
//                    $location.search(params.url());
                BankRollerAPI.transactions.get({
                    page: params.page(),
                    per_page: params.count(),
                    sort: params.sorting()
                }, function(data) {
                    // update table params
                    params.total(data.total_entries);
                    // set new data
                    $defer.resolve(data.items);
                });
            }
        }
    );

    $scope.edit = function(key){
        if (typeof($scope.copy) !== 'undefined'){
            $scope.cancel_edit($scope.edit_key);
        }
        $scope.copy = angular.copy($scope.tableParams.data[key]);
        $scope.edit_key = key;
        $scope.tableParams.data[key].$edit = true;
    }

    $scope.cancel_edit = function(key){
        $scope.tableParams.data[key] = angular.copy($scope.copy);
        $scope.copy = undefined;
        $scope.edit_key = undefined;
    }

    $scope.save = function(key){
        $resource($scope.tableParams.data[key]._links.self.href).save(
            $scope.tableParams.data[key],
            function(){ //success function
                $scope.copy = undefined;
                $scope.edit_key = undefined;
                $scope.tableParams.data[key].$edit = false;
            },
            function(){ // error function
                $scope.cancel_edit($scope.edit_key);
                alertService.add("error", "Error saving");
            })

    }
});
