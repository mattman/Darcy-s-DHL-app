// 90% Darcy, 10% Assylum Seeker

function pathmap(coords) {
	var myLatLng = new google.maps.LatLng(0, 0);
  var opts = {
    zoom: 3,
    center: myLatLng,
    mapTypeId: google.maps.MapTypeId.TERRAIN
  };

  var pmap = new google.maps.Map(document.getElementById("pathmap"), opts);

  var pos = [];

  for ( var i=0, len=coords.length; i<len; ++i ){
	  a = coords[i].split(",");
	  coords[i] = new google.maps.LatLng(a[0],a[1]);
	}
  
  var map = new google.maps.Polyline({
    path: pos,
    strokeColor: "#FF0000",
    strokeOpacity: 1.0,
    strokeWeight: 2
  });

  pmap.setMap(map);
}