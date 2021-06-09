# CHANGELOG
## 2.0.0
### Features
- Added multiple inheritance support
- Extracted "private" methods from `Type` to local functions
- Added ability to delete types via `Type.delete()` or `TypeBase():delete()`
- Tests now have detailed description
- Removed redudant methods `Class(<type>):get*()` from Class API
- Added `default` case in switch statement
- Added `null` function in case of using null values in tables
## 1.4.0
### Features
- Added `switch` function statement
## 1.3.0
### Features
- Added new Class API. It's accessible from `Class` class
## 1.2.0
### Features
- Added inheritance support
- Added new field to class meta table - `extends`, which contains a reference to the parent class
- Now there is ability to retrieve specific field of meta by passing key to `Object.getMeta(key)` method
## 1.1.0
### Features
- Added `Object.getMeta()` method to get class meta info
## 1.0.0
Release version. See README.md
