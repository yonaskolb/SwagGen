{% include "Includes/Header.stencil" %}

import Result

public typealias APIResult<T> = Result<T, APIError>
