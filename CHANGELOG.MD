# CHANGELOG
## 3.0.0 - 2021-06-13
### Features
- Added namespace support
- Added extra method to Class API - `getName()`
## 2.3.0 - 2021-06-12
### Features
- Added `Object():clone()` method
## 2.2.0 - 2021-06-11
### Features
- Added operator overloading feature
## 2.1.0 - 2021-06-09
### Features
- Added try-catch-finally clause
## 2.0.0 - 2021-06-09
### Features
- Added multiple inheritance support
- Extracted "private" methods from `Type` to local functions
- Added ability to delete types via `Type.delete()` or `TypeBase():delete()`
- Tests now have detailed description
- Removed redudant methods `Class(<type>):get*()` from Class API
- Added `default` case in switch statement
- Added `null` function in case of using null values in tables
## 1.4.0 - 2021-05-26
### Features
- Added `switch` function statement
## 1.3.0 - 2021-05-21
### Features
- Added new Class API. It's accessible from `Class` class
## 1.2.0 - 2021-05-21
### Features
- Added inheritance support
- Added new field to class meta table - `extends`, which contains a reference to the parent class
- Now there is ability to retrieve specific field of meta by passing key to `Object.getMeta(key)` method
## 1.1.0 - 2021-05-18
### Features
- Added `Object.getMeta()` method to get class meta info
## 1.0.0 - 2021-05-17
Release version. See README.md
