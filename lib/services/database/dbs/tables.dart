final Map<String, String> tables = {
  'person_class_list' :
  'CREATE TABLE person_class_list('
      'person_class varchar(20) PRIMARY KEY NOT NULL, '
      'seq INTEGER );',

  'person' :
  'CREATE TABLE person (id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'firstname varchar(255) DEFAULT NULL, '
      'lastname varchar(255) DEFAULT NULL, '
      'middlename varchar(255) DEFAULT NULL, '
      'gender varchar(6) DEFAULT "" NOT NULL, '
      'birthdate varchar(16) DEFAULT NULL, '
      'document varchar(255) DEFAULT NULL, '
      'phone varchar(100) DEFAULT NULL, '
      'email varchar(160) DEFAULT NULL, '
      'photo text DEFAULT " ", '
      'citizenship varchar(100) DEFAULT NULL, '
      'class_person varchar(20) DEFAULT "Regular" REFERENCES person_class_list(person_class), '
      'comment text DEFAULT " ", '
      'created_at DATETIME DEFAULT CURRENT_TIMESTAMP, '
      'updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, '
      'deleted_at DATETIME DEFAULT NULL );',

  'person_documents' :
  'CREATE TABLE person_documents ( id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'name varchar(255) DEFAULT NULL, '
      'description varchar(255) DEFAULT NULL, '
      'id_person INTEGER DEFAULT 0 NOT NULL, '
      'created_at DATETIME DEFAULT CURRENT_TIMESTAMP, '
      'updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, '
      'deleted_at DATETIME DEFAULT NULL);',

  'trip' :
  'CREATE TABLE trip ( id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'name varchar(100) DEFAULT NULL, '
      'start_trip DATETIME DEFAULT CURRENT_TIMESTAMP, '
      'end_trip DATETIME DEFAULT CURRENT_TIMESTAMP, '
      'status TINYINT(1) DEFAULT NULL, '
      'comments text DEFAULT "", '
      'created_at DATETIME DEFAULT CURRENT_TIMESTAMP, '
      'updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, '
      'deleted_at DATETIME DEFAULT NULL); '
};