


//class Member: Codable {
//
//    var mem_name: String
//    var mem_password: String
//    var mem_email: String
//    var mem_phone: String
//    var mem_tax: String
//    var mem_state: Int
//
//
//
//    public init(_ mem_name: String, _ mem_password: String, _ mem_email: String, _ mem_phone: String, _ mem_state: Int, _ mem_tax: String) {
//
//        self.mem_name = mem_name
//        self.mem_password = mem_password
//        self.mem_email = mem_email
//        self.mem_phone = mem_phone
//        self.mem_tax = mem_tax
//        self.mem_state = mem_state
//    }
//
//}

//傳入的名稱與sql相同
struct Member: Codable {
    var mem_name: String
    var mem_password: String
    var mem_email: String?
    var mem_phone: String?
    var mem_tax: String?
    var mem_state: Int
}
