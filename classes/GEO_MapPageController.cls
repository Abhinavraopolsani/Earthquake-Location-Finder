public with sharing class GEO_MapPageController  {

    public String location{get; set;}
    public static List<LocationWrapper> adHocLocations{get; set;}
    private static String apiKey = 'AIzaSyDyJcokfpD1K08LPaXKUA5ssVfFUNkwgRg';// Get an API key from https://developers.google.com/maps/documentation/javascript/get-api-key

    public PageReference getMapMarkers() {
        getCoordinatesOfInputLocation(location); 
        return null;
    }

    //Make first API callout to Google API's and deserilaize the Response. 
    public static void getCoordinatesOfInputLocation(String locationAddress) {
        Double latNorth,lonEast,latSouth,lonWest; 
        try {
            if (locationAddress != null) {
            String url = 'https://maps.googleapis.com/maps/api/geocode/json?key='+apiKey+'&address='+locationAddress+'&sensor=false';
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-type', 'application/x-www-form-urlencoded'); 
            req.setHeader('Content-length', '0'); 
            req.setEndpoint(url); 
            req.setMethod('POST');
            Http sendreq = new Http();
            HttpResponse resp = sendreq.send(req);
            System.debug('First Response===' + resp.getBody());
                if (resp.getStatusCode() == 200) {
                    GEO_JsontoApex jsonParse = (GEO_JsontoApex)JSON.deserialize(resp.getBody(), GEO_JsontoApex.class);// you can use JSON2APEX from adminbooster. 
                    latNorth = jsonParse.results[0].geometry.bounds.northeast.lat;
                    lonEast = jsonParse.results[0].geometry.bounds.northeast.lng;
                    latSouth = jsonParse.results[0].geometry.bounds.southwest.lat;
                    lonWest = jsonParse.results[0].geometry.bounds.southwest.lng;
                    System.debug('@@' + latNorth + '$$' + lonEast + '%%' + latSouth + '!!' +lonWest);
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'OOPS something went wrong please retry after some time'));
                }
                if (latNorth != null && lonEast !=null && latSouth != null && lonWest != null) {
                    getEarthquakeData(latNorth, lonEast, latSouth, lonWest);
                }   
            } 
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please reheck the input location'));  
        }      
    } 

    //Digest the parms and make second Callout deserialze the response and insert records into Wrapper class.
    //Get List of Data to display on the page
    public static void getEarthquakeData(Double ltNorth, Double lnEast, Double ltSouth, Double lnWest) {
        Map<Double, Double> earthquakeMap = new Map<Double, Double>();
        adHocLocations = new List<LocationWrapper>();
        try {
            String url = 'http://api.geonames.org/earthquakesJSON?north='+ltNorth+'&south='+ltSouth+'&east='+lnEast+'&west='+lnWest+'&username=abhinavpolsani';//Create a username in geonames org for API Calls.
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-type', 'application/x-www-form-urlencoded'); 
            req.setHeader('Content-length', '0'); 
            req.setEndpoint(url); 
            req.setMethod('POST');
            Http sendreq = new Http();
            HttpResponse resp = sendreq.send(req);
            System.debug('Second Response===' + resp.getBody());
            if (resp.getStatusCode() == 200) {
                GEO_JsontoApexEarthquake jsonParse = (GEO_JsontoApexEarthquake)JSON.deserialize(resp.getBody(), GEO_JsontoApexEarthquake.class);
                for (Integer i=0;i<jsonParse.earthquakes.size();i++) {
                    earthquakeMap.put(jsonParse.earthquakes[i].lng, jsonParse.earthquakes[i].lat);
                    adHocLocations.add(new LocationWrapper(jsonParse.earthquakes[i].lng, jsonParse.earthquakes[i].lat, jsonParse.earthquakes[i].magnitude + ' Magnitude'));
                }
                if (earthquakeMap.isEmpty()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Their is Currently no data of earthquakes for this location')); 
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Geo Names is Currently not responding on the request please retry again'));
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }

    //To display the information to the page.
    public class LocationWrapper {

        public Double lat{set; get;}
        public Double lng{set; get;}
        public String magnitude{get; set;}
        //Constructor
        public LocationWrapper(Double lat, Double lng, String magnitude) {
            this.lat = lat;
            this.lng = lng;
            this.magnitude = magnitude;
        }
    }
}