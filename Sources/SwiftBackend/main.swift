// main.swift

import Kitura
import HeliumLogger
import CouchDB

HeliumLogger.use()

let connProperties = ConnectionProperties(
    host: "127.0.0.1",  // httpd address
    port: 5984,         // httpd port
    secured: false,     // https or http
    username: "admin",  // admin username
    password: "password"// admin password
)
let db = Database(connProperties: connProperties, dbName: "swift_backend_test_db")
let databaseInteraction = DatabaseInteraction(db: db)
let app = BackendRouter(db: databaseInteraction)

Kitura.addHTTPServer(onPort: 8090, with: app.router)
Kitura.run()
