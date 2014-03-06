bankRoller.factory('BankRollerAPI', function($resource){
   return {
       transactions: $resource('/transactions'),
       grouped_transactions: $resource('/grouped_transactions'),
       categories: $resource('/categories')
   }
});

bankRoller.controller('TransactionsCtrl', function( $scope, BankRollerAPI, ngTableParams, $location, $resource, alertService) {
    $scope.alerts = [];

    BankRollerAPI.categories.get({}, function(data) { $scope.categories = data.items })
        // This is simple a demo for UI Boostrap.
//        $scope.transactions = BankRollerAPI.transactions.query();
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

    $scope.chartType = 'line';
    $scope.chartConfig = {};
    $scope.chartData = {series: ['Spent'], data: [{x: 0, y: [0], tooltip: 0}]};
    BankRollerAPI.grouped_transactions.get({}, function(data){
        $scope.chartData['data'] = [];
        for(i=0; i< data.items.length; i++){
            $scope.chartData['data'].push({x: data.items[i].date, y: [-1*data.items[i].sum], tooltip: data.items[i].sum});
        }
    });

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
