class Routes {
  static String BASE_URL = 'http://192.168.29.8:5001/api';
  static String IMAGE_URL = 'http://192.168.29.8:5001';
  // static String BASE_URL = 'https://atimz.mizoram.gov.in/api';
  // static String IMAGE_URL = 'https://atimz.mizoram.gov.in';
  static String LOGIN = '/login';
  static String GROUPS = '/groups';
  static String ME = '/me';
  static String SEND_OTP = '/send-otp';
  static String VERIFY_OTP = '/verify-otp';
  static String GET_DISTRICTS = '/districts';
  static String GET_DEPARTMENTS = '/departments';
  static String REGISTER = '/register';
  static String BANNER = '/banners';
  static String UPCOMING = '/upcoming';
  static String TRAININGS = '/trainings';
  static String TRAINING(String id) => '/training/$id';
  static String COURSE(String id) => '/course/$id';
  static String FAQ = '/faqs';
  static String ENROLL(String id) => '/training/$id/enrollments';
  static String LOGOUT = '/logout';
  static String GET_MY_PROFILE = '/my-profile';
  static String UPDATE_PROFILE = '/profile';

  //TRAINING
  static String ENROLLMENTS = '/enrollments';
  static String ENROLLMENT_DETAILS(String id) => '/enrollment/$id';
  static String CHECK_ENROLLMENT_STATUS(String id) => '/enrollment/$id/status';
  static String GET_COURSE_BY_PROGRAM(String id) => '/enrollment/$id/course';
  static String GET_MATERIALS(String id) => '/enrollment/$id/materials';
  static String GET_ATTENDANCE(String id) => '/enrollment/$id/attendance';
  static String MARK_ATTENDANCE = '/attendance';

  //TICKET
  static String GET_TICKETS = '/tickets';
  static String GET_TICKET_DETAILS(String id) => '/tickets/$id';
  static String REPLY_TICKET(String id) => '/ticket/$id/reply';
  static String SUBMIT_TICKET = '/tickets';

  //EVALUATION
  static String CHECK_EVALUATION_STATUS = '/evaluation/status';
  static String GET_EVALUATION_QUESTIONS = '/evaluation/questions';
  static String SAVE_EVALUATION = '/evaluation/answers';

  //CERTIFICATE
  static String CERTIFICATEANDRELEASEORDER = '/certificate-and-release-order';
  //DOCUMENTS
  static String GET_DOCUMENTS = '/documents';
  //FCM
  static String REGISTER_TOKEN = '/fcm/register-token';
}
