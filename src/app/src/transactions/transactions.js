bankRoller.factory('BankRollerAPI', function($resource){
   return {
       transactions: $resource('/transactions'),
       grouped_transactions: $resource('/grouped_transactions')
   }
});

bankRoller.controller('TransactionsCtrl', function( $scope, BankRollerAPI, ngTableParams, $location ) {
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
    });
