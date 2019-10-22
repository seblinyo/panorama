console.log("Works");

mapboxgl.accessToken =
            'pk.eyJ1Ijoic2ViYXN0aWFuLWNoIiwiYSI6ImNpejkxdzZ5YzAxa2gyd21udGpmaGU0dTgifQ.IrEd_tvrl6MuypVNUGU5SQ';

        var map = new mapboxgl.Map({
            container: 'map',
            style: 'mapbox://styles/sebastian-ch/cje2r4vgm27z92rm2ea2nvglu',
            center: [13.673237, 47.402031], // starting position [lng, lat]
            zoom: 14,
            pitch: 60, // pitch in degrees
            bearing: 160, // bearing in degrees
        });