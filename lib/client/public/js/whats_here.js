// report errors to user
function errorHandler(error) {
 switch (error.code) { 
  case error.PERMISSION_DENIED:
    alert("Could not get position as permission was denied.");
    break;
  case error.POSITION_UNAVAILABLE:
    alert("Could not get position as this information is not available at this time.");
    break;
  case error.TIMEOUT:
    alert("Attempt to get position timed out.");
    break;
  default:
    alert("Sorry, an error occurred. Code: " + error.code + " Message: " + error.message);
    break;  
  }
}

function showPosition(position, lat, lon) {
 lat = position.coords.latitude;
 lon = position.coords.longitude;
}


function handleGeoForm() {
  $('#tw_id').keypress(function(e) {
    if(e.which == 13) {
        $('#twgeo').submit(function() {
            $('#geo_lat').val(lat);
            $('#geo_lon').val(lon);
            return true;
        });
        $('#twgeo').submit();
    }
  });
}

function getPositionFromBrowser() {
  // check browser can support geolocation, if so get the current position
  var lat = 0; var lon = 0;
  if (navigator.geolocation) {
   navigator.geolocation.getCurrentPosition(showPosition(lat, lon), errorHandler);
  }
  else {
   alert("Sorry, your browser does not support geolocation services.");
  }
  handleGeoForm();
}

$(document).ready(function() {
  
  getPositionFromBrowser();

});


