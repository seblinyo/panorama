console.log("Works");

mapboxgl.accessToken =
            'pk.eyJ1Ijoic2ViYXN0aWFuLWNoIiwiYSI6ImNpejkxdzZ5YzAxa2gyd21udGpmaGU0dTgifQ.IrEd_tvrl6MuypVNUGU5SQ';

        var map = new mapboxgl.Map({
            container: 'map',
            style: 'mapbox://styles/mapbox/dark-v9',
            center: [13.673237, 47.402031], // starting position [lng, lat]
            zoom: 14
        });