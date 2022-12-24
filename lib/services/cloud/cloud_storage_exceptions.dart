
class CloudStorageException implements Exception {

  const CloudStorageException();

}
// C in CRUD
class CouldNotCreateNoteException extends CloudStorageException{}

// R in CRUD
class CouldNotGetAllNotesException extends CloudStorageException{}

// u in CRUD
class CouldNotUpdateNoteException extends CloudStorageException{}

// D in CRUD
class CouldNotDeleteNoteException extends CloudStorageException{}



