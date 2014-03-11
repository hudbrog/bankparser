bankRoller.controller('CategoriesCtrl', function( $scope, BankRollerAPI, ngTableParams, $location, $resource, alertService) {
    $scope.categoryListTableParams = new ngTableParams(
        angular.extend({
            page: 1,
            count: 30,
            sorting: {
                name: 'asc'
            }
        }, $location.search()),
        {
            total: 0, // length of data
            getData: function($defer, params) {
                BankRollerAPI.categories.get({
                    page: params.page(),
                    per_page: params.count(),
                    sort: params.sorting()
                }, function(data) {
                    params.total(data.total_entries);
                    $defer.resolve(data.items);
                });
            }
        }
    );
    $scope.selectedCategory = undefined;
    $scope.newHint = {};

    function getHintList($defer, params){
        if (typeof($scope.selectedCategory) === 'undefined') {$defer.resolve([]);return;}
        $resource($scope.selectedCategory._links.hints.href).get({}, function(data) {
            params.total(data.total_entries);
            $defer.resolve(data.items);
        });
    }

    $scope.hintListTableParams = new ngTableParams(
        angular.extend({
            page: 1,
            count: 30,
            sorting: {
                name: 'asc'
            }
        }, $location.search()),
        {
            total: 0, // length of data
            getData: function($defer, params) {
                getHintList($defer, params);
            }
        }
    );

    $scope.reprocessAll = function(){
        BankRollerAPI.jobs.save(
            {job_type: 'reprocess_all'},
            function() {alertService.add("info", "Successfully reprocessed")},
            function() {alertService.add("error", "Error reprocessing")});
    }

    $scope.create_new = function(){
        $scope.$create = true;
    }

    $scope.save_new = function(){
        $scope.newHint.category_id = $scope.selectedCategory.id;
        $resource($scope.selectedCategory._links.hints.href).save($scope.newHint, function(){
                $scope.cancel_new();
                $scope.hintListTableParams.reload();
            },
            function(){ // error function
                $scope.cancel_new();
                alertService.add("error", "Error creating new hint");
            })
    }

    $scope.cancel_new = function(){
        $scope.newHint = {};
        $scope.$create = false;
    }

    $scope.changeSelection = function(category){
        for(var i=0;i<$scope.categoryListTableParams.data.length;i++){
            $scope.categoryListTableParams.data[i].$selected
                = category.name == $scope.categoryListTableParams.data[i].name ? true : false;
        }
        $scope.selectedCategory = category;
        $scope.hintListTableParams.reload();
    }

    $scope.edit = function(key){
        if (typeof($scope.copy) !== 'undefined'){
            $scope.cancel_edit($scope.edit_key);
        }
        $scope.copy = angular.copy($scope.hintListTableParams.data[key]);
        $scope.edit_key = key;
        $scope.hintListTableParams.data[key].$edit = true;
    }

    $scope.cancel_edit = function(key){
        $scope.hintListTableParams.data[key] = angular.copy($scope.copy);
        $scope.copy = undefined;
        $scope.edit_key = undefined;
    }

    $scope.save = function(key){
        $resource($scope.hintListTableParams.data[key]._links.self.href).save(
            $scope.hintListTableParams.data[key],
            function(){ //success function
                $scope.copy = undefined;
                $scope.edit_key = undefined;
                $scope.hintListTableParams.data[key].$edit = false;
            },
            function(){ // error function
                $scope.cancel_edit($scope.edit_key);
                alertService.add("error", "Error saving");
            })

    }
});
