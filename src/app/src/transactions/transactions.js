bankRoller.factory('BankRollerAPI', function($resource){
   return {
       transactions: $resource('/transactions')
   }
});

bankRoller.controller('TransactionsCtrl', function( $scope, BankRollerAPI, ngTableParams ) {
        // This is simple a demo for UI Boostrap.
//        $scope.transactions = BankRollerAPI.transactions.query();
        $scope.tableParams = new ngTableParams({
            page: 1,            // show first page
            count: 10           // count per page
        }, {
            total: 0, // length of data
            getData: function($defer, params) {
                BankRollerAPI.transactions.query({page: params.page(), per_page: params.count()}, function(data) {
                    // update table params
                    params.total(data.length);
                    // set new data
                    $defer.resolve(data);
                });
//                $defer.resolve($scope.transactions.slice((params.page() - 1) * params.count(), params.page() * params.count()));
            }
        });
    });
