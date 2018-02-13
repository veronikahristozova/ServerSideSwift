// UserRouter.Swift

import Foundation
import Kitura
import CouchDB
import SwiftyJSON

public class UserRouter {
    var db: DatabaseInteraction
    
    public init(db: DatabaseInteraction) {
        self.db = db
    }
    
    public func bindAll(to router: Router) {
        addCreateUser(to: router)
    }
    private func addCreateUser(to router: Router) {
        router.post("/user/", handler: { req, res, next in
            guard let parsedBody = req.body else {
                res.status(.badRequest)
                next()
                return
            }
            switch(parsedBody) {
            case .json(let jsonBody):
                let name = jsonBody["name"].string ?? ""
                let user = User(name: name, identifier: "\(name.count)")
                self.db.addNewUser(user) { (id, revision, doc, error) in
                    if error != nil {
                        res.status(.internalServerError)
                        next()
                    } else {
                        res.status(.OK)
                        if let doc = doc {
                            res.send(json: doc)
                        } else {
                            res.send("Something is wrong in the doc")
                        }
                        next()
                    }
                }
            default:
                res.status(.badRequest)
                next()
            }
        })
    }
}
