var bankRoller = angular.module('bankRoller', [
    'ngResource',
    'ngRoute',
    'templates-app',
    'ngTable',
    'angularCharts',
    'ui.bootstrap'
]);

bankRoller.config(function($routeProvider){
    $routeProvider.when("/", {
        templateUrl: '../../app/src/transactions/transactions.tpl.html',
        controller: 'TransactionsCtrl'
    })
})