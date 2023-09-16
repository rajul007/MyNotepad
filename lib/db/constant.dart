import 'package:flutter_dotenv/flutter_dotenv.dart';

var mongoURI = dotenv.get('ATLAS_URI', fallback: "");
const usersCollection = "users";
const notesCollection = "notes";
var jwt_secret = dotenv.get('JWT_SECRET', fallback: "");
