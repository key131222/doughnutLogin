

class User: Codable {
    var mem_email = ""
    var mem_password = ""
    
    init(_ mem_email: String, _ mem_password: String) {
        self.mem_email = mem_email
        self.mem_password = mem_password
    }
}
