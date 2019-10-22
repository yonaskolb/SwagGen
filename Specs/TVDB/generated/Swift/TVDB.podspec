Pod::Spec.new do |s|
    s.source_files = '*.swift'
    s.name = 'TVDB'
    s.authors = 'Yonas Kolb'
    s.summary = 'API v2 targets v1 functionality with a few minor additions. The API is accessible via https://api.thetvdb.com and provides the following REST endpoints in JSON format.
How to use this API documentation
----------------
You may browse the API routes without authentication, but if you wish to send requests to the API and see response data, then you must authenticate.
1. Obtain a JWT token by `POST`ing  to the `/login` route in the `Authentication` section with your API key and credentials.
1. Paste the JWT token from the response into the "JWT Token" field at the top of the page and click the 'Add Token' button.
You will now be able to use the remaining routes to send requests to the API and get a response.
Language Selection
----------------
Language selection is done via the `Accept-Language` header. At the moment, you may only pass one language abbreviation in the header at a time. Valid language abbreviations can be found at the `/languages` route..
Authentication
----------------
Authentication to use the API is similar to the How-to section above. Users must `POST` to the `/login` route with their API key and credentials in the following format in order to obtain a JWT token.
`{"apikey":"APIKEY","username":"USERNAME","userkey":"USERKEY"}`
Note that the username and key are ONLY required for the `/user` routes. The user's key is labled `Account Identifier` in the account section of the main site.
The token is then used in all subsequent requests by providing it in the `Authorization` header. The header will look like: `Authorization: Bearer `. Currently, the token expires after 24 hours. You can `GET` the `/refresh_token` route to extend that expiration date.
Versioning
----------------
You may request a different version of the API by including an `Accept` header in your request with the following format: `Accept:application/vnd.thetvdb.v$VERSION`. This documentation automatically uses the version seen at the top and bottom of the page.'
    s.version = '2.2.0'
    s.homepage = 'https://github.com/yonaskolb/SwagGen'
    s.source = { :git => 'git@github.com:https://github.com/yonaskolb/SwagGen.git' }
    s.ios.deployment_target = '9.0'
    s.tvos.deployment_target = '9.0'
    s.osx.deployment_target = '10.9'
    s.source_files = 'Sources/**/*.swift'
    s.dependency 'Alamofire', '~> 4.9.0'
end
