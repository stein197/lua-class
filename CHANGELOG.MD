# CHANGELOG
## [Unreleased]
- Getters and setters (via `get 'property' function() ... end`)

## [3.1.0](../../compare/3.0.3...3.1.0) - 2021-06-22
### Added
- `import` function
- `Type.setBasePath()` method to rewrite file search path
### Removed
- `TypeBase` class
## [3.0.3](../../compare/3.0.2...3.0.3) - 2021-06-20
### Added
- Apache 2 license
- Rockspec file for LuaRocks
### Fixed
- Memory tests didn't execute on unix
## [3.0.2](../../compare/3.0.1...3.0.2) - 2021-06-15
### Changed
- Class definitions. Memory usage reduced
## [3.0.1](../../compare/3.0.0...3.0.1) - 2021-06-15
### Added
- Memory usage test
- Parameter to test scripts
### Changed
- Object instantiation. Now object prototypes are saved in `__meta.__proto` entry which reduces the amount of memory usage
## [3.0.0](../../compare/2.3.0...3.0.0) - 2021-06-13
### Added
- Namespace support
- Extra method to Class API - `getName()`
## [2.3.0](../../compare/2.2.0...2.3.0) - 2021-06-12
### Added
- `Object():clone()` method
## [2.2.0](../../compare/2.1.0...2.2.0) - 2021-06-11
### Added
- Operator overloading feature
## [2.1.0](../../compare/2.0.0...2.1.0) - 2021-06-09
### Added
- Try-catch-finally clause
## [2.0.0](../../compare/1.4.0...2.0.0) - 2021-06-09
### Added
- Multiple inheritance support
- Ability to delete types via `Type.delete()` or `TypeBase():delete()`
- `default` case in switch statement
- `null` function in case of using null values in tables
### Changed
- Extracted "private" methods from `Type` to local functions
- Tests now have detailed description
### Removed
- Redudant methods `Class(<type>):get*()` from Class API
## [1.4.0](../../compare/1.3.0...1.4.0) - 2021-05-26
### Added
- `switch` function statement
## [1.3.0](../../compare/1.2.0...1.3.0) - 2021-05-21
### Added
- New Class API. It's accessible from `Class` class
## [1.2.0](../../compare/1.1.0...1.2.0) - 2021-05-21
### Added
- Inheritance support
- New field to class meta table - `extends`, which contains a reference to the parent class
- Ability to retrieve specific field of meta by passing key to `Object.getMeta(key)` method
## [1.1.0](../../compare/1.0.0...1.1.0) - 2021-05-18
### Added
- `Object.getMeta()` method to get class meta info
## [1.0.0](../../tree/1.0.0) - 2021-05-17
Release
