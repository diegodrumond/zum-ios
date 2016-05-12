/*
 * This file is part of Zum.
 * 
 * Zum is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Zum is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Zum. If not, see <http://www.gnu.org/licenses/>.
 */

import Foundation

public enum code: Int {
    
    case none = 0
    case error = 1001
    case networkNotConnect = 1002
    case noInternetAvaliable = 1003
    case httpAccepted200 = 200
    case httpCreated201 = 201
    case httpAccepted202 = 202
    case httpBadRequest400 = 400
    case httpUnauthorized401 = 401
    case httpForbidden403 = 403
    case httpNotFound404 = 404
    case httpBadMethod405 = 405
    case httpConflict409 = 409
    case httpConsumeTypeError415 = 415
    case httpInternalError500 = 500
    case httpInternalError502 = 502
    case parseError = 1004
    
}

public class ResponseApi {
    
    public var httpCode: code = code.none
    public var description: String?
    public var success: Bool = false
    public var data: NSData?

}