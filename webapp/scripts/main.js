mapboxgl.accessToken =
    'pk.eyJ1Ijoic2ViYXN0aWFuLWNoIiwiYSI6ImNpejkxdzZ5YzAxa2gyd21udGpmaGU0dTgifQ.IrEd_tvrl6MuypVNUGU5SQ';

var map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/light-v10',
    center: [13.673237, 47.402031], // starting position [lng, lat]
    zoom: 15,
    pitch: 60, // pitch in degrees
    bearing: 160, // bearing in degrees
});

map.on('load', function () {

    map.addLayer({
        "id": "terrain-data",
        "type": "line",
        "source": {
            type: 'raster-dem',
            url: 'mapbox://mapbox-terrain-rgb'
        },
        "source-layer": "hillshade",
        "layout": {},
        "paint": {
            "line-color": "#aaa",
            "line-width": 1
        }
    });

    // building height extrusion
    map.addLayer({
        'id': '3d-buildings',
        'source': 'composite',
        'source-layer': 'building',
        'filter': ['==', 'extrude', 'true'],
        'type': 'fill-extrusion',
        'minzoom': 14,
        'paint': {
            'fill-extrusion-color': '#aaa',
            // interpolate for smooth zoom in transition effect
            'fill-extrusion-height': [
                "interpolate", ["linear"], ["zoom"],
                15, 0,
                15.05, ["get", "height"]
            ],

            'fill-extrusion-base': [
                "interpolate", ["linear"], ["zoom"],
                15, 0,
                15.05, ["get", "min_height"]
            ],
            'fill-extrusion-opacity': .9
        }
    });

    // zoom and rotation controls
    map.addControl(new mapboxgl.NavigationControl());


});