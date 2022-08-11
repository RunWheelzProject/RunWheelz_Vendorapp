import 'package:http/http.dart' as http;
import '../model/vendor.dart';
import '../resources/resources.dart' as res;


class StaffService {

  final Uri _getAllStaff = Uri.parse("${res.APP_URL}/api/staff/getAllStaff");

  Future<http.Response> getAllStaff() async {
    http.Response response = await http.get(_getAllStaff);
    return response;
  }

}