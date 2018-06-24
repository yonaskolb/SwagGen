# TFL

This is an api generated from a Swagger 2.0 spec with [SwagGen](https://github.com/yonaskolb/SwagGen)

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
public init(baseURL: String, sessionManager: SessionManager = .default, defaultHeaders: [String: String] = [:], behaviours: [RequestBehaviour] = [], authorizer: RequestAuthorizer? = nil)
```

#### APIClient properties

- `baseURL`: The base url that every request `path` will be appended to
- `behaviours`: A list of [Request Behaviours](#requestbehaviour) to add to every request
- `sessionManager`: An `Alamofire.SessionManager` that can be customized
- `defaultHeaders`: Headers that will be applied to every request
- `authorizer`: A [RequestAuthorizer](#requestauthorizer) protocol for authorizing requests
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
- `result`: A `Result` type either containing an `APIError` or the [Response](#response) of the request
- `urlRequest`: The `URLRequest` used to send the request
- `urlResponse`: The `HTTPURLResponse` that was returned by the request
- `data`: The `Data` returned by the request.
- `timeline`: The `Alamofire.Timeline` of the request which contains timing information.

#### Encoding and Decoding
Only JSON requests and responses are supported. These are encoded and decoded by `JSONEncoder` and `JSONDecoder` respectively, using Swift's `Codable` apis.
There are some options to control how invalid JSON is handled when decoding and these are available as static properties on `TFL`:

- `safeOptionalDecoding`: Whether to discard any errors when decoding optional properties. Defaults to `true`.
- `safeArrayDecoding`: Whether to remove invalid elements instead of throwing when decoding arrays. Defaults to `true`.

#### APIError
This is error enum that `APIResponse.result` may contain:

```swift
public enum APIError: Error {
    case unexpectedStatusCode(statusCode: Int, data: Data)
    case decodingError(DecodingError)
    case invalidBaseURL(String)
    case authorizationError(AuthorizationError)
    case networkError(Error)
    case unknownError(Error)
}
```

#### RequestAuthorizer
If a [Service](#service) has an `Authorization` then `APIClient.authorizer` will be called for requests that use that service. You can set this `authorizer` property to authorize your requests using your own custom logic and storage.

`RequestAuthorizer` is a protocol with a single `authorize` function. In your authorize function you have to call `complete` with either a `.failure(reason: String)` or a `.success(authorizedRequest: URLRequest)`

```swift
/// Allows a request that has an authorization on it to be authorized asynchronously
public protocol RequestAuthorizer {

    /// complete must be called with either .success(authorizedURLRequest) or .failure(failureReason)
    func authorize(request: AnyRequest, authorization: Authorization, urlRequest: URLRequest, complete: @escaping (AuthorizationResult) -> Void)
}
```

#### RequestBehaviour
Request behaviours are used to modify, monitor or respond to requests. They can be added to the `APIClient.behaviours` for all requests, or they can passed into `makeRequest` for just that single request. 

`RequestBehaviour` is a protocol you can conform to with each function being optional. As the behaviours must work across multiple different request types, they only have access to a typed erased `AnyRequest`.

```swift
public protocol RequestBehaviour {

    /// runs first and allows the requests to be modified
    func modifyRequest(request: AnyRequest, urlRequest: URLRequest) -> URLRequest

    /// called before request is sent
    func beforeSend(request: AnyRequest)

    /// called when request successfully returns a 200 range response
    func onSuccess(request: AnyRequest, result: Any)

    /// called when request fails with an error. This will not be called if the request returns a known response even if the a status code is out of the 200 range
    func onFailure(request: AnyRequest, error: APIError)

    /// called if the request receives a network response. This is not called if request fails validation or encoding
    func onResponse(request: AnyRequest, response: AnyResponse)
}
```

While you could authorize requests with behaviours, the specialized [RequestAuthorizer](#requestauthorizer) is better suited for that purpose

#### Reactive and Promises
To add support for a specific asynchronous library, just add an extension on `APIClient` and add a function that wraps the `makeRequest` function and converts from a closure based syntax to returning the object of choice (stream, future...ect)

## Models

- `AccidentDetail`
- `AccidentStatsOrderedSummary`
- `ActiveServiceType`
- `AdditionalProperties`
- `ApiVersionInfo`
- `Bay`
- `CarParkOccupancy`
- `Casualty`
- `Coordinate`
- `Crowding`
- `CycleSuperhighway`
- `DateRange`
- `DateRangeNullable`
- `DbGeography`
- `DbGeographyWellKnownValue`
- `Disambiguation`
- `DisambiguationOption`
- `DisruptedPoint`
- `Disruption`
- `EmissionsSurchargeVehicle`
- `Fare`
- `FareBounds`
- `FareDetails`
- `FaresMode`
- `FaresPeriod`
- `FaresSection`
- `GeoCodeSearchMatch`
- `GeoPoint`
- `GeoPointBBox`
- `Identifier`
- `Instruction`
- `InstructionStep`
- `Interval`
- `ItineraryResult`
- `Journey`
- `JourneyPlannerCycleHireDockingStationData`
- `JourneyVector`
- `JpElevation`
- `KnownJourney`
- `Leg`
- `Line`
- `LineGroup`
- `LineModeGroup`
- `LineRouteSection`
- `LineServiceType`
- `LineServiceTypeInfo`
- `LineSpecificServiceType`
- `LineStatus`
- `MatchedRoute`
- `MatchedRouteSections`
- `MatchedStop`
- `Message`
- `Mode`
- `Object`
- `Obstacle`
- `OrderedRoute`
- `PassengerFlow`
- `PassengerType`
- `Path`
- `PathAttribute`
- `Period`
- `Place`
- `PlaceCategory`
- `PlacePolygon`
- `PlannedWork`
- `Point`
- `PostcodeInput`
- `Prediction`
- `PredictionTiming`
- `Recommendation`
- `RecommendationResponse`
- `Redirect`
- `RoadCorridor`
- `RoadDisruption`
- `RoadDisruptionImpactArea`
- `RoadDisruptionLine`
- `RoadDisruptionSchedule`
- `RoadProject`
- `RouteOption`
- `RouteSearchMatch`
- `RouteSearchResponse`
- `RouteSection`
- `RouteSectionNaptanEntrySequence`
- `RouteSequence`
- `Schedule`
- `SearchCriteria`
- `SearchMatch`
- `SearchResponse`
- `ServiceFrequency`
- `StationInterval`
- `StatusSeverity`
- `StopPoint`
- `StopPointCategory`
- `StopPointRouteSection`
- `StopPointSequence`
- `StopPointsResponse`
- `Street`
- `StreetSegment`
- `Ticket`
- `TicketTime`
- `TicketType`
- `TimeAdjustment`
- `TimeAdjustments`
- `Timetable`
- `TimetableResponse`
- `TimetableRoute`
- `TrainLoading`
- `TwentyFourHourClockTime`
- `ValidityPeriod`
- `Vehicle`

## Operations

- **TFL.Line**
	- `GetLineStatus`
	- `LineDisruption`
	- `LineDisruptionByMode`
	- `LineGet`
	- `LineGetByMode`
	- `LineLineRoutesByIds`
	- `LineMetaDisruptionCategories`
	- `LineMetaModes`
	- `LineMetaServiceTypes`
	- `LineMetaSeverity`
	- `LineRoute`
	- `LineRouteByMode`
	- `LineRouteSequence`
	- `LineSearch`
	- `LineStatusByIds`
	- `LineStatusByMode`
	- `LineStatusBySeverity`
	- `LineStopPoints`
	- `LineTimetable`
	- `LineTimetableTo`
	- `GetLineArrivals`
	- `GetLineArrivalsByPath`
- **TFL.AirQuality**
	- `AirQualityGet`
- **TFL.Road**
	- `GetRoadDisruption`
	- `RoadDisruptedStreets`
	- `RoadDisruptionById`
	- `RoadMetaCategories`
	- `RoadMetaSeverities`
	- `RoadStatus`
	- `GetRoad`
	- `GetRoads`
- **TFL.Mode**
	- `ModeArrivals`
	- `ModeGetActiveServiceTypes`
- **TFL.Vehicle**
	- `VehicleGet`
	- `VehicleGetVehicle`
- **TFL.StopPoint**
	- `StopPointArrivals`
	- `StopPointCrowding`
	- `StopPointDirection`
	- `StopPointDisruption`
	- `StopPointDisruptionByMode`
	- `StopPointGet`
	- `StopPointGetByGeoPoint`
	- `StopPointGetByMode`
	- `StopPointGetBySms`
	- `StopPointGetByType`
	- `StopPointGetCarParksById`
	- `StopPointGetServiceTypes`
	- `StopPointGetTaxiRanksByIds`
	- `StopPointMetaCategories`
	- `StopPointMetaModes`
	- `StopPointMetaStopTypes`
	- `StopPointReachableFrom`
	- `StopPointRoute`
	- `SearchStopPoints`
	- `SearchStopPointsByPath`
- **TFL.BikePoint**
	- `BikePointGet`
	- `BikePointGetAll`
	- `BikePointSearch`
- **TFL.TravelTime**
	- `TravelTimeGetCompareOverlay`
	- `TravelTimeGetOverlay`
- **TFL.AccidentStats**
	- `AccidentStatsGet`
- **TFL.Place**
	- `PlaceGet`
	- `PlaceGetAt`
	- `PlaceGetByGeoBox`
	- `PlaceGetByType`
	- `PlaceGetOverlay`
	- `PlaceGetStreetsByPostCode`
	- `PlaceMetaCategories`
	- `PlaceMetaPlaceTypes`
	- `PlaceSearch`
- **TFL.Search**
	- `SearchBusSchedules`
	- `SearchGet`
	- `SearchMetaCategories`
	- `SearchMetaSearchProviders`
	- `SearchMetaSorts`
- **TFL.Cabwise**
	- `CabwiseGet`
- **TFL.Journey**
	- `JourneyJourneyResults`
	- `JourneyMeta`
- **TFL.Occupancy**
	- `GetOccupant`
	- `GetOccupants`
