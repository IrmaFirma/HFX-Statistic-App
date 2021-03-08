class APIPath {
  static String record(String uid, String recordId) => 'users/$uid/records/$recordId';
  static String records(String uid) => 'users/$uid/records';
  static String entry({String uid, String recordId, String entryId}) => 'users/$uid/records/$recordId/entries/$entryId';
  static String entries({String uid, String recordId}) => 'users/$uid/records/$recordId/entries';
}