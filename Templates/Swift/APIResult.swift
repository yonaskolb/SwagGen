{% include "Includes/header.stencil" %}

import Result

public typealias APIResult<T> = Result<T, APIError>
