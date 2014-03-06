var bankRoller = angular.module('bankRoller', [
    'ngResource',
    'ui.router',
    'templates-app',
    'ngTable',
    'angularCharts',
    'ui.bootstrap'
]);

bankRoller.config(function($stateProvider, $urlRouterProvider){
    $urlRouterProvider.otherwise("/dashboard")

//    $stateProvider
//        .state('dashboard', {
//            url: '/dashboard',
//            templateUrl: '../../app/src/dashboard/dashboard.tpl.html',
//            views: {
//                'transactions': {
//                    templateUrl: '../../app/src/transactions/transactions.tpl.html',
//                    controller: 'TransactionsCtrl'
//                },
//                'graph': {
//                    template: 'blahblah'
//                }
//            }
//        })

    $stateProvider
        .state('dashboard', {
            abstract: true,
            url: '/dashboard',
            templateUrl: '../../app/src/dashboard/dashboard.tpl.html'
        })
        .state('dashboard.transactions', {
            url: "",
//            templateUrl: '../../app/src/transactions/transactions.tpl.html',
//            controller: 'TransactionsCtrl'
            views: {
                'transactions': {
                    templateUrl: '../../app/src/transactions/transactions.tpl.html',
                    controller: 'TransactionsCtrl'
                },
                'graph': {
                    templateUrl: '../../app/src/graph/graph.tpl.html',
                    controller: 'GraphCtrl'
                }
            }
        })
})

bankRoller.run(['$rootScope', '$state', '$stateParams', function ($rootScope,   $state, $stateParams) {
    $rootScope.$state = $state;
    $rootScope.$stateParams = $stateParams;
    $state.transitionTo('dashboard.transactions');
}]);