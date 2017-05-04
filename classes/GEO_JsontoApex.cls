public class GEO_JsontoApex{

	public cls_results[] results;
	public String status;	//OK
	public class cls_results {
		public cls_address_components[] address_components;
		public String formatted_address;	//Texas, USA
		public cls_geometry geometry;
		public String place_id;	//ChIJSTKCCzZwQIYRPN4IGI8c6xY;
	}
	public class cls_address_components {
		public String long_name;	//Texas
		public String short_name;	//TX
	}
	public class cls_geometry {
		public cls_bounds bounds;
		public cls_location location;
		public String location_type;	//APPROXIMATE
		public cls_viewport viewport;
	}
	public class cls_bounds {
		public cls_northeast northeast;
		public cls_southwest southwest;
	}
	public class cls_northeast {
		public Double lat;	//36.5018864
		public Double lng;	//-93.5080389
	}
	public class cls_southwest {
		public Double lat;	//25.83819
		public Double lng;	//-106.6452951
	}
	public class cls_location {
		public Double lat;	//31.9685988
		public Double lng;	//-99.9018131
	}
	public class cls_viewport {
		public cls_northeast northeast;
		public cls_southwest southwest;
	}
	public static GEO_JsontoApex parse(String json){
		return (GEO_JsontoApex) System.JSON.deserialize(json, GEO_JsontoApex.class);
	}
}