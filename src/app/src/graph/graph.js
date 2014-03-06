bankRoller.controller('GraphCtrl', function( $scope, BankRollerAPI) {
    $scope.chartType = 'line';
    $scope.chartConfig = {};
    $scope.chartData = {series: ['Spent'], data: [{x: 0, y: [0], tooltip: 0}]};
    BankRollerAPI.grouped_transactions.get({}, function(data){
        $scope.chartData['data'] = [];
        for(i=0; i< data.items.length; i++){
            $scope.chartData['data'].push({x: data.items[i].date, y: [-1*data.items[i].sum], tooltip: data.items[i].sum});
        }
    });
});
