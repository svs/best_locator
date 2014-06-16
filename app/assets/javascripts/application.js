// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require angular/angular.min
//= require lodash/lodash
//= require restangular/src/restangular.js
//= require bootstrap.min
//= require moment/moment
//= require select2/select2
//= require angular-ui-select2/src/select2.js
//= require angular-google-maps/dist/angular-google-maps.min.js
//= require_self


var bestLocatorApp = angular.module('bestLocatorApp', ['restangular','google-maps','ui.select2']);
