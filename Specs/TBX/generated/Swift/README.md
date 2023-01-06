# TBX

This is an api generated from a OpenAPI 3.0 spec with [SwagGen](https://github.com/yonaskolb/SwagGen)

## Operation

Each operation lives under the `TBX` namespace and within an optional tag: `TBX(.tagName).operationId`. If an operation doesn't have an operationId one will be generated from the path and method.

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

let getUserRequest = TBX.User.GetUser.Request(id: 123)
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

Each [Request](#request) also has a `makeRequest` convenience function that uses `TBX.default`.

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
There are some options to control how invalid JSON is handled when decoding and these are available as static properties on `TBX`:

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

- **Auth**
- **ContentIdentityCountry**
- **ContentProvider**
- **Customer**
- **Device**
- **DeviceObject**
- **DeviceType**
- **ErrorObject**
- **HasAccessToObject**
- **IdentityProvider**
- **MSO**
- **MultiHasAccessToObject**
- **ObjectID**
- **OverrideRuleObject**
- **ResponseError**
- **TokenObject**
- **TryAndBuyObject**
- **XAny**

## Requests

- **TBX.Auth**
	- **AuthGenerateJavascript**: GET `/auth/{cp}/auth.js`
	- **AuthGetListOfMSO**: GET `/auth/{cp}/mso.json`
	- **AuthLogin**: GET `/auth/{cp}/login.html`
	- **AuthLoginWithoutRedirect**: GET `/auth/{cp}/loginwithoutredirect.html`
	- **AuthLogout**: GET `/auth/{cp}/logout.json`
	- **AuthOauth2Assert**: GET `/auth/oauth2/assert`
	- **AuthReturnLogin**: GET `/auth/{cp}/returnlogin`
	- **AuthSamlAssertGetAuthSamlAssert**: GET `/auth/saml/assert`
	- **AuthSamlAssertPostAuthSamlAssert**: POST `/auth/saml/assert`
	- **AuthSamlLogout**: GET `/auth/saml/logout`
	- **AuthSamlMetadata**: GET `/auth/saml/metadata.xml`
	- **AuthStatus**: GET `/auth/{cp}/status.json`
- **TBX.AuthorizationService**
	- **AuthorizationServiceCreateRuleToOverrideResponse**: POST `/authorizationservices/overriderule`
	- **AuthorizationServiceCreateTryAndBuy**: POST `/authorizationservices/createtryandbuy`
	- **AuthorizationServiceDeleteRuleToOverrideResponse**: DELETE `/authorizationservices/overriderule/{ruleid}`
	- **AuthorizationServiceGetAttributes**: GET `/authorizationservices/getattributes`
	- **AuthorizationServiceGetRulesToOverrideResponse**: GET `/authorizationservices/overriderules`
	- **AuthorizationServiceGetTryAndBuy**: GET `/authorizationservices/gettryandbuy`
	- **AuthorizationServiceGetUser**: GET `/authorizationservices/getuser`
	- **AuthorizationServiceHasAccessTo**: GET `/authorizationservices/hasaccessto`
	- **AuthorizationServiceHasLogged**: GET `/authorizationservices/haslogged`
- **TBX.DeviceService**
	- **DeviceServiceActivateDevice**: POST `/deviceservices/activatedevice`
	- **DeviceServiceCreateTryAndBuy**: POST `/deviceservices/createtryandbuy`
	- **DeviceServiceDeactivateDevice**: POST `/deviceservices/deactivatedevice`
	- **DeviceServiceGetDevice**: GET `/deviceservices/getdevice`
	- **DeviceServiceHasLogged**: GET `/deviceservices/haslogged`
	- **DeviceServiceListDevices**: GET `/deviceservices/listdevices`
	- **DeviceServiceReactiveDevice**: POST `/deviceservices/reactivatedevice`
	- **DeviceServiceValidateCode**: POST `/deviceservices/validatecode`
- **TBX.UserService**
	- **UserServiceAccess**: GET `/userservices/{customer}/access`
	- **UserServiceCheckDevice**: HEAD `/userservices/device/{device}`
	- **UserServiceCreateDevice**: POST `/userservices/device`
	- **UserServiceCreateToken**: POST `/userservices/token`
	- **UserServiceCreateTryAndBuy**: POST `/userservices/{customer}/tryandbuy`
	- **UserServiceDeviceAccess**: GET `/userservices/device/{device}/access`
	- **UserServiceDeviceHasAccessTo**: GET `/userservices/device/{device}/hasaccessto`
	- **UserServiceGetCustomerDevices**: GET `/userservices/{customer}/devices`
	- **UserServiceGetDevice**: GET `/userservices/device/{device}`
	- **UserServiceGetDeviceAttributes**: GET `/userservices/device/{device}/attributes`
	- **UserServiceGetToken**: GET `/userservices/token/{token}`
	- **UserServiceGetTryAndBuy**: GET `/userservices/{customer}/tryandbuy`
	- **UserServiceHasAccessTo**: GET `/userservices/{customer}/hasaccessto`
	- **UserServiceLogout**: DELETE `/userservices/device/{device}`
	- **UserServiceLogoutAll**: DELETE `/userservices/{customer}/devices`
	- **UserServiceRemoveUserCache**: DELETE `/userservices/cache`
	- **UserServiceUpdateDevice**: PUT `/userservices/device/{device}`
	- **UserServiceUseToken**: PUT `/userservices/token/{token}`
