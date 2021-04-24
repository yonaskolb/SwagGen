# AppStoreConnect

This is an api generated from a OpenAPI 3.0 spec with [SwagGen](https://github.com/yonaskolb/SwagGen)

## Operation

Each operation lives under the `AppStoreConnect` namespace and within an optional tag: `AppStoreConnect(.tagName).operationId`. If an operation doesn't have an operationId one will be generated from the path and method.

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

let getUserRequest = AppStoreConnect.User.GetUser.Request(id: 123)
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

Each [Request](#request) also has a `makeRequest` convenience function that uses `AppStoreConnect.shared`.

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
There are some options to control how invalid JSON is handled when decoding and these are available as static properties on `AppStoreConnect`:

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

- **AgeRatingDeclaration**
- **AgeRatingDeclarationResponse**
- **AgeRatingDeclarationUpdateRequest**
- **App**
- **AppBetaTestersLinkagesRequest**
- **AppCategoriesResponse**
- **AppCategory**
- **AppCategoryResponse**
- **AppEncryptionDeclaration**
- **AppEncryptionDeclarationBuildsLinkagesRequest**
- **AppEncryptionDeclarationResponse**
- **AppEncryptionDeclarationState**
- **AppEncryptionDeclarationsResponse**
- **AppInfo**
- **AppInfoLocalization**
- **AppInfoLocalizationCreateRequest**
- **AppInfoLocalizationResponse**
- **AppInfoLocalizationUpdateRequest**
- **AppInfoLocalizationsResponse**
- **AppInfoResponse**
- **AppInfoUpdateRequest**
- **AppInfosResponse**
- **AppMediaAssetState**
- **AppMediaStateError**
- **AppPreOrder**
- **AppPreOrderCreateRequest**
- **AppPreOrderResponse**
- **AppPreOrderUpdateRequest**
- **AppPreview**
- **AppPreviewCreateRequest**
- **AppPreviewResponse**
- **AppPreviewSet**
- **AppPreviewSetAppPreviewsLinkagesRequest**
- **AppPreviewSetAppPreviewsLinkagesResponse**
- **AppPreviewSetCreateRequest**
- **AppPreviewSetResponse**
- **AppPreviewSetsResponse**
- **AppPreviewUpdateRequest**
- **AppPreviewsResponse**
- **AppPrice**
- **AppPricePoint**
- **AppPricePointResponse**
- **AppPricePointsResponse**
- **AppPriceResponse**
- **AppPriceTier**
- **AppPriceTierResponse**
- **AppPriceTiersResponse**
- **AppPricesResponse**
- **AppResponse**
- **AppScreenshot**
- **AppScreenshotCreateRequest**
- **AppScreenshotResponse**
- **AppScreenshotSet**
- **AppScreenshotSetAppScreenshotsLinkagesRequest**
- **AppScreenshotSetAppScreenshotsLinkagesResponse**
- **AppScreenshotSetCreateRequest**
- **AppScreenshotSetResponse**
- **AppScreenshotSetsResponse**
- **AppScreenshotUpdateRequest**
- **AppScreenshotsResponse**
- **AppStoreAgeRating**
- **AppStoreReviewAttachment**
- **AppStoreReviewAttachmentCreateRequest**
- **AppStoreReviewAttachmentResponse**
- **AppStoreReviewAttachmentUpdateRequest**
- **AppStoreReviewAttachmentsResponse**
- **AppStoreReviewDetail**
- **AppStoreReviewDetailCreateRequest**
- **AppStoreReviewDetailResponse**
- **AppStoreReviewDetailUpdateRequest**
- **AppStoreVersion**
- **AppStoreVersionBuildLinkageRequest**
- **AppStoreVersionBuildLinkageResponse**
- **AppStoreVersionCreateRequest**
- **AppStoreVersionLocalization**
- **AppStoreVersionLocalizationCreateRequest**
- **AppStoreVersionLocalizationResponse**
- **AppStoreVersionLocalizationUpdateRequest**
- **AppStoreVersionLocalizationsResponse**
- **AppStoreVersionPhasedRelease**
- **AppStoreVersionPhasedReleaseCreateRequest**
- **AppStoreVersionPhasedReleaseResponse**
- **AppStoreVersionPhasedReleaseUpdateRequest**
- **AppStoreVersionResponse**
- **AppStoreVersionState**
- **AppStoreVersionSubmission**
- **AppStoreVersionSubmissionCreateRequest**
- **AppStoreVersionSubmissionResponse**
- **AppStoreVersionUpdateRequest**
- **AppStoreVersionsResponse**
- **AppUpdateRequest**
- **AppsResponse**
- **BetaAppLocalization**
- **BetaAppLocalizationCreateRequest**
- **BetaAppLocalizationResponse**
- **BetaAppLocalizationUpdateRequest**
- **BetaAppLocalizationsResponse**
- **BetaAppReviewDetail**
- **BetaAppReviewDetailResponse**
- **BetaAppReviewDetailUpdateRequest**
- **BetaAppReviewDetailsResponse**
- **BetaAppReviewSubmission**
- **BetaAppReviewSubmissionCreateRequest**
- **BetaAppReviewSubmissionResponse**
- **BetaAppReviewSubmissionsResponse**
- **BetaBuildLocalization**
- **BetaBuildLocalizationCreateRequest**
- **BetaBuildLocalizationResponse**
- **BetaBuildLocalizationUpdateRequest**
- **BetaBuildLocalizationsResponse**
- **BetaGroup**
- **BetaGroupBetaTestersLinkagesRequest**
- **BetaGroupBetaTestersLinkagesResponse**
- **BetaGroupBuildsLinkagesRequest**
- **BetaGroupBuildsLinkagesResponse**
- **BetaGroupCreateRequest**
- **BetaGroupResponse**
- **BetaGroupUpdateRequest**
- **BetaGroupsResponse**
- **BetaInviteType**
- **BetaLicenseAgreement**
- **BetaLicenseAgreementResponse**
- **BetaLicenseAgreementUpdateRequest**
- **BetaLicenseAgreementsResponse**
- **BetaReviewState**
- **BetaTester**
- **BetaTesterAppsLinkagesRequest**
- **BetaTesterAppsLinkagesResponse**
- **BetaTesterBetaGroupsLinkagesRequest**
- **BetaTesterBetaGroupsLinkagesResponse**
- **BetaTesterBuildsLinkagesRequest**
- **BetaTesterBuildsLinkagesResponse**
- **BetaTesterCreateRequest**
- **BetaTesterInvitation**
- **BetaTesterInvitationCreateRequest**
- **BetaTesterInvitationResponse**
- **BetaTesterResponse**
- **BetaTestersResponse**
- **BrazilAgeRating**
- **Build**
- **BuildAppEncryptionDeclarationLinkageRequest**
- **BuildAppEncryptionDeclarationLinkageResponse**
- **BuildBetaDetail**
- **BuildBetaDetailResponse**
- **BuildBetaDetailUpdateRequest**
- **BuildBetaDetailsResponse**
- **BuildBetaGroupsLinkagesRequest**
- **BuildBetaNotification**
- **BuildBetaNotificationCreateRequest**
- **BuildBetaNotificationResponse**
- **BuildIcon**
- **BuildIconsResponse**
- **BuildIndividualTestersLinkagesRequest**
- **BuildIndividualTestersLinkagesResponse**
- **BuildResponse**
- **BuildUpdateRequest**
- **BuildsResponse**
- **BundleId**
- **BundleIdCapabilitiesResponse**
- **BundleIdCapability**
- **BundleIdCapabilityCreateRequest**
- **BundleIdCapabilityResponse**
- **BundleIdCapabilityUpdateRequest**
- **BundleIdCreateRequest**
- **BundleIdPlatform**
- **BundleIdResponse**
- **BundleIdUpdateRequest**
- **BundleIdsResponse**
- **CapabilityOption**
- **CapabilitySetting**
- **CapabilityType**
- **Certificate**
- **CertificateCreateRequest**
- **CertificateResponse**
- **CertificateType**
- **CertificatesResponse**
- **Device**
- **DeviceCreateRequest**
- **DeviceResponse**
- **DeviceUpdateRequest**
- **DevicesResponse**
- **DiagnosticLog**
- **DiagnosticLogsResponse**
- **DiagnosticSignature**
- **DiagnosticSignaturesResponse**
- **DocumentLinks**
- **EndUserLicenseAgreement**
- **EndUserLicenseAgreementCreateRequest**
- **EndUserLicenseAgreementResponse**
- **EndUserLicenseAgreementUpdateRequest**
- **ErrorResponse**
- **ExternalBetaState**
- **GameCenterEnabledVersion**
- **GameCenterEnabledVersionCompatibleVersionsLinkagesRequest**
- **GameCenterEnabledVersionCompatibleVersionsLinkagesResponse**
- **GameCenterEnabledVersionsResponse**
- **IconAssetType**
- **IdfaDeclaration**
- **IdfaDeclarationCreateRequest**
- **IdfaDeclarationResponse**
- **IdfaDeclarationUpdateRequest**
- **ImageAsset**
- **InAppPurchase**
- **InAppPurchaseResponse**
- **InAppPurchasesResponse**
- **InternalBetaState**
- **KidsAgeBand**
- **PagedDocumentLinks**
- **PagingInformation**
- **PerfPowerMetric**
- **PerfPowerMetricsResponse**
- **PhasedReleaseState**
- **Platform**
- **PreReleaseVersionsResponse**
- **PrereleaseVersion**
- **PrereleaseVersionResponse**
- **PreviewType**
- **Profile**
- **ProfileCreateRequest**
- **ProfileResponse**
- **ProfilesResponse**
- **ResourceLinks**
- **RoutingAppCoverage**
- **RoutingAppCoverageCreateRequest**
- **RoutingAppCoverageResponse**
- **RoutingAppCoverageUpdateRequest**
- **ScreenshotDisplayType**
- **TerritoriesResponse**
- **Territory**
- **TerritoryResponse**
- **UploadOperation**
- **UploadOperationHeader**
- **User**
- **UserInvitation**
- **UserInvitationCreateRequest**
- **UserInvitationResponse**
- **UserInvitationsResponse**
- **UserResponse**
- **UserRole**
- **UserUpdateRequest**
- **UserVisibleAppsLinkagesRequest**
- **UserVisibleAppsLinkagesResponse**
- **UsersResponse**

## Requests

- **AppStoreConnect.AgeRatingDeclarations**
	- **AgeRatingDeclarationsUpdateInstance**: PATCH `/v1/ageratingdeclarations/{id}`
- **AppStoreConnect.AppCategories**
	- **AppCategoriesGetCollection**: GET `/v1/appcategories`
	- **AppCategoriesGetInstance**: GET `/v1/appcategories/{id}`
	- **AppCategoriesParentGetToOneRelated**: GET `/v1/appcategories/{id}/parent`
	- **AppCategoriesSubcategoriesGetToManyRelated**: GET `/v1/appcategories/{id}/subcategories`
- **AppStoreConnect.AppEncryptionDeclarations**
	- **AppEncryptionDeclarationsAppGetToOneRelated**: GET `/v1/appencryptiondeclarations/{id}/app`
	- **AppEncryptionDeclarationsBuildsCreateToManyRelationship**: POST `/v1/appencryptiondeclarations/{id}/relationships/builds`
	- **AppEncryptionDeclarationsGetCollection**: GET `/v1/appencryptiondeclarations`
	- **AppEncryptionDeclarationsGetInstance**: GET `/v1/appencryptiondeclarations/{id}`
- **AppStoreConnect.AppInfoLocalizations**
	- **AppInfoLocalizationsCreateInstance**: POST `/v1/appinfolocalizations`
	- **AppInfoLocalizationsDeleteInstance**: DELETE `/v1/appinfolocalizations/{id}`
	- **AppInfoLocalizationsGetInstance**: GET `/v1/appinfolocalizations/{id}`
	- **AppInfoLocalizationsUpdateInstance**: PATCH `/v1/appinfolocalizations/{id}`
- **AppStoreConnect.AppInfos**
	- **AppInfosAppInfoLocalizationsGetToManyRelated**: GET `/v1/appinfos/{id}/appinfolocalizations`
	- **AppInfosGetInstance**: GET `/v1/appinfos/{id}`
	- **AppInfosPrimaryCategoryGetToOneRelated**: GET `/v1/appinfos/{id}/primarycategory`
	- **AppInfosPrimarySubcategoryOneGetToOneRelated**: GET `/v1/appinfos/{id}/primarysubcategoryone`
	- **AppInfosPrimarySubcategoryTwoGetToOneRelated**: GET `/v1/appinfos/{id}/primarysubcategorytwo`
	- **AppInfosSecondaryCategoryGetToOneRelated**: GET `/v1/appinfos/{id}/secondarycategory`
	- **AppInfosSecondarySubcategoryOneGetToOneRelated**: GET `/v1/appinfos/{id}/secondarysubcategoryone`
	- **AppInfosSecondarySubcategoryTwoGetToOneRelated**: GET `/v1/appinfos/{id}/secondarysubcategorytwo`
	- **AppInfosUpdateInstance**: PATCH `/v1/appinfos/{id}`
- **AppStoreConnect.AppPreOrders**
	- **AppPreOrdersCreateInstance**: POST `/v1/apppreorders`
	- **AppPreOrdersDeleteInstance**: DELETE `/v1/apppreorders/{id}`
	- **AppPreOrdersGetInstance**: GET `/v1/apppreorders/{id}`
	- **AppPreOrdersUpdateInstance**: PATCH `/v1/apppreorders/{id}`
- **AppStoreConnect.AppPreviews**
	- **AppPreviewsCreateInstance**: POST `/v1/apppreviews`
	- **AppPreviewsDeleteInstance**: DELETE `/v1/apppreviews/{id}`
	- **AppPreviewsGetInstance**: GET `/v1/apppreviews/{id}`
	- **AppPreviewsUpdateInstance**: PATCH `/v1/apppreviews/{id}`
- **AppStoreConnect.AppPreviewSets**
	- **AppPreviewSetsAppPreviewsGetToManyRelated**: GET `/v1/apppreviewsets/{id}/apppreviews`
	- **AppPreviewSetsAppPreviewsGetToManyRelationship**: GET `/v1/apppreviewsets/{id}/relationships/apppreviews`
	- **AppPreviewSetsAppPreviewsReplaceToManyRelationship**: PATCH `/v1/apppreviewsets/{id}/relationships/apppreviews`
	- **AppPreviewSetsCreateInstance**: POST `/v1/apppreviewsets`
	- **AppPreviewSetsDeleteInstance**: DELETE `/v1/apppreviewsets/{id}`
	- **AppPreviewSetsGetInstance**: GET `/v1/apppreviewsets/{id}`
- **AppStoreConnect.AppPricePoints**
	- **AppPricePointsGetCollection**: GET `/v1/apppricepoints`
	- **AppPricePointsGetInstance**: GET `/v1/apppricepoints/{id}`
	- **AppPricePointsTerritoryGetToOneRelated**: GET `/v1/apppricepoints/{id}/territory`
- **AppStoreConnect.AppPrices**
	- **AppPricesGetInstance**: GET `/v1/appprices/{id}`
- **AppStoreConnect.AppPriceTiers**
	- **AppPriceTiersGetCollection**: GET `/v1/apppricetiers`
	- **AppPriceTiersGetInstance**: GET `/v1/apppricetiers/{id}`
	- **AppPriceTiersPricePointsGetToManyRelated**: GET `/v1/apppricetiers/{id}/pricepoints`
- **AppStoreConnect.Apps**
	- **AppsAppInfosGetToManyRelated**: GET `/v1/apps/{id}/appinfos`
	- **AppsAppStoreVersionsGetToManyRelated**: GET `/v1/apps/{id}/appstoreversions`
	- **AppsAvailableTerritoriesGetToManyRelated**: GET `/v1/apps/{id}/availableterritories`
	- **AppsBetaAppLocalizationsGetToManyRelated**: GET `/v1/apps/{id}/betaapplocalizations`
	- **AppsBetaAppReviewDetailGetToOneRelated**: GET `/v1/apps/{id}/betaappreviewdetail`
	- **AppsBetaGroupsGetToManyRelated**: GET `/v1/apps/{id}/betagroups`
	- **AppsBetaLicenseAgreementGetToOneRelated**: GET `/v1/apps/{id}/betalicenseagreement`
	- **AppsBetaTestersDeleteToManyRelationship**: DELETE `/v1/apps/{id}/relationships/betatesters`
	- **AppsBuildsGetToManyRelated**: GET `/v1/apps/{id}/builds`
	- **AppsEndUserLicenseAgreementGetToOneRelated**: GET `/v1/apps/{id}/enduserlicenseagreement`
	- **AppsGameCenterEnabledVersionsGetToManyRelated**: GET `/v1/apps/{id}/gamecenterenabledversions`
	- **AppsGetCollection**: GET `/v1/apps`
	- **AppsGetInstance**: GET `/v1/apps/{id}`
	- **AppsInAppPurchasesGetToManyRelated**: GET `/v1/apps/{id}/inapppurchases`
	- **AppsPerfPowerMetricsGetToManyRelated**: GET `/v1/apps/{id}/perfpowermetrics`
	- **AppsPreOrderGetToOneRelated**: GET `/v1/apps/{id}/preorder`
	- **AppsPreReleaseVersionsGetToManyRelated**: GET `/v1/apps/{id}/prereleaseversions`
	- **AppsPricesGetToManyRelated**: GET `/v1/apps/{id}/prices`
	- **AppsUpdateInstance**: PATCH `/v1/apps/{id}`
- **AppStoreConnect.AppScreenshots**
	- **AppScreenshotsCreateInstance**: POST `/v1/appscreenshots`
	- **AppScreenshotsDeleteInstance**: DELETE `/v1/appscreenshots/{id}`
	- **AppScreenshotsGetInstance**: GET `/v1/appscreenshots/{id}`
	- **AppScreenshotsUpdateInstance**: PATCH `/v1/appscreenshots/{id}`
- **AppStoreConnect.AppScreenshotSets**
	- **AppScreenshotSetsAppScreenshotsGetToManyRelated**: GET `/v1/appscreenshotsets/{id}/appscreenshots`
	- **AppScreenshotSetsAppScreenshotsGetToManyRelationship**: GET `/v1/appscreenshotsets/{id}/relationships/appscreenshots`
	- **AppScreenshotSetsAppScreenshotsReplaceToManyRelationship**: PATCH `/v1/appscreenshotsets/{id}/relationships/appscreenshots`
	- **AppScreenshotSetsCreateInstance**: POST `/v1/appscreenshotsets`
	- **AppScreenshotSetsDeleteInstance**: DELETE `/v1/appscreenshotsets/{id}`
	- **AppScreenshotSetsGetInstance**: GET `/v1/appscreenshotsets/{id}`
- **AppStoreConnect.AppStoreReviewAttachments**
	- **AppStoreReviewAttachmentsCreateInstance**: POST `/v1/appstorereviewattachments`
	- **AppStoreReviewAttachmentsDeleteInstance**: DELETE `/v1/appstorereviewattachments/{id}`
	- **AppStoreReviewAttachmentsGetInstance**: GET `/v1/appstorereviewattachments/{id}`
	- **AppStoreReviewAttachmentsUpdateInstance**: PATCH `/v1/appstorereviewattachments/{id}`
- **AppStoreConnect.AppStoreReviewDetails**
	- **AppStoreReviewDetailsAppStoreReviewAttachmentsGetToManyRelated**: GET `/v1/appstorereviewdetails/{id}/appstorereviewattachments`
	- **AppStoreReviewDetailsCreateInstance**: POST `/v1/appstorereviewdetails`
	- **AppStoreReviewDetailsGetInstance**: GET `/v1/appstorereviewdetails/{id}`
	- **AppStoreReviewDetailsUpdateInstance**: PATCH `/v1/appstorereviewdetails/{id}`
- **AppStoreConnect.AppStoreVersionLocalizations**
	- **AppStoreVersionLocalizationsAppPreviewSetsGetToManyRelated**: GET `/v1/appstoreversionlocalizations/{id}/apppreviewsets`
	- **AppStoreVersionLocalizationsAppScreenshotSetsGetToManyRelated**: GET `/v1/appstoreversionlocalizations/{id}/appscreenshotsets`
	- **AppStoreVersionLocalizationsCreateInstance**: POST `/v1/appstoreversionlocalizations`
	- **AppStoreVersionLocalizationsDeleteInstance**: DELETE `/v1/appstoreversionlocalizations/{id}`
	- **AppStoreVersionLocalizationsGetInstance**: GET `/v1/appstoreversionlocalizations/{id}`
	- **AppStoreVersionLocalizationsUpdateInstance**: PATCH `/v1/appstoreversionlocalizations/{id}`
- **AppStoreConnect.AppStoreVersionPhasedReleases**
	- **AppStoreVersionPhasedReleasesCreateInstance**: POST `/v1/appstoreversionphasedreleases`
	- **AppStoreVersionPhasedReleasesDeleteInstance**: DELETE `/v1/appstoreversionphasedreleases/{id}`
	- **AppStoreVersionPhasedReleasesUpdateInstance**: PATCH `/v1/appstoreversionphasedreleases/{id}`
- **AppStoreConnect.AppStoreVersions**
	- **AppStoreVersionsAgeRatingDeclarationGetToOneRelated**: GET `/v1/appstoreversions/{id}/ageratingdeclaration`
	- **AppStoreVersionsAppStoreReviewDetailGetToOneRelated**: GET `/v1/appstoreversions/{id}/appstorereviewdetail`
	- **AppStoreVersionsAppStoreVersionLocalizationsGetToManyRelated**: GET `/v1/appstoreversions/{id}/appstoreversionlocalizations`
	- **AppStoreVersionsAppStoreVersionPhasedReleaseGetToOneRelated**: GET `/v1/appstoreversions/{id}/appstoreversionphasedrelease`
	- **AppStoreVersionsAppStoreVersionSubmissionGetToOneRelated**: GET `/v1/appstoreversions/{id}/appstoreversionsubmission`
	- **AppStoreVersionsBuildGetToOneRelated**: GET `/v1/appstoreversions/{id}/build`
	- **AppStoreVersionsBuildGetToOneRelationship**: GET `/v1/appstoreversions/{id}/relationships/build`
	- **AppStoreVersionsBuildUpdateToOneRelationship**: PATCH `/v1/appstoreversions/{id}/relationships/build`
	- **AppStoreVersionsCreateInstance**: POST `/v1/appstoreversions`
	- **AppStoreVersionsDeleteInstance**: DELETE `/v1/appstoreversions/{id}`
	- **AppStoreVersionsGetInstance**: GET `/v1/appstoreversions/{id}`
	- **AppStoreVersionsIdfaDeclarationGetToOneRelated**: GET `/v1/appstoreversions/{id}/idfadeclaration`
	- **AppStoreVersionsRoutingAppCoverageGetToOneRelated**: GET `/v1/appstoreversions/{id}/routingappcoverage`
	- **AppStoreVersionsUpdateInstance**: PATCH `/v1/appstoreversions/{id}`
- **AppStoreConnect.AppStoreVersionSubmissions**
	- **AppStoreVersionSubmissionsCreateInstance**: POST `/v1/appstoreversionsubmissions`
	- **AppStoreVersionSubmissionsDeleteInstance**: DELETE `/v1/appstoreversionsubmissions/{id}`
- **AppStoreConnect.BetaAppLocalizations**
	- **BetaAppLocalizationsAppGetToOneRelated**: GET `/v1/betaapplocalizations/{id}/app`
	- **BetaAppLocalizationsCreateInstance**: POST `/v1/betaapplocalizations`
	- **BetaAppLocalizationsDeleteInstance**: DELETE `/v1/betaapplocalizations/{id}`
	- **BetaAppLocalizationsGetCollection**: GET `/v1/betaapplocalizations`
	- **BetaAppLocalizationsGetInstance**: GET `/v1/betaapplocalizations/{id}`
	- **BetaAppLocalizationsUpdateInstance**: PATCH `/v1/betaapplocalizations/{id}`
- **AppStoreConnect.BetaAppReviewDetails**
	- **BetaAppReviewDetailsAppGetToOneRelated**: GET `/v1/betaappreviewdetails/{id}/app`
	- **BetaAppReviewDetailsGetCollection**: GET `/v1/betaappreviewdetails`
	- **BetaAppReviewDetailsGetInstance**: GET `/v1/betaappreviewdetails/{id}`
	- **BetaAppReviewDetailsUpdateInstance**: PATCH `/v1/betaappreviewdetails/{id}`
- **AppStoreConnect.BetaAppReviewSubmissions**
	- **BetaAppReviewSubmissionsBuildGetToOneRelated**: GET `/v1/betaappreviewsubmissions/{id}/build`
	- **BetaAppReviewSubmissionsCreateInstance**: POST `/v1/betaappreviewsubmissions`
	- **BetaAppReviewSubmissionsGetCollection**: GET `/v1/betaappreviewsubmissions`
	- **BetaAppReviewSubmissionsGetInstance**: GET `/v1/betaappreviewsubmissions/{id}`
- **AppStoreConnect.BetaBuildLocalizations**
	- **BetaBuildLocalizationsBuildGetToOneRelated**: GET `/v1/betabuildlocalizations/{id}/build`
	- **BetaBuildLocalizationsCreateInstance**: POST `/v1/betabuildlocalizations`
	- **BetaBuildLocalizationsDeleteInstance**: DELETE `/v1/betabuildlocalizations/{id}`
	- **BetaBuildLocalizationsGetCollection**: GET `/v1/betabuildlocalizations`
	- **BetaBuildLocalizationsGetInstance**: GET `/v1/betabuildlocalizations/{id}`
	- **BetaBuildLocalizationsUpdateInstance**: PATCH `/v1/betabuildlocalizations/{id}`
- **AppStoreConnect.BetaGroups**
	- **BetaGroupsAppGetToOneRelated**: GET `/v1/betagroups/{id}/app`
	- **BetaGroupsBetaTestersCreateToManyRelationship**: POST `/v1/betagroups/{id}/relationships/betatesters`
	- **BetaGroupsBetaTestersDeleteToManyRelationship**: DELETE `/v1/betagroups/{id}/relationships/betatesters`
	- **BetaGroupsBetaTestersGetToManyRelated**: GET `/v1/betagroups/{id}/betatesters`
	- **BetaGroupsBetaTestersGetToManyRelationship**: GET `/v1/betagroups/{id}/relationships/betatesters`
	- **BetaGroupsBuildsCreateToManyRelationship**: POST `/v1/betagroups/{id}/relationships/builds`
	- **BetaGroupsBuildsDeleteToManyRelationship**: DELETE `/v1/betagroups/{id}/relationships/builds`
	- **BetaGroupsBuildsGetToManyRelated**: GET `/v1/betagroups/{id}/builds`
	- **BetaGroupsBuildsGetToManyRelationship**: GET `/v1/betagroups/{id}/relationships/builds`
	- **BetaGroupsCreateInstance**: POST `/v1/betagroups`
	- **BetaGroupsDeleteInstance**: DELETE `/v1/betagroups/{id}`
	- **BetaGroupsGetCollection**: GET `/v1/betagroups`
	- **BetaGroupsGetInstance**: GET `/v1/betagroups/{id}`
	- **BetaGroupsUpdateInstance**: PATCH `/v1/betagroups/{id}`
- **AppStoreConnect.BetaLicenseAgreements**
	- **BetaLicenseAgreementsAppGetToOneRelated**: GET `/v1/betalicenseagreements/{id}/app`
	- **BetaLicenseAgreementsGetCollection**: GET `/v1/betalicenseagreements`
	- **BetaLicenseAgreementsGetInstance**: GET `/v1/betalicenseagreements/{id}`
	- **BetaLicenseAgreementsUpdateInstance**: PATCH `/v1/betalicenseagreements/{id}`
- **AppStoreConnect.BetaTesterInvitations**
	- **BetaTesterInvitationsCreateInstance**: POST `/v1/betatesterinvitations`
- **AppStoreConnect.BetaTesters**
	- **BetaTestersAppsDeleteToManyRelationship**: DELETE `/v1/betatesters/{id}/relationships/apps`
	- **BetaTestersAppsGetToManyRelated**: GET `/v1/betatesters/{id}/apps`
	- **BetaTestersAppsGetToManyRelationship**: GET `/v1/betatesters/{id}/relationships/apps`
	- **BetaTestersBetaGroupsCreateToManyRelationship**: POST `/v1/betatesters/{id}/relationships/betagroups`
	- **BetaTestersBetaGroupsDeleteToManyRelationship**: DELETE `/v1/betatesters/{id}/relationships/betagroups`
	- **BetaTestersBetaGroupsGetToManyRelated**: GET `/v1/betatesters/{id}/betagroups`
	- **BetaTestersBetaGroupsGetToManyRelationship**: GET `/v1/betatesters/{id}/relationships/betagroups`
	- **BetaTestersBuildsCreateToManyRelationship**: POST `/v1/betatesters/{id}/relationships/builds`
	- **BetaTestersBuildsDeleteToManyRelationship**: DELETE `/v1/betatesters/{id}/relationships/builds`
	- **BetaTestersBuildsGetToManyRelated**: GET `/v1/betatesters/{id}/builds`
	- **BetaTestersBuildsGetToManyRelationship**: GET `/v1/betatesters/{id}/relationships/builds`
	- **BetaTestersCreateInstance**: POST `/v1/betatesters`
	- **BetaTestersDeleteInstance**: DELETE `/v1/betatesters/{id}`
	- **BetaTestersGetCollection**: GET `/v1/betatesters`
	- **BetaTestersGetInstance**: GET `/v1/betatesters/{id}`
- **AppStoreConnect.BuildBetaDetails**
	- **BuildBetaDetailsBuildGetToOneRelated**: GET `/v1/buildbetadetails/{id}/build`
	- **BuildBetaDetailsGetCollection**: GET `/v1/buildbetadetails`
	- **BuildBetaDetailsGetInstance**: GET `/v1/buildbetadetails/{id}`
	- **BuildBetaDetailsUpdateInstance**: PATCH `/v1/buildbetadetails/{id}`
- **AppStoreConnect.BuildBetaNotifications**
	- **BuildBetaNotificationsCreateInstance**: POST `/v1/buildbetanotifications`
- **AppStoreConnect.Builds**
	- **BuildsAppGetToOneRelated**: GET `/v1/builds/{id}/app`
	- **BuildsAppEncryptionDeclarationGetToOneRelated**: GET `/v1/builds/{id}/appencryptiondeclaration`
	- **BuildsAppEncryptionDeclarationGetToOneRelationship**: GET `/v1/builds/{id}/relationships/appencryptiondeclaration`
	- **BuildsAppEncryptionDeclarationUpdateToOneRelationship**: PATCH `/v1/builds/{id}/relationships/appencryptiondeclaration`
	- **BuildsAppStoreVersionGetToOneRelated**: GET `/v1/builds/{id}/appstoreversion`
	- **BuildsBetaAppReviewSubmissionGetToOneRelated**: GET `/v1/builds/{id}/betaappreviewsubmission`
	- **BuildsBetaBuildLocalizationsGetToManyRelated**: GET `/v1/builds/{id}/betabuildlocalizations`
	- **BuildsBetaGroupsCreateToManyRelationship**: POST `/v1/builds/{id}/relationships/betagroups`
	- **BuildsBetaGroupsDeleteToManyRelationship**: DELETE `/v1/builds/{id}/relationships/betagroups`
	- **BuildsBuildBetaDetailGetToOneRelated**: GET `/v1/builds/{id}/buildbetadetail`
	- **BuildsDiagnosticSignaturesGetToManyRelated**: GET `/v1/builds/{id}/diagnosticsignatures`
	- **BuildsGetCollection**: GET `/v1/builds`
	- **BuildsGetInstance**: GET `/v1/builds/{id}`
	- **BuildsIconsGetToManyRelated**: GET `/v1/builds/{id}/icons`
	- **BuildsIndividualTestersCreateToManyRelationship**: POST `/v1/builds/{id}/relationships/individualtesters`
	- **BuildsIndividualTestersDeleteToManyRelationship**: DELETE `/v1/builds/{id}/relationships/individualtesters`
	- **BuildsIndividualTestersGetToManyRelated**: GET `/v1/builds/{id}/individualtesters`
	- **BuildsIndividualTestersGetToManyRelationship**: GET `/v1/builds/{id}/relationships/individualtesters`
	- **BuildsPerfPowerMetricsGetToManyRelated**: GET `/v1/builds/{id}/perfpowermetrics`
	- **BuildsPreReleaseVersionGetToOneRelated**: GET `/v1/builds/{id}/prereleaseversion`
	- **BuildsUpdateInstance**: PATCH `/v1/builds/{id}`
- **AppStoreConnect.BundleIdCapabilities**
	- **BundleIdCapabilitiesCreateInstance**: POST `/v1/bundleidcapabilities`
	- **BundleIdCapabilitiesDeleteInstance**: DELETE `/v1/bundleidcapabilities/{id}`
	- **BundleIdCapabilitiesUpdateInstance**: PATCH `/v1/bundleidcapabilities/{id}`
- **AppStoreConnect.BundleIds**
	- **BundleIdsAppGetToOneRelated**: GET `/v1/bundleids/{id}/app`
	- **BundleIdsBundleIdCapabilitiesGetToManyRelated**: GET `/v1/bundleids/{id}/bundleidcapabilities`
	- **BundleIdsCreateInstance**: POST `/v1/bundleids`
	- **BundleIdsDeleteInstance**: DELETE `/v1/bundleids/{id}`
	- **BundleIdsGetCollection**: GET `/v1/bundleids`
	- **BundleIdsGetInstance**: GET `/v1/bundleids/{id}`
	- **BundleIdsProfilesGetToManyRelated**: GET `/v1/bundleids/{id}/profiles`
	- **BundleIdsUpdateInstance**: PATCH `/v1/bundleids/{id}`
- **AppStoreConnect.Certificates**
	- **CertificatesCreateInstance**: POST `/v1/certificates`
	- **CertificatesDeleteInstance**: DELETE `/v1/certificates/{id}`
	- **CertificatesGetCollection**: GET `/v1/certificates`
	- **CertificatesGetInstance**: GET `/v1/certificates/{id}`
- **AppStoreConnect.Devices**
	- **DevicesCreateInstance**: POST `/v1/devices`
	- **DevicesGetCollection**: GET `/v1/devices`
	- **DevicesGetInstance**: GET `/v1/devices/{id}`
	- **DevicesUpdateInstance**: PATCH `/v1/devices/{id}`
- **AppStoreConnect.DiagnosticSignatures**
	- **DiagnosticSignaturesLogsGetToManyRelated**: GET `/v1/diagnosticsignatures/{id}/logs`
- **AppStoreConnect.EndUserLicenseAgreements**
	- **EndUserLicenseAgreementsCreateInstance**: POST `/v1/enduserlicenseagreements`
	- **EndUserLicenseAgreementsDeleteInstance**: DELETE `/v1/enduserlicenseagreements/{id}`
	- **EndUserLicenseAgreementsGetInstance**: GET `/v1/enduserlicenseagreements/{id}`
	- **EndUserLicenseAgreementsTerritoriesGetToManyRelated**: GET `/v1/enduserlicenseagreements/{id}/territories`
	- **EndUserLicenseAgreementsUpdateInstance**: PATCH `/v1/enduserlicenseagreements/{id}`
- **AppStoreConnect.FinanceReports**
	- **FinanceReportsGetCollection**: GET `/v1/financereports`
- **AppStoreConnect.GameCenterEnabledVersions**
	- **GameCenterEnabledVersionsCompatibleVersionsCreateToManyRelationship**: POST `/v1/gamecenterenabledversions/{id}/relationships/compatibleversions`
	- **GameCenterEnabledVersionsCompatibleVersionsDeleteToManyRelationship**: DELETE `/v1/gamecenterenabledversions/{id}/relationships/compatibleversions`
	- **GameCenterEnabledVersionsCompatibleVersionsGetToManyRelated**: GET `/v1/gamecenterenabledversions/{id}/compatibleversions`
	- **GameCenterEnabledVersionsCompatibleVersionsGetToManyRelationship**: GET `/v1/gamecenterenabledversions/{id}/relationships/compatibleversions`
	- **GameCenterEnabledVersionsCompatibleVersionsReplaceToManyRelationship**: PATCH `/v1/gamecenterenabledversions/{id}/relationships/compatibleversions`
- **AppStoreConnect.IdfaDeclarations**
	- **IdfaDeclarationsCreateInstance**: POST `/v1/idfadeclarations`
	- **IdfaDeclarationsDeleteInstance**: DELETE `/v1/idfadeclarations/{id}`
	- **IdfaDeclarationsUpdateInstance**: PATCH `/v1/idfadeclarations/{id}`
- **AppStoreConnect.InAppPurchases**
	- **InAppPurchasesGetInstance**: GET `/v1/inapppurchases/{id}`
- **AppStoreConnect.PreReleaseVersions**
	- **PreReleaseVersionsAppGetToOneRelated**: GET `/v1/prereleaseversions/{id}/app`
	- **PreReleaseVersionsBuildsGetToManyRelated**: GET `/v1/prereleaseversions/{id}/builds`
	- **PreReleaseVersionsGetCollection**: GET `/v1/prereleaseversions`
	- **PreReleaseVersionsGetInstance**: GET `/v1/prereleaseversions/{id}`
- **AppStoreConnect.Profiles**
	- **ProfilesBundleIdGetToOneRelated**: GET `/v1/profiles/{id}/bundleid`
	- **ProfilesCertificatesGetToManyRelated**: GET `/v1/profiles/{id}/certificates`
	- **ProfilesCreateInstance**: POST `/v1/profiles`
	- **ProfilesDeleteInstance**: DELETE `/v1/profiles/{id}`
	- **ProfilesDevicesGetToManyRelated**: GET `/v1/profiles/{id}/devices`
	- **ProfilesGetCollection**: GET `/v1/profiles`
	- **ProfilesGetInstance**: GET `/v1/profiles/{id}`
- **AppStoreConnect.RoutingAppCoverages**
	- **RoutingAppCoveragesCreateInstance**: POST `/v1/routingappcoverages`
	- **RoutingAppCoveragesDeleteInstance**: DELETE `/v1/routingappcoverages/{id}`
	- **RoutingAppCoveragesGetInstance**: GET `/v1/routingappcoverages/{id}`
	- **RoutingAppCoveragesUpdateInstance**: PATCH `/v1/routingappcoverages/{id}`
- **AppStoreConnect.SalesReports**
	- **SalesReportsGetCollection**: GET `/v1/salesreports`
- **AppStoreConnect.Territories**
	- **TerritoriesGetCollection**: GET `/v1/territories`
- **AppStoreConnect.UserInvitations**
	- **UserInvitationsCreateInstance**: POST `/v1/userinvitations`
	- **UserInvitationsDeleteInstance**: DELETE `/v1/userinvitations/{id}`
	- **UserInvitationsGetCollection**: GET `/v1/userinvitations`
	- **UserInvitationsGetInstance**: GET `/v1/userinvitations/{id}`
	- **UserInvitationsVisibleAppsGetToManyRelated**: GET `/v1/userinvitations/{id}/visibleapps`
- **AppStoreConnect.Users**
	- **UsersDeleteInstance**: DELETE `/v1/users/{id}`
	- **UsersGetCollection**: GET `/v1/users`
	- **UsersGetInstance**: GET `/v1/users/{id}`
	- **UsersUpdateInstance**: PATCH `/v1/users/{id}`
	- **UsersVisibleAppsCreateToManyRelationship**: POST `/v1/users/{id}/relationships/visibleapps`
	- **UsersVisibleAppsDeleteToManyRelationship**: DELETE `/v1/users/{id}/relationships/visibleapps`
	- **UsersVisibleAppsGetToManyRelated**: GET `/v1/users/{id}/visibleapps`
	- **UsersVisibleAppsGetToManyRelationship**: GET `/v1/users/{id}/relationships/visibleapps`
	- **UsersVisibleAppsReplaceToManyRelationship**: PATCH `/v1/users/{id}/relationships/visibleapps`
