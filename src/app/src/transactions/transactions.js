bankRoller.factory('BankRollerAPI', function($resource){
   return {
       transactions: $resource('/transactions')
   }
});

bankRoller.controller('TransactionsCtrl', function( $scope, BankRollerAPI, ngTableParams ) {
        // This is simple a demo for UI Boostrap.
        $scope.transactions = BankRollerAPI.transactions.query();
        $scope.tableParams = new ngTableParams({
            page: 1,            // show first page
            count: 10           // count per page
        }, {
            total: $scope.transactions.length, // length of data
            getData: function($defer, params) {
                $defer.resolve($scope.transactions.slice((params.page() - 1) * params.count(), params.page() * params.count()));
            }
        });
    });
