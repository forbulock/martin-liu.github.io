'use strict'
window.App = angular.module 'app', ['ngSanitize', 'ngRoute', 'ngAnimate'
, 'restangular', 'ui.bootstrap', 'headroom', 'duoshuo'
, 'config', 'm-directive', 'm-service']

angular.module 'm-service', ['m-util']
angular.module 'm-directive', ['m-util']

# Constans
App.constant 'Config', Config
App.constant 'Cache', locache
App.constant '_', _

App.config ($provide, $httpProvider, RestangularProvider) ->
  # Restangular base url
  RestangularProvider.setBaseUrl Config.uri.api
  RestangularProvider.setDefaultRequestParams('jsonp'
  , {callback: 'JSON_CALLBACK'})

  # Global http error handler
  $httpProvider.interceptors.push ($timeout, $q, $rootScope, $location) ->
    request : (config) ->
      return config || $q.when(config)
    responseError : (response) ->
      if response.data && response.data.message
        tplErrorHandler = 'partials/modal/error_handler.html'
        $rootScope.Util.createDialog tplErrorHandler
        , {message: response.data.message}, ->

      $q.reject response

App.run (AppInitService, $rootScope, $location, Config) ->
  AppInitService.init()

  $rootScope.$on '$routeChangeSuccess', ($event, current) ->
    # Baidu statistics
    if _hmt
      _hmt.push(['_trackPageview', $location.url()])
