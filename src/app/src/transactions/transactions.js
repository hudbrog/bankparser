bankRoller.factory('BankRollerAPI', function($resource){
   return {
       transactions: $resource('/transactions')
   }
});

bankRoller.controller('TransactionsCtrl', function( $scope, BankRollerAPI ) {
        // This is simple a demo for UI Boostrap.
        $scope.transactions = BankRollerAPI.transactions.query();
    });
