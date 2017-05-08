@isTest
private class GEO_MapPageControllerTest{

	@isTest
	static void staticResourceTestMethod() {
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('GEO_TestClassStaticResource');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);
		GEO_MapPageController.getCoordinatesOfInputLocation('Kansas');
	}
}