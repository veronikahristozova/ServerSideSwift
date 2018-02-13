// BackendRouter.swift

import Foundation
import Kitura

public class BackendRouter {
    public let router = Router()
    var db: DatabaseInteraction
    public init(db: DatabaseInteraction) {
        self.db = db
        router.get("/magic") { req, res, callNextHandler in
            res.status(.OK).send("UNICORN!")
            callNextHandler()
        }
        
        router.all("*", middleware: BodyParser())
        
        self.routeToUser()
    }
    
    func routeToUser() {
        let user = UserRouter(db: self.db)
        user.bindAll(to: self.router)
    }
}
