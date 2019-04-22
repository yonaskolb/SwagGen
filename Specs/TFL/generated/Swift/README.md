# TFL

This is an api generated from a OpenAPI 3.0 spec with [SwagGen](https://github.com/yonaskolb/SwagGen)

## Operation

Each operation lives under the `TFL` namespace and within an optional tag: `TFL(.tagName).operationId`. If an operation doesn't have an operationId one will be generated from the path and method.

Each operation has a nested `Request` and a `Response`, as well as a static `service` property

#### Service

This is the struct that contains the static information about an operation including it's id, tag, method, pre-modified path, and authorization requirements. It has a generic `ResponseType` type which maps to the `Response` type.
You shouldn't really need to interact with this service type.

#### Request

Each request is a subclass of `APIRequest` and has an `init` with a body param if it has a body, and a `options` struct for other url and path parameters. There is also a convenience init for passing parameters directly.
The `options` and `body` structs are both mutable so they can be modified before actually sending the request.

#### Response

The response is an enum of all the possible responses the request can return. it also contains getters for the `statusCode`, whether it was `successful`, and the actual decoded optional `success` response. If the operation only has one type of failure type there is also an optional `failure` type.

## Model
Models that are sent and returned from the API are mutable classes. Each model is `Equatable` and `Codable`.

`Required` properties are non optional and non-required are optional

All properties can be passed into the initializer, with `required` properties being mandatory.

If a model has `additionalProperties` it will have a subscript to access these by string

## APIClient
The `APIClient` is used to encode, authorize, send, monitor, and decode the requests. There is a `APIClient.default` that uses the default `baseURL` otherwise a custom one can be initialized:

```swift
public init(baseURL: String, sessionManager: SessionManager = .default, defaultHeaders: [String: String] = [:], behaviours: [RequestBehaviour] = [])
```

#### APIClient properties

- `baseURL`: The base url that every request `path` will be appended to
- `behaviours`: A list of [Request Behaviours](#requestbehaviour) to add to every request
- `sessionManager`: An `Alamofire.SessionManager` that can be customized
- `defaultHeaders`: Headers that will be applied to every request
- `decodingQueue`: The `DispatchQueue` to decode responses on

#### Making a request
To make a request first initialize a [Request](#request) and then pass it to `makeRequest`. The `complete` closure will be called with an `APIResponse`

```swift
func makeRequest<T>(_ request: APIRequest<T>, behaviours: [RequestBehaviour] = [], queue: DispatchQueue = DispatchQueue.main, complete: @escaping (APIResponse<T>) -> Void) -> Request? {
```

Example request (that is not neccessarily in this api):

```swift

let getUserRequest = TFL.User.GetUser.Request(id: 123)
let apiClient = APIClient.default

apiClient.makeRequest(getUserRequest) { apiResponse in
    switch apiResponse {
        case .result(let apiResponseValue):
        	if let user = apiResponseValue.success {
        		print("GetUser returned user \(user)")
        	} else {
        		print("GetUser returned \(apiResponseValue)")
        	}
        case .error(let apiError):
        	print("GetUser failed with \(apiError)")
    }
}
```

Each [Request](#request) also has a `makeRequest` convenience function that uses `TFL.shared`.

#### APIResponse
The `APIResponse` that gets passed to the completion closure contains the following properties:

- `request`: The original request
- `result`: A `Result` type either containing an `APIClientError` or the [Response](#response) of the request
- `urlRequest`: The `URLRequest` used to send the request
- `urlResponse`: The `HTTPURLResponse` that was returned by the request
- `data`: The `Data` returned by the request.
- `timeline`: The `Alamofire.Timeline` of the request which contains timing information.

#### Encoding and Decoding
Only JSON requests and responses are supported. These are encoded and decoded by `JSONEncoder` and `JSONDecoder` respectively, using Swift's `Codable` apis.
There are some options to control how invalid JSON is handled when decoding and these are available as static properties on `TFL`:

- `safeOptionalDecoding`: Whether to discard any errors when decoding optional properties. Defaults to `true`.
- `safeArrayDecoding`: Whether to remove invalid elements instead of throwing when decoding arrays. Defaults to `true`.

Dates are encoded and decoded differently according to the swagger date format. They use different `DateFormatter`'s that you can set.
- `date-time`
    - `DateTime.dateEncodingFormatter`: defaults to `yyyy-MM-dd'T'HH:mm:ss.Z`
    - `DateTime.dateDecodingFormatters`: an array of date formatters. The first one to decode successfully will be used
- `date`
    - `DateDay.dateFormatter`: defaults to `yyyy-MM-dd`

#### APIClientError
This is error enum that `APIResponse.result` may contain:

```swift
public enum APIClientError: Error {
    case unexpectedStatusCode(statusCode: Int, data: Data)
    case decodingError(DecodingError)
    case requestEncodingError(String)
    case validationError(String)
    case networkError(Error)
    case unknownError(Error)
}
```

#### RequestBehaviour
Request behaviours are used to modify, authorize, monitor or respond to requests. They can be added to the `APIClient.behaviours` for all requests, or they can passed into `makeRequest` for just that single request.

`RequestBehaviour` is a protocol you can conform to with each function being optional. As the behaviours must work across multiple different request types, they only have access to a typed erased `AnyRequest`.

```swift
public protocol RequestBehaviour {

    /// runs first and allows the requests to be modified. If modifying asynchronously use validate
    func modifyRequest(request: AnyRequest, urlRequest: URLRequest) -> URLRequest

    /// validates and modifies the request. complete must be called with either .success or .fail
    func validate(request: AnyRequest, urlRequest: URLRequest, complete: @escaping (RequestValidationResult) -> Void)

    /// called before request is sent
    func beforeSend(request: AnyRequest)

    /// called when request successfuly returns a 200 range response
    func onSuccess(request: AnyRequest, result: Any)

    /// called when request fails with an error. This will not be called if the request returns a known response even if the a status code is out of the 200 range
    func onFailure(request: AnyRequest, error: APIClientError)

    /// called if the request recieves a network response. This is not called if request fails validation or encoding
    func onResponse(request: AnyRequest, response: AnyResponse)
}
```

### Authorization
Each request has an optional `securityRequirement`. You can create a `RequestBehaviour` that checks this requirement and adds some form of authorization (usually via headers) in `validate` or `modifyRequest`. An alternative way is to set the `APIClient.defaultHeaders` which applies to all requests.

#### Reactive and Promises
To add support for a specific asynchronous library, just add an extension on `APIClient` and add a function that wraps the `makeRequest` function and converts from a closure based syntax to returning the object of choice (stream, future...ect)

## Models

- **AccidentDetail**
- **AccidentStatsOrderedSummary**
- **ActiveServiceType**
- **AdditionalProperties**
- **ApiVersionInfo**
- **Bay**
- **CarParkOccupancy**
- **Casualty**
- **Coordinate**
- **Crowding**
- **CycleSuperhighway**
- **DateRange**
- **DateRangeNullable**
- **DbGeography**
- **DbGeographyWellKnownValue**
- **Disambiguation**
- **DisambiguationOption**
- **DisruptedPoint**
- **Disruption**
- **EmissionsSurchargeVehicle**
- **Fare**
- **FareBounds**
- **FareDetails**
- **FaresMode**
- **FaresPeriod**
- **FaresSection**
- **GeoCodeSearchMatch**
- **GeoPoint**
- **GeoPointBBox**
- **Identifier**
- **Instruction**
- **InstructionStep**
- **Interval**
- **ItineraryResult**
- **Journey**
- **JourneyPlannerCycleHireDockingStationData**
- **JourneyVector**
- **JpElevation**
- **KnownJourney**
- **Leg**
- **Line**
- **LineGroup**
- **LineModeGroup**
- **LineRouteSection**
- **LineServiceType**
- **LineServiceTypeInfo**
- **LineSpecificServiceType**
- **LineStatus**
- **MatchedRoute**
- **MatchedRouteSections**
- **MatchedStop**
- **Message**
- **Mode**
- **Object**
- **Obstacle**
- **OrderedRoute**
- **PassengerFlow**
- **PassengerType**
- **Path**
- **PathAttribute**
- **Period**
- **Place**
- **PlaceCategory**
- **PlacePolygon**
- **PlannedWork**
- **Point**
- **PostcodeInput**
- **Prediction**
- **PredictionTiming**
- **Recommendation**
- **RecommendationResponse**
- **Redirect**
- **RoadCorridor**
- **RoadDisruption**
- **RoadDisruptionImpactArea**
- **RoadDisruptionLine**
- **RoadDisruptionSchedule**
- **RoadProject**
- **RouteOption**
- **RouteSearchMatch**
- **RouteSearchResponse**
- **RouteSection**
- **RouteSectionNaptanEntrySequence**
- **RouteSequence**
- **Schedule**
- **SearchCriteria**
- **SearchMatch**
- **SearchResponse**
- **ServiceFrequency**
- **StationInterval**
- **StatusSeverity**
- **StopPoint**
- **StopPointCategory**
- **StopPointRouteSection**
- **StopPointSequence**
- **StopPointsResponse**
- **Street**
- **StreetSegment**
- **Ticket**
- **TicketTime**
- **TicketType**
- **TimeAdjustment**
- **TimeAdjustments**
- **Timetable**
- **TimetableResponse**
- **TimetableRoute**
- **TrainLoading**
- **TwentyFourHourClockTime**
- **ValidityPeriod**
- **Vehicle**

## Requests

- **TFL.AccidentStats**
	- **AccidentStatsGet**: GET `/accidentstats/{year}`
- **TFL.AirQuality**
	- **AirQualityGet**: GET `/airquality`
- **TFL.BikePoint**
	- **BikePointGet**: GET `/bikepoint/{id}`
	- **BikePointGetAll**: GET `/bikepoint`
	- **BikePointSearch**: GET `/bikepoint/search`
- **TFL.Cabwise**
	- **CabwiseGet**: GET `/cabwise/search`
- **TFL.Journey**
	- **JourneyJourneyResults**: GET `/journey/journeyresults/{from}/to/{to}`
	- **JourneyMeta**: GET `/journey/meta/modes`
- **TFL.Line**
	- **GetLineStatus**: GET `/line/{ids}/status/{startdate}/to/{enddate}`
	- **LineDisruption**: GET `/line/{ids}/disruption`
	- **LineDisruptionByMode**: GET `/line/mode/{modes}/disruption`
	- **LineGet**: GET `/line/{ids}`
	- **LineGetByMode**: GET `/line/mode/{modes}`
	- **LineLineRoutesByIds**: GET `/line/{ids}/route`
	- **LineMetaDisruptionCategories**: GET `/line/meta/disruptioncategories`
	- **LineMetaModes**: GET `/line/meta/modes`
	- **LineMetaServiceTypes**: GET `/line/meta/servicetypes`
	- **LineMetaSeverity**: GET `/line/meta/severity`
	- **LineRoute**: GET `/line/route`
	- **LineRouteByMode**: GET `/line/mode/{modes}/route`
	- **LineRouteSequence**: GET `/line/{id}/route/sequence/{direction}`
	- **LineSearch**: GET `/line/search/{query}`
	- **LineStatusByIds**: GET `/line/{ids}/status`
	- **LineStatusByMode**: GET `/line/mode/{modes}/status`
	- **LineStatusBySeverity**: GET `/line/status/{severity}`
	- **LineStopPoints**: GET `/line/{id}/stoppoints`
	- **LineTimetable**: GET `/line/{id}/timetable/{fromstoppointid}`
	- **LineTimetableTo**: GET `/line/{id}/timetable/{fromstoppointid}/to/{tostoppointid}`
	- **GetLineArrivals**: GET `/line/{ids}/arrivals`
	- **GetLineArrivalsByPath**: GET `/line/{ids}/arrivals/{stoppointid}`
- **TFL.Mode**
	- **ModeArrivals**: GET `/mode/{mode}/arrivals`
	- **ModeGetActiveServiceTypes**: GET `/mode/activeservicetypes`
- **TFL.Occupancy**
	- **GetOccupant**: GET `/occupancy/carpark/{id}`
	- **GetOccupants**: GET `/occupancy/carpark`
- **TFL.Place**
	- **PlaceGet**: GET `/place/{id}`
	- **PlaceGetAt**: GET `/place/{type}/at/{lat}/{lon}`
	- **PlaceGetByGeoBox**: GET `/place`
	- **PlaceGetByType**: GET `/place/type/{types}`
	- **PlaceGetOverlay**: GET `/place/{type}/overlay/{z}/{lat}/{lon}/{width}/{height}`
	- **PlaceGetStreetsByPostCode**: GET `/place/address/streets/{postcode}`
	- **PlaceMetaCategories**: GET `/place/meta/categories`
	- **PlaceMetaPlaceTypes**: GET `/place/meta/placetypes`
	- **PlaceSearch**: GET `/place/search`
- **TFL.Road**
	- **GetRoadDisruption**: GET `/road/{ids}/disruption`
	- **RoadDisruptedStreets**: GET `/road/all/street/disruption`
	- **RoadDisruptionById**: GET `/road/all/disruption/{disruptionids}`
	- **RoadMetaCategories**: GET `/road/meta/categories`
	- **RoadMetaSeverities**: GET `/road/meta/severities`
	- **RoadStatus**: GET `/road/{ids}/status`
	- **GetRoad**: GET `/road/{ids}`
	- **GetRoads**: GET `/road`
- **TFL.Search**
	- **SearchBusSchedules**: GET `/search/busschedules`
	- **SearchGet**: GET `/search`
	- **SearchMetaCategories**: GET `/search/meta/categories`
	- **SearchMetaSearchProviders**: GET `/search/meta/searchproviders`
	- **SearchMetaSorts**: GET `/search/meta/sorts`
- **TFL.StopPoint**
	- **StopPointArrivals**: GET `/stoppoint/{id}/arrivals`
	- **StopPointCrowding**: GET `/stoppoint/{id}/crowding/{line}`
	- **StopPointDirection**: GET `/stoppoint/{id}/directionto/{tostoppointid}`
	- **StopPointDisruption**: GET `/stoppoint/{ids}/disruption`
	- **StopPointDisruptionByMode**: GET `/stoppoint/mode/{modes}/disruption`
	- **StopPointGet**: GET `/stoppoint/{ids}`
	- **StopPointGetByGeoPoint**: GET `/stoppoint`
	- **StopPointGetByMode**: GET `/stoppoint/mode/{modes}`
	- **StopPointGetBySms**: GET `/stoppoint/sms/{id}`
	- **StopPointGetByType**: GET `/stoppoint/type/{types}`
	- **StopPointGetCarParksById**: GET `/stoppoint/{stoppointid}/carparks`
	- **StopPointGetServiceTypes**: GET `/stoppoint/servicetypes`
	- **StopPointGetTaxiRanksByIds**: GET `/stoppoint/{stoppointid}/taxiranks`
	- **StopPointMetaCategories**: GET `/stoppoint/meta/categories`
	- **StopPointMetaModes**: GET `/stoppoint/meta/modes`
	- **StopPointMetaStopTypes**: GET `/stoppoint/meta/stoptypes`
	- **StopPointReachableFrom**: GET `/stoppoint/{id}/canreachonline/{lineid}`
	- **StopPointRoute**: GET `/stoppoint/{id}/route`
	- **SearchStopPoints**: GET `/stoppoint/search`
	- **SearchStopPointsByPath**: GET `/stoppoint/search/{query}`
- **TFL.TravelTime**
	- **TravelTimeGetCompareOverlay**: GET `/traveltimes/compareoverlay/{z}/mapcenter/{mapcenterlat}/{mapcenterlon}/pinlocation/{pinlat}/{pinlon}/dimensions/{width}/{height}`
	- **TravelTimeGetOverlay**: GET `/traveltimes/overlay/{z}/mapcenter/{mapcenterlat}/{mapcenterlon}/pinlocation/{pinlat}/{pinlon}/dimensions/{width}/{height}`
- **TFL.Vehicle**
	- **VehicleGet**: GET `/vehicle/{ids}/arrivals`
	- **VehicleGetVehicle**: GET `/vehicle/emissionsurcharge`
