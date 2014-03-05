bankRoller.factory('alertService', function($rootScope){
    var alertService = {};

    // create an array of alerts available globally
    $rootScope.alerts = [];

    alertService.add = function(type, msg) {
        $rootScope.alerts.push({'type': type, 'msg': msg, close: function(){ alertService.closeAlert(this)}});
    };

    alertService.closeAlertIdx = function(index) {
        $rootScope.alerts.splice(index, 1);
    };

    alertService.closeAlert = function(alert) {
        this.closeAlertIdx($rootScope.alerts.indexOf(alert));
    }

    return alertService;
});